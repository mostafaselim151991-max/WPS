-- ===================================
-- قاعدة بيانات نظام إدارة الموارد البشرية
-- شركة سادن
-- ===================================

-- ===================================
-- 1. جدول الإدارات (Departments)
-- ===================================
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    dept_code VARCHAR(20) UNIQUE,
    manager_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ===================================
-- 2. جدول المسميات الوظيفية (Positions)
-- ===================================
CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL UNIQUE,
    position_code VARCHAR(20) UNIQUE,
    description TEXT,
    salary_level INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ===================================
-- 3. جدول الموظفين (Employees)
-- ===================================
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_number VARCHAR(20) NOT NULL UNIQUE,  -- الرقم الوظيفي (1001, 1002, 1003 الخ)
    emp_name VARCHAR(100) NOT NULL,
    id_number VARCHAR(20),  -- رقم الهوية
    pass_number VARCHAR(20),  -- رقم الجواز
    emp_national VARCHAR(50),  -- الجنسية
    gender VARCHAR(10),  -- الجنس (ذكر/أنثى)
    date_birth DATE,  -- تاريخ الميلاد
    age INT,  -- العمر
    id_job VARCHAR(100),  -- المهنة في الإقامة
    company_name VARCHAR(100),  -- الكفالة
    drive_lic VARCHAR(50),  -- رخصة القيادة
    religion VARCHAR(50),  -- الديانة
    social_status VARCHAR(50),  -- الحالة الاجتماعية
    phone_number VARCHAR(20),  -- رقم الجوال
    email VARCHAR(100),  -- البريد الإلكتروني
    address TEXT,  -- العنوان
    
    -- بيانات الدراسة
    edu_degree VARCHAR(100),  -- الدرجة العلمية
    university VARCHAR(100),  -- الجامعة
    college VARCHAR(100),  -- الكلية
    grad_year INT,  -- سنة التخرج
    grade VARCHAR(50),  -- التقدير
    diploma VARCHAR(255),  -- دبلومة (path or filename)
    master VARCHAR(255),  -- ماجستير
    phd VARCHAR(255),  -- دكتوراه
    
    -- البيانات الوظيفية
    company_job VARCHAR(100),  -- المسمى الوظيفي
    join_date DATE NOT NULL,  -- تاريخ الالتحاق
    rejoin_date DATE,  -- تاريخ المباشرة
    dept_id INT,  -- الإدارة (FK to departments)
    position_id INT,  -- المسمى الوظيفي (FK to positions)
    direct_manager_id INT,  -- المدير المباشر (FK to employees)
    
    -- البيانات المالية
    base_salary DECIMAL(10,2),  -- الراتب الأساسي
    housing_allowance DECIMAL(10,2),  -- بدل السكن
    transport_allowance DECIMAL(10,2),  -- بدل النقل
    iban VARCHAR(50),  -- رقم الآيبان
    
    -- الحضور والإجازات
    work_type VARCHAR(50),  -- نظام الدوام (دوام كامل/نصف دوام الخ)
    last_return_date DATE,  -- تاريخ آخر عودة من إجازة
    vacation_balance DECIMAL(5,2),  -- رصيد الإجازات المتبقي
    
    -- العقود
    contract_type VARCHAR(50),  -- نوع العقد
    contract_start DATE,  -- بداية العقد
    contract_end DATE,  -- نهاية العقد
    
    -- الصور والمرفقات
    profile_pic LONGBLOB,  -- صورة الملف الشخصي (Base64 encoded)
    profile_pic_filename VARCHAR(255),  -- اسم ملف الصورة
    
    -- التتبع
    status ENUM('active', 'inactive', 'suspended', 'terminated') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (position_id) REFERENCES positions(position_id),
    FOREIGN KEY (direct_manager_id) REFERENCES employees(emp_id),
    
    INDEX idx_emp_number (emp_number),
    INDEX idx_emp_name (emp_name),
    INDEX idx_dept_id (dept_id),
    INDEX idx_position_id (position_id),
    INDEX idx_manager_id (direct_manager_id),
    INDEX idx_status (status),
    INDEX idx_join_date (join_date)
);

-- ===================================
-- 4. جدول التقييمات (Evaluations)
-- ===================================
CREATE TABLE evaluations (
    eval_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,  -- الموظف المقيم (FK to employees)
    from_date DATE NOT NULL,  -- من تاريخ
    to_date DATE NOT NULL,  -- إلى تاريخ
    period_type VARCHAR(50),  -- نوع الفترة (شهري/ربع سنوي/سنوي)
    rating INT,  -- التقييم (0-100)
    notes TEXT,  -- الملاحظات والتفاصيل
    evaluator_id INT,  -- الشخص الذي قام بالتقييم (FK to employees)
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (evaluator_id) REFERENCES employees(emp_id),
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_from_date (from_date),
    INDEX idx_to_date (to_date)
);

