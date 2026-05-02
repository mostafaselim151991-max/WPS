# Bond (سند) Feature Implementation

## Task: Create journal entry (سند) functionality

## Steps:

- [x] 1. Add click handler to "سند" icon in toolbar
- [x] 2. Create journal entry modal with fields:
     - رقم القيد (auto-generated)
     - مدين (Debit)
     - دائن (Credit)
     - رقم الحساب (Account number)
     - اسم الحساب (Account name)
     - البيان (Description)
     - مركز التكلفة (Cost center)
- [x] 3. Add JavaScript functions for bond functionality
- [x] 4. Add localStorage for journal entries
- [x] 5. Test the implementation

## Features:

- ✅ Automatic entry number generation (0001, 0002, etc.)
- ✅ Account dropdown from chart of accounts
- ✅ Auto-fill account name when selecting account
- ✅ Debit (مدين) and Credit (دائن) fields
- ✅ Description field (البيان)
- ✅ Cost center dropdown (مركز التكلفة)
- ✅ Real-time totals calculation
- ✅ Validation (must select account, must enter amount)
- ✅ Data persistence with localStorage
