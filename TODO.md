# HRMS PHP Conversion Plan

## Task: Convert hrms.html to hrms.php

### Information Gathered:

- hrms.html: Full HR dashboard with employee management, forms, localStorage-based
- api.php: Already has mysqli connection to saden_hrms database
- saden_hrms_database.sql: Complete database schema exists
- config.php: Has configuration settings

### Database Structure (from SQL):

- employees table with all fields
- departments table
- positions table
- evaluations table
- status field: active/inactive/suspended/terminated
- Allowances: housing_allowance, transport_allowance, communication_allowance

### Plan:

1. Create hrms.php with PHP structure
2. Include mysqli database connection using config from api.php
3. Keep ALL original HTML/CSS (design integrity)
4. Add UTF-8 header support for Arabic
5. Fetch employees from database instead of localStorage
6. Update module links to point to .php files
7. Display allowances (Housing, Transport, Communication) from DB
8. Show employee status from database values
9. Keep all JavaScript functionality working

### Module Links to Update:

- Employment Requisition → employment_requisition.php (when converted)
- Job Offer → job_offer.php (when converted)
- CV Bank → cv_bank.php (when converted)
- Employee Complaints → employee_complaints.php (when converted)

### Allowances to Display:

- housing_allowance (بدل السكن)
- transport_allowance (بدل الإنتقال)
- communication_allowance (بدل الإتصال)

### Status Values:

- active → نشط
- on_leave → في إجازة
- suspended →معلق
- terminated →منتهي

## Implementation Steps:

1. Create hrms.php with full PHP + HTML
2. Test database connection
3. Verify employee list displays correctly
4. Test forms save to database

---

Last Updated: [Current Date]