-- ===================================
-- 5. جدول سجل الإجازات (Vacation Records)
-- ===================================
CREATE TABLE vacation_records (
    vacation_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,  -- الموظف
    vacation_start_date DATE NOT NULL,  -- بداية الإجازة
    vacation_end_date DATE NOT NULL,  -- نهاية الإجازة
    vacation_days INT,  -- عدد أيام الإجازة
    vacation_type VARCHAR(50),  -- نوع الإجازة (سنوية/مرضية/طارئة الخ)
    status ENUM('approved', 'pending', 'rejected', 'cancelled') DEFAULT 'pending',
    notes TEXT,
    approver_id INT,  -- الشخص الموافق
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (approver_id) REFERENCES employees(emp_id),
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_vacation_start (vacation_start_date),
    INDEX idx_status (status)
);

-- ===================================
-- 6. جدول العطل والحضور (Attendance)
-- ===================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in TIME,  -- وقت الدخول
    check_out TIME,  -- وقت الخروج
    status ENUM('present', 'absent', 'late', 'sick', 'vacation', 'approved_leave') DEFAULT 'present',
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_attendance (emp_id, attendance_date),
    INDEX idx_emp_id (emp_id),
    INDEX idx_attendance_date (attendance_date),
    INDEX idx_status (status)
);

-- ===================================
-- 7. جدول الرواتب والعلاوات (Salary & Allowances)
-- ===================================
CREATE TABLE salary_records (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    salary_month INT,  -- الشهر (1-12)
    salary_year INT,  -- السنة
    base_salary DECIMAL(10,2),
    housing_allowance DECIMAL(10,2),
    transport_allowance DECIMAL(10,2),
    additional_allowance DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_salary DECIMAL(10,2),
    status ENUM('draft', 'calculated', 'approved', 'paid') DEFAULT 'draft',
    payment_date DATE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_salary (emp_id, salary_month, salary_year),
    INDEX idx_emp_id (emp_id),
    INDEX idx_salary_month_year (salary_month, salary_year),
    INDEX idx_status (status)
);

-- ===================================
-- 8. جدول التدريب والتطوير (Training)
-- ===================================
CREATE TABLE training_records (
    training_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    training_name VARCHAR(100),
    training_provider VARCHAR(100),  -- الجهة المدربة
    training_date DATE,
    training_duration INT,  -- المدة بالساعات
    certificate_number VARCHAR(100),
    status ENUM('planned', 'completed', 'cancelled') DEFAULT 'planned',
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_training_date (training_date)
);

-- ===================================
-- 9. جدول الأداء والمؤشرات (Performance)
-- ===================================
CREATE TABLE performance_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    metric_period VARCHAR(50),  -- الفترة (الشهر/الربع/السنة)
    kpi_target DECIMAL(10,2),  -- الهدف
    kpi_actual DECIMAL(10,2),  -- الإنجاز الفعلي
    achievement_percentage DECIMAL(5,2),  -- نسبة الإنجاز
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_metric_period (metric_period)
);

-- ===================================
-- 10. جدول السجلات التاريخية (Audit Log)
-- ===================================
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,  -- الموظف المتأثر
    action_type VARCHAR(50),  -- نوع الإجراء (create, update, delete, login, etc)
    table_name VARCHAR(50),  -- اسم الجدول
    record_id INT,  -- معرف السجل المتأثر
    old_value JSON,  -- القيمة القديمة
    new_value JSON,  -- القيمة الجديدة
    user_id INT,  -- معرف المستخدم الذي قام بالإجراء
    ip_address VARCHAR(45),
    description TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at)
);

-- ===================================
-- 11. جدول المستخدمين (Users)
-- ===================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,  -- الموظف المرتبط
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255),
    email VARCHAR(100),
    role VARCHAR(50),  -- (admin, hr, manager, employee)
    status ENUM('active', 'inactive', 'locked') DEFAULT 'active',
    last_login TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    
    INDEX idx_emp_id (emp_id),
    INDEX idx_role (role)
);

-- ===================================
-- إضافة Indexes إضافية للأداء
-- ===================================

-- تحديث constraint على جدول departments ليشير إلى مدير الإدارة
-- ALTER TABLE departments ADD CONSTRAINT fk_manager_id FOREIGN KEY (manager_id) REFERENCES employees(emp_id);

-- ===================================
-- بيانات أولية (Sample Data)
-- ===================================

-- إدارات
INSERT INTO departments (dept_name, dept_code) VALUES
('الموارد البشرية', 'HR'),
('المالية', 'FIN'),
('العمليات', 'OPS'),
('التسويق والمبيعات', 'MARKETING'),
('تكنولوجيا المعلومات', 'IT');

