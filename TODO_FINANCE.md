# finance.html - Account Management Features

## Task: Enable account management features

## Features Implemented:

- [x] 1. Analyze current code structure
- [x] 2. Edit Account Button (F6) - Enable edit function with modal
- [x] 3. Delete Account Button (Del) - Enable delete with confirmation
- [x] 4. Move Account - Enable moving to another parent
- [x] 5. Account Statement (كشف حساب) - Show account details/transactions
- [x] 6. Search in list ( بحث في قائمة) - Enable search functionality
- [x] 7. Update Data (F4) - Enable refresh data function
- [x] 8. Keyboard shortcuts (Ins, F6, Del, F4)
- [x] 9. Data persistence with localStorage
- [x] 10. Add sub-account under sub-account - When standing on sub-account, can add child under it
- [x] 11. Automatic account numbering - Auto-generates account codes based on parent
- [x] 12. Complete Chart of Accounts - Full account tree with all sub-accounts

## Features Working:

- ✅ إضافة حساب (Insert) - Add new account
- ✅ تعديل (F6) - Edit account name
- ✅ حذف (Delete) - Delete selected account
- ✅ نقل حساب - Move account to different parent
- ✅ كشف حساب - Show account statement
- ✅ بحث في قائمة - Search accounts by name
- ✅ تحديث البيانات (F4) - Refresh data from localStorage
- ✅ إضافة تفريع - Add sub-branch under sub-account
- ✅ ترقيم تلقائي - Auto numbering for accounts
- ✅ شجرة الحسابات الكاملة - Complete account tree with all accounts

## Complete Account Tree (Updated):

### 1) الأصول (Assets) - id: 1

```
1 - الأصول
├── 11 - الأصول الثابتة
│   ├── 111 - الأراضي والمباني
│   ├── 112 - المركبات
│   ├── 113 - الأثاث والمعدات
│   ├── 114 - أجهزة الحاسب الآلي
│   ├── 115 - معدات مكتبية
│   └── 116 - إهلاك الأصول الثابتة
├── 12 - الأصول المتداولة
│   ├── 121 - ال��قدية
│   │   ├── 1211 - الصندوق
│   │   └── 1212 - البنك
│   ├── 122 - العملاء (الذمم المدينة)
│   │   ├── 1221 - عملاء محليين
│   │   └── 1222 - عملاء أجانب
│   ├── 123 - أوراق القبض
│   ├── 124 - المخزون
│   │   ├── 1241 - مواد خام
│   │   ├── 1242 - بضاعة تامة
│   │   └── 1243 - مستلزمات
│   ├── 125 - المصروفات المقدمة
│   └── 126 - الإيرادات المستحقة
```

### 2) الخصوم (Liabilities) - id: 2

```
2 - الخصوم
├── 21 - الموردين (الذمم الدائنة)
├── 22 - أوراق الدفع
├── 23 - المصروفات المستحقة
├── 24 - الإيرادات المقدمة
├── 25 - القروض
│   ├── 251 - قروض قصيرة الأجل
│   └── 252 - قروض طويلة الأجل
├── 26 - الضرائب
│   ├── 261 - ضريبة القيمة المضافة
│   └── 262 - ضريبة الدخل
└── 27 - الرواتب المستحقة
```

### 3) حقوق الملكية (Equity) - id: 3

```
3 - حقوق الملكية
├── 31 - رأس المال
├── 32 - جاري الشركاء
├── 33 - الاحتياطيات
├── 34 - الأرباح المرحلة
└── 35 - صافي الربح / الخسارة
```

### 4) الإيرادات (Revenue) - id: 4

```
4 - الإيرادات
├── 41 - إيرادات تشغيلية
│   ├── 411 - إيرادات خدمات
│   └── 412 - إيرادات مبيعات
└── 42 - إيرادات أخرى
    ├── 421 - أرباح فروق عملة
    ├── 422 - إيرادات استثمار
    └── 423 - إيرادات إيجارات
```

### 5) المصروفات (Expenses) - id: 5

```
5 - المصروفات
├── 51 - الرواتب والأجور
├── 52 - الإيجارات
├── 53 - الكهرباء والمياه
├── 54 - الاتصالات
├── 55 - مصاريف إدارية
├── 56 - مصاريف تسويق
├── 57 - مصاريف صيانة
├── 58 - مصاريف نقل
├── 59 - مصاريف بنكية
├── 60 - إهلاك الأصول
└── 61 - مصاريف أخرى
```

## Main Accounts:

- الأصول (Assets) - id: 1
- الخصوم (Liabilities) - id: 2
- حقوق الملكية (Equity) - id: 3
- الإيرادات (Revenues) - id: 4
- المصروفات (Expenses) - id: 5
