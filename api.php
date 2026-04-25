<?php
/**
 * HRMS Database API
 * واجهة برمجية لنظام إدارة الموارد البشرية
 * شركة سادن
 */

// تفعيل معالجة الأخطاء
error_reporting(E_ALL);
ini_set('display_errors', 0); // لا تعرض الأخطاء للمستخدم
ini_set('log_errors', 1);
ini_set('error_log', 'php_errors.log');

// ضبط الترميز
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// معالجة طلبات OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ===================================
// إعدادات قاعدة البيانات
// ===================================

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');  // غيّر كلمة المرور إلى كلمتك الفعلية
define('DB_NAME', 'saden_hrms');

// ===================================
// فئة الاتصال بقاعدة البيانات
// ===================================

class Database {
    private $conn;
    private $error;

    public function __construct() {
        try {
            $this->conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
            
            if ($this->conn->connect_error) {
                throw new Exception("فشل الاتصال بقاعدة البيانات: " . $this->conn->connect_error);
            }
            
            // ضبط الترميز
            $this->conn->set_charset("utf8mb4");
        } catch (Exception $e) {
            $this->handleError($e->getMessage());
        }
    }

    public function getConnection() {
        return $this->conn;
    }

    public function handleError($message) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => $message]);
        exit();
    }

    public function close() {
        if ($this->conn) {
            $this->conn->close();
        }
    }
}

// ===================================
// فئة الموظفين
// ===================================

class Employee {
    private $db;
    private $conn;

    public function __construct($database) {
        $this->db = $database;
        $this->conn = $database->getConnection();
    }

    // الحصول على الموظفين
    public function getEmployees($filters = []) {
        $query = "SELECT * FROM employees WHERE 1=1";

        if (isset($filters['status'])) {
            $status = $this->conn->real_escape_string($filters['status']);
            $query .= " AND status = '$status'";
        }

        if (isset($filters['dept_id'])) {
            $dept_id = intval($filters['dept_id']);
            $query .= " AND dept_id = $dept_id";
        }

        if (isset($filters['search'])) {
            $search = $this->conn->real_escape_string($filters['search']);
            $query .= " AND (emp_name LIKE '%$search%' OR emp_number LIKE '%$search%')";
        }

        $query .= " ORDER BY emp_number ASC";

        $result = $this->conn->query($query);
        if (!$result) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        $employees = [];
        while ($row = $result->fetch_assoc()) {
            // تحويل BLOB إلى base64 إذا كانت صورة
            if (!empty($row['profile_pic'])) {
                $row['profile_pic'] = 'data:image/jpeg;base64,' . base64_encode($row['profile_pic']);
            }
            $employees[] = $row;
        }

        return ['success' => true, 'data' => $employees];
    }

    // الحصول على موظف واحد
    public function getEmployee($emp_id) {
        $emp_id = intval($emp_id);
        $query = "SELECT * FROM employees WHERE emp_id = $emp_id";
        
        $result = $this->conn->query($query);
        if (!$result || $result->num_rows === 0) {
            return ['success' => false, 'message' => 'الموظف غير موجود'];
        }

        $employee = $result->fetch_assoc();
        if (!empty($employee['profile_pic'])) {
            $employee['profile_pic'] = 'data:image/jpeg;base64,' . base64_encode($employee['profile_pic']);
        }

        // الحصول على التقييمات
        $evaluations = $this->getEmployeeEvaluations($emp_id);
        $employee['evaluations'] = $evaluations['data'] ?? [];

        // حساب رصيد الإجازات
        $vacation_balance = $this->calculateVacationBalance($emp_id);
        $employee['vacation_balance'] = $vacation_balance;

        return ['success' => true, 'data' => $employee];
    }