-- مسميات وظيفية
INSERT INTO positions (position_name, position_code, salary_level) VALUES
('مدير عام', 'CEO', 10),
('مدير قسم', 'DEPT_MANAGER', 8),
('نائب مدير', 'ASST_MANAGER', 7),
('موظف أول', 'SENIOR_EMP', 5),
('موظف', 'EMPLOYEE', 3);

-- ===================================
-- تعريفات الدوال المساعدة
-- ===================================

-- دالة حساب رصيد الإجازات بناء على القانون السعودي
DELIMITER //

CREATE FUNCTION calculate_vacation_balance(emp_id_param INT, last_return_date_param DATE)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_join_date DATE;
    DECLARE v_years_of_service INT;
    DECLARE v_annual_vacation INT;
    DECLARE v_days_since_return DECIMAL(5,2);
    DECLARE v_vacation_balance DECIMAL(5,2);
    
    -- الحصول على تاريخ الالتحاق
    SELECT join_date INTO v_join_date FROM employees WHERE emp_id = emp_id_param;
    
    -- حساب سنوات الخدمة
    SET v_years_of_service = YEAR(CURDATE()) - YEAR(v_join_date);
    
    -- تحديد الإجازة السنوية بناء على سنوات الخدمة (القانون السعودي)
    IF v_years_of_service < 5 THEN
        SET v_annual_vacation = 21;
    ELSEIF v_years_of_service < 10 THEN
        SET v_annual_vacation = 22;
    ELSE
        SET v_annual_vacation = 30;
    END IF;
    
    -- حساب الأيام التراكمية منذ آخر عودة
    IF last_return_date_param IS NOT NULL THEN
        SET v_days_since_return = DATEDIFF(CURDATE(), last_return_date_param) / 365 * v_annual_vacation;
    ELSE
        SET v_days_since_return = v_annual_vacation;
    END IF;
    
    -- تحديد الحد الأقصى
    SET v_vacation_balance = LEAST(v_days_since_return, v_annual_vacation);
    
    RETURN ROUND(v_vacation_balance, 2);
END //

DELIMITER ;

-- ===================================
-- Views المفيدة
-- ===================================

-- عرض الموظفين مع معلومات الإدارة والمدير المباشر
CREATE VIEW employee_with_details AS
SELECT 
    e.emp_id,
    e.emp_number,
    e.emp_name,
    d.dept_name,
    p.position_name,
    m.emp_name AS manager_name,
    e.base_salary,
    e.status,
    e.created_at
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN positions p ON e.position_id = p.position_id
LEFT JOIN employees m ON e.direct_manager_id = m.emp_id
WHERE e.status = 'active';

-- عرض الإجازات المعلقة
CREATE VIEW pending_vacations AS
SELECT 
    vr.vacation_id,
    e.emp_number,
    e.emp_name,
    vr.vacation_start_date,
    vr.vacation_end_date,
    vr.vacation_days,
    vr.vacation_type,
    vr.status
FROM vacation_records vr
JOIN employees e ON vr.emp_id = e.emp_id
WHERE vr.status = 'pending'
ORDER BY vr.created_at DESC;

-- عرض التقييمات الأخيرة
CREATE VIEW recent_evaluations AS
SELECT 
    ev.eval_id,
    e.emp_number,
    e.emp_name,
    ev.from_date,
    ev.to_date,
    ev.period_type,
    ev.rating,
    ev.notes
FROM evaluations ev
JOIN employees e ON ev.emp_id = e.emp_id
ORDER BY ev.created_at DESC
LIMIT 100;

-- ===================================
-- إحصائيات الموظفين
-- ===================================
CREATE VIEW employee_statistics AS
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN emp_national = 'سعودي' THEN 1 ELSE 0 END) AS saudi_employees,
    SUM(CASE WHEN emp_national != 'سعودي' THEN 1 ELSE 0 END) AS non_saudi_employees,
    SUM(CASE WHEN gender = 'أنثى' THEN 1 ELSE 0 END) AS female_employees,
    SUM(CASE WHEN gender = 'ذكر' THEN 1 ELSE 0 END) AS male_employees,
    SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_employees,
    SUM(CASE WHEN status = 'inactive' THEN 1 ELSE 0 END) AS inactive_employees
FROM employees;

-- ===================================
-- شروط التنفيذ النهائية
-- ===================================
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- ===================================
-- ملاحظات مهمة
-- ===================================
/*
1. تأكد من تثبيت MySQL 5.7 أو أحدث
2. استخدم UTF-8 كترميز افتراضي
3. قم بنسخ احتياطي من البيانات قبل هجرة البيانات من localStorage
4. تحقق من الأداء باستخدام EXPLAIN لكل استعلام
5. قم بتحديث الكود الخاص بك لاستخدام API جديدة بدل localStorage
6. أضف معالجة الأخطاء والمعاملات (transactions) للحفاظ على سلامة البيانات
*/
