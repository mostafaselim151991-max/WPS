# الخطة التفصيلية لتطوير نظام الحسابات ليطابق Odoo

## ملخص التحليل

### الوضع الحالي (finance.html)

- ✅ دليل الحسابات (Chart of Accounts) - موجود مع هيكل شجري
- ✅ Journal Entries - قيد يومي مع تطبيق متبابعي会计
- ✅ Invoices - فواتير مبيعات/مشتريات
- ✅ Fixed Assets - أصول مع استهلاك
- ✅ Financial Reports - تقارير مالية أساسية

### الـميزات الناقصة المطلوب إضافتها

1. Analytical Accounts (الحسابات التحليلية)
2. Tax (VAT) handling - ضريبة القيمة المضافة 15%
3. Bank & Cash management - إدارة البنوك والصناديق
4. Payment management - إدارة المدفوعات
5. Reconciliation - المطابقة
6. Multi-currency - عملات متعددة
7. Budget management - إدارة الميزانية
8. Cost Centers - مراكز التكلفة
9. Asset depreciation methods - طرق استهلاك متعددة
10. Financial Reports متقدمة - تقارير إضافية
11. Audit trail - سجل التدقيق
12. Recurring entries - قيود متكررة
13. Fiscal years - Fiscal سنوات مالية
14. Payment terms - شروط الدفع
15. Tax reporting - تقارير ضريبية (زكاة، VAT)

---

## خطة التنفيذ

### المرحلة 1: هيكل البيانات الأساسي (Core Data Structure)

#### 1.1 إضافة Tax (VAT) System

- إضافة جدول localStorage للضرائب
- دعم VAT 15% للمبيعات والمشتريات
- إضافة حقل VAT في الفواتير
- إضافة حساب ضريبي 15% VAT Output/VAT Input

#### 1.2 إضافة Analytical Accounts

- إضافة حقل cost_center للحسابات
- إنشاء جدول مراكز التكلفة
- ربط القيود بمراكز التكلفة

#### 1.3 إضافة Bank & Cash

- إضافة قسم Banks/Cash جديد في التبويب
- إنشاء جدولللبنوك والصناديق
- دعم عمليات الإيداع والسحب

### المرحلة 2: إدارة الأصول المتقدمة (Enhanced Assets)

#### 2.1 طرق الاستهلاك المتعددة

- طريقة القسط الثابت (Straight-line)
- طريقة القسط المتناقص (Declining Balance)
- طريقة وحدات الإنتاج (Units of Production)

#### 2.2 تقارير الأصول

- قائمة الأصول
- تقرير الاستهلاك
- قيمة الأصول الصافية

### المرحلة 3: العمليات المالية (Financial Operations)

#### 3.1 Payment Management

- تسجيل المدفوعات
- ربط المدفوعات بالفواتير
- حالة الدفع (مدفوع، جزئي، غير مدفوع)

#### 3.2 Reconciliation

- مطابقة البنوك
- تسجيل الفروقات

#### 3.3 Multi-currency

- دعم العملات المتعددة
- أسعار الصرف
- تحويل العملات

### المرحلة 4: الميزانية والتقارير (Budget & Reports)

#### 4.1 Budget Management

- إنشاء ميزانية سنوية
- تتبع المصروفات والإيرادات
- مقارنة الفعلي بالميزانية

#### 4.2 التقارير المتقدمة

- تقرير التدفقات النقدية
- تقرير موجز بالميزانية
- تقرير تكلفة الموظفين

### المرحلة 5: نظام الموافقات (Approvals)

#### 5.1 Audit Trail

- تسجيل جميع العمليات
- تاريخ ووقت كل عملية
- المستخدم المسؤول

#### 5.2 Recurring Entries

- إنشاء قيود متكررة
- جدولة القيود التلقائية

### المرحلة 6: الإعدادات والضرائب (Settings & Tax)

#### 6.1 Fiscal Years

- تحديد السنة المالية
- فترات التقارير

#### 6.2 Payment Terms

- شروط الدفع (فوري، 30 يوم، 60 يوم)
- خصم الدفع المبكر

#### 6.3 Tax Reporting

- تقرير الزكاة
- تقرير VAT
- تصدير ملفات CSV

---

## الملفات المطلوب تعديلها

1. **finance.html** - الملف الرئيسي (تحديث شامل)
2. **api.php** - إضافة endpoints للحسابات (اختياري)
3. **config.php** - إعدادات قاعدة البيانات (اختياري)

---

## تفاصيل التنفيذ

### 1. إضافة تبويبات جديدة

```
Tab Bar:
├── دليل الحسابات (COA) ✅
├── القيد اليومي (Journal) ✅
├── الفواتير (Invoices) ✅
├── الأصول (Assets) ✅
├── التقارير (Reports) ✅
├── الضرائب (Tax)        [جديد]
├── البنوك (Banks)       [جديد]
├── المدفوعات (Payments)   [جديد]
├── المراقبة (Reconcile)  [جديد]
├── الميزانية (Budget)   [جديد]
└── الإعدادات (Settings) [جديد]
```

### 2. هيكل localStorage الجديد

```javascript
const STORAGE_KEYS = {
  coa: "saden_coa",
  journal: "saden_journal_entries",
  sales: "saden_sales_invoices",
  purchase: "saden_purchase_invoices",
  assets: "saden_fixed_assets",
  // الجديد
  taxes: "saden_taxes",
  banks: "saden_banks",
  payments: "saden_payments",
  budgets: "saden_budgets",
  costCenters: "saden_cost_centers",
  auditLog: "saden_audit_log",
  recurringEntries: "saden_recurring_entries",
};
```

### 3. قوالب CSS جديدة

- بطاقات税务局البنوك
- جدول المدفوعات
- نموذج المطابقة
- تقرير الميزانية

---

## الأولوية

1. **الأولوية القصوى**: Tax (VAT), Bank & Cash, Payment Management
2. **الأولوية العالية**: Analytical Accounts, Budget, Reports متقدمة
3. **الأولوية المتوسطة**: Reconciliation, Multi-currency, Depreciation Methods
4. **الأولوية المنخفضة**: Audit Trail, Recurring Entries, Fiscal Years

---

## ملاحظات

- جميع البيانات الموجودة س continue in localStorage
- التوافق الكامل مع الإصدار السابق
- واجهة مستخدم محسنة ومنظمة
- دعم العربية بالكامل
