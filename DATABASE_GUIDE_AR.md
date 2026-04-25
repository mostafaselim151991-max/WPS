# دليل قاعدة بيانات HRMS

## نظام إدارة الموارد البشرية - شركة سادن

---

## 📋 المحتويات

1. [المتطلبات](#المتطلبات)
2. [التثبيت](#التثبيت)
3. [الهجرة من localStorage](#الهجرة-من-localstorage)
4. [واجهة API](#واجهة-api)
5. [الجداول والحقول](#الجداول-والحقول)
6. [أمثلة الاستخدام](#أمثلة-الاستخدام)
7. [مشاكل شائعة وحلولها](#مشاكل-شائعة-وحلولها)

---

## المتطلبات

### الخادم

- **MySQL 5.7+** أو **MariaDB 10.0+**
- **PHP 7.4+** (اختياري للـ API)
- **Node.js** (اختياري كبديل للـ PHP)

### المتصفح

- تصحيح الترميز إلى UTF-8
- دعم fetch API

---

## التثبيت

### 1. إنشاء قاعدة البيانات

#### الطريقة الأولى - استخدام phpMyAdmin

```
1. افتح phpMyAdmin
2. اذهب إلى: http://localhost/phpmyadmin
3. انقر على "جديد" (New)
4. أدخل اسم قاعدة البيانات: saden_hrms
5. اختر الترميز: utf8mb4_unicode_ci
6. انقر "إنشاء" (Create)
7. اختر قاعدة البيانات الجديدة
8. انقر على جملة SQL (SQL tab)
9. انسخ محتوى ملف saden_hrms_database.sql
10. الصق المحتوى والنقر "تنفيذ" (Execute)
```

#### الطريقة الثانية - سطر الأوامر

```bash
# فتح MySQL
mysql -u root -p

# تنفيذ الأوامر التالية:
CREATE DATABASE saden_hrms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE saden_hrms;
SOURCE /path/to/saden_hrms_database.sql;
```

### 2. تثبيت الـ API

#### استخدام PHP المدمج

```bash
# انسخ ملف api.php إلى مجلد المشروع
# ثم شغّل خادم PHP المدمج:
php -S localhost:8000 -t d:\مشروع\ النظام\ الموحد\ لمجموعة\ سادن\WPS\
```

#### استخدام Apache

```
1. انسخ ملف api.php إلى مجلد htdocs
2. تأكد من تفعيل mod_rewrite
3. أضف في .htaccess:
   <IfModule mod_rewrite.c>
     RewriteEngine On
     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d
     RewriteRule ^ index.php [QSA,L]
   </IfModule>
```

#### استخدام Node.js (اختياري)

```bash
npm install express mysql2 body-parser cors
node api-server.js
```

### 3. تحديث إعدادات الـ API

```php
// في ملف api.php، حدّث البيانات:
define('DB_HOST', 'localhost');    // عنوان الخادم
define('DB_USER', 'root');         // اسم المستخدم
define('DB_PASS', 'password');     // كلمة المرور
define('DB_NAME', 'saden_hrms');   // اسم قاعدة البيانات
```

---

## الهجرة من localStorage

### خطوات الهجرة

#### 1. نسخ احتياطي

```javascript
// افتح وحدة تحكم المتصفح (F12)
// انسخ البيانات من localStorage:
const backup = JSON.parse(localStorage.getItem("saden_employees"));
console.log(backup);
// ثم احفظها في ملف JSON
```

#### 2. التحقق من البيانات

```javascript
// في Console
MigrationTool.validateData();
// يجب أن تراها رسالة "✅ تم التحقق من البيانات بنجاح"
```

#### 3. تشغيل الهجرة

```javascript
// في Console
MigrationTool.runMigration();

// أو خطوة بخطوة:
MigrationTool.backupLocalStorage(); // نسخ احتياطي
MigrationTool.validateData(); // التحقق
MigrationTool.migrateAllData(); // الهجرة
MigrationTool.compareData(); // المقارنة
```

### ملاحظات الهجرة

⚠️ **تحذيرات مهمة:**

- قم بنسخ احتياطي من البيانات قبل البدء
- تأكد من الاتصال بقاعدة البيانات
- قد تأخذ الهجرة وقتاً إذا كان عدد الموظفين كبيراً
- لا تغلق صفحة المتصفح أثناء الهجرة

---

## واجهة API

### البيانات الأساسية

**عنوان الخادم:** `http://localhost:8000`

### نقاط النهاية (Endpoints)

#### الموظفين (Employees)

##### الحصول على جميع الموظفين

```
GET /api.php/employees
Query Parameters:
  - status: active, inactive, suspended, terminated
  - dept_id: معرف الإدارة
  - search: البحث بالاسم أو الرقم الوظيفي

مثال:
GET /api.php/employees?status=active&search=محمد
```

**الاستجابة:**

```json
{
  "success": true,
  "data": [
    {
      "emp_id": 1,
      "emp_number": "1001",
      "emp_name": "محمد أحمد",
      "emp_national": "سعودي",
      "gender": "ذكر",
      "phone_number": "0501234567",
      "email": "mohammed@saden.com",
      "join_date": "2020-01-15",
      "base_salary": 5000.00,
      "vacation_balance": 15.5,
      ...
    }
  ]
}
```

##### الحصول على موظف واحد

```
GET /api.php/employees/{emp_id}

مثال:
GET /api.php/employees/1
```

##### إضافة موظف جديد

```
POST /api.php/employees
Content-Type: application/json

{
  "emp_name": "فاطمة علي",
  "emp_national": "سعودية",
  "gender": "أنثى",
  "phone_number": "0509876543",
  "email": "fatima@saden.com",
  "join_date": "2024-01-01",
  "dept_id": 1,
  "position_id": 2,
  "base_salary": 4500.00,
  "profile_pic": "data:image/jpeg;base64,..."
}
```

##### تحديث بيانات الموظف

```
PUT /api.php/employees/{emp_id}
Content-Type: application/json

{
  "email": "new_email@saden.com",
  "base_salary": 5500.00,
  "housing_allowance": 1000.00
}
```

##### حذف موظف (تعطيل)

```
DELETE /api.php/employees/{emp_id}
```

#### التقييمات (Evaluations)

##### الحصول على تقييمات الموظف

```
GET /api.php/evaluations/{emp_id}
```

##### إضافة تقييم

```
POST /api.php/evaluations/{emp_id}
Content-Type: application/json

{
  "from_date": "2024-01-01",
  "to_date": "2024-03-31",
  "period_type": "ربع سنوي",
  "rating": 85,
  "notes": "أداء ممتاز"
}
```

#### الإجازات (Vacation)

##### حساب رصيد الإجازات

```
GET /api.php/vacation/{emp_id}

الاستجابة:
{
  "success": true,
  "data": {
    "vacation_balance": 15.5
  }
}
```

---

## الجداول والحقول

### جدول الموظفين (employees)

| الحقل             | النوع         | الوصف                              |
| ----------------- | ------------- | ---------------------------------- |
| emp_id            | INT           | معرف الموظف (مفتاح أساسي)          |
| emp_number        | VARCHAR(20)   | الرقم الوظيفي (1001, 1002, ...)    |
| emp_name          | VARCHAR(100)  | اسم الموظف                         |
| emp_national      | VARCHAR(50)   | الجنسية                            |
| gender            | VARCHAR(10)   | الجنس (ذكر/أنثى)                   |
| join_date         | DATE          | تاريخ الالتحاق                     |
| dept_id           | INT           | معرف الإدارة (مفتاح خارجي)         |
| direct_manager_id | INT           | معرف المدير المباشر                |
| base_salary       | DECIMAL(10,2) | الراتب الأساسي                     |
| vacation_balance  | DECIMAL(5,2)  | رصيد الإجازات                      |
| status            | ENUM          | الحالة (active/inactive/suspended) |

### جدول التقييمات (evaluations)

| الحقل       | النوع       | الوصف                           |
| ----------- | ----------- | ------------------------------- |
| eval_id     | INT         | معرف التقييم                    |
| emp_id      | INT         | معرف الموظف (مفتاح خارجي)       |
| from_date   | DATE        | تاريخ البداية                   |
| to_date     | DATE        | تاريخ النهاية                   |
| period_type | VARCHAR(50) | نوع الفترة (شهري/ربع سنوي/سنوي) |
| rating      | INT         | التقييم (0-100)                 |
| notes       | TEXT        | الملاحظات                       |

### جدول الإدارات (departments)

| الحقل     | النوع        | الوصف        |
| --------- | ------------ | ------------ |
| dept_id   | INT          | معرف الإدارة |
| dept_name | VARCHAR(100) | اسم الإدارة  |
| dept_code | VARCHAR(20)  | رمز الإدارة  |

### جدول المسميات الوظيفية (positions)

| الحقل         | النوع        | الوصف              |
| ------------- | ------------ | ------------------ |
| position_id   | INT          | معرف المسمى        |
| position_name | VARCHAR(100) | اسم المسمى الوظيفي |
| position_code | VARCHAR(20)  | رمز المسمى         |

---

## أمثلة الاستخدام

### استخدام JavaScript/Fetch

```javascript
// الحصول على جميع الموظفين
fetch("http://localhost:8000/api.php/employees")
  .then((response) => response.json())
  .then((data) => {
    if (data.success) {
      console.log("الموظفون:", data.data);
    } else {
      console.error("خطأ:", data.message);
    }
  });

// إضافة موظف جديد
const newEmployee = {
  emp_name: "أحمد محمد",
  emp_national: "سعودي",
  gender: "ذكر",
  phone_number: "0505555555",
  email: "ahmed@saden.com",
  join_date: "2024-01-01",
  base_salary: 4500,
};

fetch("http://localhost:8000/api.php/employees", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify(newEmployee),
})
  .then((response) => response.json())
  .then((data) => console.log("تم الإضافة:", data));

// تحديث موظف
fetch("http://localhost:8000/api.php/employees/1", {
  method: "PUT",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    email: "newemail@saden.com",
    base_salary: 5000,
  }),
})
  .then((response) => response.json())
  .then((data) => console.log("تم التحديث:", data));
```

### استخدام curl

```bash
# الحصول على الموظفين
curl "http://localhost:8000/api.php/employees"

# إضافة موظف
curl -X POST "http://localhost:8000/api.php/employees" \
  -H "Content-Type: application/json" \
  -d '{"emp_name":"علي محمد","emp_national":"سعودي","join_date":"2024-01-01"}'

# تحديث موظف
curl -X PUT "http://localhost:8000/api.php/employees/1" \
  -H "Content-Type: application/json" \
  -d '{"email":"ali@saden.com"}'

# حذف موظف
curl -X DELETE "http://localhost:8000/api.php/employees/1"
```

---

## مشاكل شائعة وحلولها

### ❌ خطأ: "فشل الاتصال بقاعدة البيانات"

**السبب:** كلمة مرور قاعدة البيانات أو بيانات الاتصال غير صحيحة

**الحل:**

```
1. تحقق من api.php والقيم الصحيحة:
   define('DB_HOST', 'localhost');
   define('DB_USER', 'root');
   define('DB_PASS', '');
   define('DB_NAME', 'saden_hrms');
2. تأكد من تشغيل خادم MySQL
3. تحقق من أن قاعدة البيانات تم إنشاؤها
```

### ❌ خطأ: "الترميز غير صحيح - ظهور رموز غريبة"

**الحل:**

```
1. تأكد من الترميز UTF-8 في قاعدة البيانات:
   ALTER DATABASE saden_hrms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
2. أضف في رأس api.php:
   $this->conn->set_charset("utf8mb4");
3. حدّث الجداول:
   ALTER TABLE employees CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### ❌ خطأ: "CORS Error" عند الاتصال من المتصفح

**الحل:**

```
يجب أن يكون لديك في api.php:
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

أو استخدم خادم محلي على نفس النطاق
```

### ❌ خطأ: "الصور لا تعرض بشكل صحيح"

**السبب:** صورة Base64 كبيرة جداً

**الحل:**

```
1. قلل حجم الصورة قبل تحويلها إلى Base64
2. أو استخدم نظام حفظ الملفات بدل BLOB
3. ضع حد أقصى لحجم الصورة في JavaScript:
   if (file.size > 2 * 1024 * 1024) { // 2 MB
     alert('حجم الملف كبير جداً');
   }
```

---

## نصائح الأمان

⚠️ **قبل النشر على الإنتاج:**

1. **تغيير كلمات المرور**

   ```php
   define('DB_PASS', 'كلمة_مرور_قوية_جداً');
   ```

2. **تفعيل HTTPS**

   ```php
   header('Strict-Transport-Security: max-age=31536000');
   ```

3. **التحقق من الدخول (Authentication)**

   ```php
   // أضف تحقق من الجلسات والرموز
   ```

4. **حماية من SQL Injection**
   - استخدم prepared statements
   - تجنب استخدام real_escape_string

5. **نسخ احتياطي منتظمة**
   ```bash
   mysqldump -u root -p saden_hrms > backup_$(date +%Y%m%d).sql
   ```

---

## دعم والمساعدة

للمزيد من المعلومات والدعم الفني:

- 📧 البريد الإلكتروني: support@saden.com
- 📞 الهاتف: +966 (رقم الشركة)
- 🌐 الموقع: https://saden.com

---

**آخر تحديث:** 2024
**إصدار:** 1.0.0
**الحالة:** مستقر