    // إضافة موظف جديد
    public function addEmployee($data) {
        // الحصول على رقم الموظف التالي
        $emp_number = $this->getNextEmployeeNumber();

        // تحضير البيانات
        $emp_name = $this->conn->real_escape_string($data['emp_name']);
        $emp_national = $this->conn->real_escape_string($data['emp_national'] ?? '');
        $gender = $this->conn->real_escape_string($data['gender'] ?? '');
        $phone_number = $this->conn->real_escape_string($data['phone_number'] ?? '');
        $email = $this->conn->real_escape_string($data['email'] ?? '');
        $join_date = $this->conn->real_escape_string($data['join_date']);
        
        $dept_id = isset($data['dept_id']) ? intval($data['dept_id']) : 'NULL';
        $position_id = isset($data['position_id']) ? intval($data['position_id']) : 'NULL';
        $manager_id = isset($data['direct_manager_id']) ? intval($data['direct_manager_id']) : 'NULL';
        $base_salary = isset($data['base_salary']) ? floatval($data['base_salary']) : 0;

        // التعامل مع صورة الملف الشخصي
        $profile_pic = 'NULL';
        if (!empty($data['profile_pic'])) {
            // إزالة رأس البيانات (data:image/jpeg;base64,)
            $base64_image = preg_replace('/^data:image\/\w+;base64,/', '', $data['profile_pic']);
            $profile_pic_binary = base64_decode($base64_image);
            $profile_pic = "'" . $this->conn->real_escape_string($profile_pic_binary) . "'";
        }

        $query = "INSERT INTO employees (
            emp_number, emp_name, emp_national, gender, phone_number, email,
            join_date, dept_id, position_id, direct_manager_id, base_salary, profile_pic
        ) VALUES (
            '$emp_number', '$emp_name', '$emp_national', '$gender', '$phone_number', '$email',
            '$join_date', $dept_id, $position_id, $manager_id, $base_salary, $profile_pic
        )";

        if (!$this->conn->query($query)) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        return ['success' => true, 'data' => ['emp_id' => $this->conn->insert_id, 'emp_number' => $emp_number]];
    }

    // تحديث بيانات الموظف
    public function updateEmployee($emp_id, $data) {
        $emp_id = intval($emp_id);
        $updates = [];

        // الحقول المسموحة للتحديث
        $allowed_fields = [
            'emp_name', 'emp_national', 'gender', 'phone_number', 'email', 'address',
            'edu_degree', 'university', 'join_date', 'dept_id', 'position_id',
            'direct_manager_id', 'base_salary', 'housing_allowance', 'transport_allowance',
            'work_type', 'contract_type', 'contract_start', 'contract_end', 'last_return_date'
        ];

        foreach ($allowed_fields as $field) {
            if (isset($data[$field])) {
                $value = $this->conn->real_escape_string($data[$field]);
                $updates[] = "`$field` = '$value'";
            }
        }

        if (empty($updates)) {
            return ['success' => false, 'message' => 'لا توجد بيانات للتحديث'];
        }

        // معالجة صورة الملف الشخصي
        if (!empty($data['profile_pic'])) {
            $base64_image = preg_replace('/^data:image\/\w+;base64,/', '', $data['profile_pic']);
            $profile_pic_binary = base64_decode($base64_image);
            $updates[] = "profile_pic = '" . $this->conn->real_escape_string($profile_pic_binary) . "'";
        }

        $query = "UPDATE employees SET " . implode(', ', $updates) . " WHERE emp_id = $emp_id";

        if (!$this->conn->query($query)) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        return ['success' => true, 'message' => 'تم تحديث البيانات بنجاح'];
    }

    // حذف موظف
    public function deleteEmployee($emp_id) {
        $emp_id = intval($emp_id);
        $query = "UPDATE employees SET status = 'inactive' WHERE emp_id = $emp_id";

        if (!$this->conn->query($query)) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        return ['success' => true, 'message' => 'تم حذف الموظف بنجاح'];
    }

    // الحصول على رقم الموظف التالي
    public function getNextEmployeeNumber() {
        $query = "SELECT MAX(CAST(emp_number AS UNSIGNED)) as max_number FROM employees";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return '1001';
        }

        $row = $result->fetch_assoc();
        $max_number = $row['max_number'] ?? 1000;
        
        return (string)($max_number + 1);
    }

    // الحصول على تقييمات الموظف
    public function getEmployeeEvaluations($emp_id) {
        $emp_id = intval($emp_id);
        $query = "SELECT * FROM evaluations WHERE emp_id = $emp_id ORDER BY from_date DESC";

        $result = $this->conn->query($query);
        if (!$result) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        $evaluations = [];
        while ($row = $result->fetch_assoc()) {
            $evaluations[] = $row;
        }

        return ['success' => true, 'data' => $evaluations];
    }

    // إضافة تقييم
    public function addEvaluation($emp_id, $data) {
        $emp_id = intval($emp_id);
        $from_date = $this->conn->real_escape_string($data['from_date']);
        $to_date = $this->conn->real_escape_string($data['to_date']);
        $period_type = $this->conn->real_escape_string($data['period_type']);
        $rating = intval($data['rating']);
        $notes = $this->conn->real_escape_string($data['notes'] ?? '');
        $evaluator_id = isset($data['evaluator_id']) ? intval($data['evaluator_id']) : 'NULL';

        $query = "INSERT INTO evaluations (emp_id, from_date, to_date, period_type, rating, notes, evaluator_id)
                  VALUES ($emp_id, '$from_date', '$to_date', '$period_type', $rating, '$notes', $evaluator_id)";

        if (!$this->conn->query($query)) {
            return ['success' => false, 'message' => $this->conn->error];
        }

        return ['success' => true, 'data' => ['eval_id' => $this->conn->insert_id]];
    }

    // حساب رصيد الإجازات
    public function calculateVacationBalance($emp_id) {
        $emp_id = intval($emp_id);
        $query = "SELECT join_date, last_return_date FROM employees WHERE emp_id = $emp_id";
        
        $result = $this->conn->query($query);
        if (!$result || $result->num_rows === 0) {
            return 0;
        }

        $employee = $result->fetch_assoc();
        $join_date = strtotime($employee['join_date']);
        $last_return_date = $employee['last_return_date'] ? strtotime($employee['last_return_date']) : time();
        $today = time();

        // حساب سنوات الخدمة
        $years_of_service = floor((time() - $join_date) / (365 * 24 * 3600));

        // تحديد الإجازة السنوية (القانون السعودي)
        if ($years_of_service < 5) {
            $annual_vacation = 21;
        } elseif ($years_of_service < 10) {
            $annual_vacation = 22;
        } else {
            $annual_vacation = 30;
        }

        // حساب الأيام التراكمية
        $days_since_return = floor(($today - $last_return_date) / (24 * 3600));
        $vacation_balance = ($days_since_return / 365) * $annual_vacation;
        $vacation_balance = min($vacation_balance, $annual_vacation);

        return round($vacation_balance, 2);
    }
}

// ===================================
// معالجة الطلبات
// ===================================

$database = new Database();
$employee = new Employee($database);

$request_method = $_SERVER['REQUEST_METHOD'];
$path_parts = explode('/', trim($_SERVER['PATH_INFO'] ?? '/employees', '/'));
$resource = $path_parts[0] ?? '';
$id = $path_parts[1] ?? null;

$response = ['success' => false, 'message' => 'طلب غير صالح'];

try {
    if ($resource === 'employees') {
        if ($request_method === 'GET') {
            if ($id) {
                $response = $employee->getEmployee($id);
            } else {
                $filters = [];
                if (isset($_GET['status'])) $filters['status'] = $_GET['status'];
                if (isset($_GET['dept_id'])) $filters['dept_id'] = $_GET['dept_id'];
                if (isset($_GET['search'])) $filters['search'] = $_GET['search'];
                $response = $employee->getEmployees($filters);
            }
        } elseif ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            $response = $employee->addEmployee($data);
        } elseif ($request_method === 'PUT' && $id) {
            $data = json_decode(file_get_contents('php://input'), true);
            $response = $employee->updateEmployee($id, $data);
        } elseif ($request_method === 'DELETE' && $id) {
            $response = $employee->deleteEmployee($id);
        }
    } elseif ($resource === 'evaluations' && $id) {
        if ($request_method === 'GET') {
            $response = $employee->getEmployeeEvaluations($id);
        } elseif ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            $response = $employee->addEvaluation($id, $data);
        }
    } elseif ($resource === 'vacation' && $id) {
        if ($request_method === 'GET') {
            $balance = $employee->calculateVacationBalance($id);
            $response = ['success' => true, 'data' => ['vacation_balance' => $balance]];
        }
    }
} catch (Exception $e) {
    $response = ['success' => false, 'message' => $e->getMessage()];
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
$database->close();
?>
