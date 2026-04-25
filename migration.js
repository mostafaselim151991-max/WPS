/**
 * HRMS Migration Tool
 * أداة الهجرة من localStorage إلى قاعدة بيانات SQL
 * شركة سادن
 */

const MigrationTool = {
    apiUrl: 'http://localhost/saden/api.php',
    
    // الحصول على البيانات من localStorage
    getLocalStorageData: function() {
        const data = localStorage.getItem('saden_employees');
        return data ? JSON.parse(data) : [];
    },

    // الهجرة الكاملة
    migrateAllData: async function() {
        console.log('🚀 بدء عملية الهجرة...');
        
        const employees = this.getLocalStorageData();
        
        if (employees.length === 0) {
            console.log('⚠️ لا توجد بيانات في localStorage');
            return;
        }

        console.log(`📊 عدد الموظفين للهجرة: ${employees.length}`);

        let successCount = 0;
        let errorCount = 0;

        for (let i = 0; i < employees.length; i++) {
            const emp = employees[i];
            console.log(`\n⏳ جاري الهجرة: ${i + 1}/${employees.length} - ${emp.emp_name}`);

            try {
                const response = await fetch(`${this.apiUrl}/employees`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        emp_name: emp.emp_name,
                        emp_national: emp.emp_national,
                        gender: emp.gender,
                        phone_number: emp.phone_number,
                        email: emp.email,
                        address: emp.address,
                        date_birth: emp.date_birth,
                        id_number: emp.id_number,
                        pass_number: emp.pass_number,
                        
                        // بيانات الدراسة
                        edu_degree: emp.edu_degree,
                        university: emp.university,
                        college: emp.college,
                        grad_year: emp.grad_year,
                        
                        // البيانات الوظيفية
                        company_job: emp.company_job,
                        join_date: emp.join_date,
                        dept: emp.dept,
                        
                        // البيانات المالية
                        base_salary: emp.base_salary,
                        housing_allowance: emp.housing_allowance,
                        transport_allowance: emp.transport_allowance,
                        iban: emp.iban,
                        
                        // الحضور والإجازات
                        work_type: emp.work_type,
                        last_return_date: emp.last_return_date,
                        vacation_balance: emp.vacation_balance,
                        
                        // العقود
                        contract_type: emp.contract_type,
                        contract_start: emp.contract_start,
                        contract_end: emp.contract_end,
                        
                        // الصورة
                        profile_pic: emp.profile_pic
                    })
                });

                const result = await response.json();
                
                if (result.success) {
                    console.log(`✅ تم هجرة الموظف بنجاح: ${result.data.emp_number}`);
                    successCount++;

                    // هجرة التقييمات إن وجدت
                    if (emp.evaluations && emp.evaluations.length > 0) {
                        const emp_id = result.data.emp_id;
                        for (const evaluation of emp.evaluations) {
                            await this.migrateEvaluation(emp_id, evaluation);
                        }
                    }
                } else {
                    console.error(`❌ خطأ في الهجرة: ${result.message}`);
                    errorCount++;
                }
            } catch (error) {
                console.error(`❌ خطأ في الاتصال: ${error.message}`);
                errorCount++;
            }
        }

        // ملخص النتائج
        console.log('\n' + '='.repeat(50));
        console.log('📈 ملخص نتائج الهجرة:');
        console.log(`✅ نجح: ${successCount}`);
        console.log(`❌ فشل: ${errorCount}`);
        console.log(`📊 الإجمالي: ${employees.length}`);
        console.log('='.repeat(50));

        return {
            success: errorCount === 0,
            successCount,
            errorCount
        };
    },

    // هجرة التقييم الواحد
    migrateEvaluation: async function(emp_id, evaluation) {
        try {
            const response = await fetch(`${this.apiUrl}/evaluations/${emp_id}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    from_date: evaluation.from,
                    to_date: evaluation.to,
                    period_type: evaluation.period_type,
                    rating: evaluation.rating,
                    notes: evaluation.notes
                })
            });

            const result = await response.json();
            
            if (result.success) {
                console.log(`  📈 تم هجرة تقييم: ${evaluation.from} إلى ${evaluation.to}`);
            } else {
                console.error(`  ❌ خطأ في هجرة التقييم: ${result.message}`);
            }
        } catch (error) {
            console.error(`  ❌ خطأ في الاتصال: ${error.message}`);
        }
    },

    // التحقق من البيانات قبل الهجرة
    validateData: function() {
        const employees = this.getLocalStorageData();
        const errors = [];

        employees.forEach((emp, index) => {
            if (!emp.emp_name) {
                errors.push(`الموظف ${index}: اسم الموظف مفقود`);
            }
            if (!emp.join_date) {
                errors.push(`الموظف ${index} (${emp.emp_name}): تاريخ الالتحاق مفقود`);
            }
        });

        if (errors.length > 0) {
            console.error('❌ أخطاء في البيانات:');
            errors.forEach(err => console.error(`  - ${err}`));
            return false;
        }

        console.log('✅ تم التحقق من البيانات بنجاح');
        return true;
    },

    // نسخ احتياطي من localStorage
    backupLocalStorage: function() {
        const data = this.getLocalStorageData();
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `saden_employees_backup_${timestamp}.json`;
        
        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.click();
        URL.revokeObjectURL(url);

        console.log(`💾 تم نسخ البيانات احتياطياً إلى: ${filename}`);
        return true;
    },

    // مقارنة البيانات بين localStorage والقاعدة
    compareData: async function() {
        const localData = this.getLocalStorageData();
        
        try {
            const response = await fetch(`${this.apiUrl}/employees`);
            const result = await response.json();
            
            if (result.success) {
                const dbData = result.data;
                
                console.log('📊 مقارنة البيانات:');
                console.log(`  - عدد السجلات في localStorage: ${localData.length}`);
                console.log(`  - عدد السجلات في قاعدة البيانات: ${dbData.length}`);
                
                // التحقق من الأسماء
                const localNames = localData.map(e => e.emp_name);
                const dbNames = dbData.map(e => e.emp_name);
                
                const missingInDb = localNames.filter(name => !dbNames.includes(name));
                if (missingInDb.length > 0) {
                    console.log(`⚠️ موظفون غير موجودين في قاعدة البيانات:`);
                    missingInDb.forEach(name => console.log(`  - ${name}`));
                }
                
                const extraInDb = dbNames.filter(name => !localNames.includes(name));
                if (extraInDb.length > 0) {
                    console.log(`ℹ️ موظفون موجودون في قاعدة البيانات فقط:`);
                    extraInDb.forEach(name => console.log(`  - ${name}`));
                }
            }
        } catch (error) {
            console.error(`❌ خطأ في المقارنة: ${error.message}`);
        }
    },

    // تشغيل الهجرة بخطوات
    runMigration: async function() {
        console.clear();
        console.log('🔧 أداة الهجرة - HRMS');
        console.log('=' .repeat(50));
        
        // الخطوة 1: النسخ الاحتياطي
        console.log('\n1️⃣ النسخ الاحتياطي من localStorage...');
        this.backupLocalStorage();
        
        // الخطوة 2: التحقق من البيانات
        console.log('\n2️⃣ التحقق من سلامة البيانات...');
        if (!this.validateData()) {
            console.error('❌ توقفت عملية الهجرة بسبب أخطاء في البيانات');
            return;
        }
        
        // الخطوة 3: الهجرة
        console.log('\n3️⃣ بدء هجرة البيانات...');
        const result = await this.migrateAllData();
        
        // الخطوة 4: المقارنة
        console.log('\n4️⃣ مقارنة البيانات...');
        await this.compareData();
        
        // النتيجة النهائية
        if (result.success) {
            console.log('\n✅ اكتملت عملية الهجرة بنجاح!');
            console.log('يمكنك الآن حذف البيانات من localStorage إذا كنت متأكداً');
        } else {
            console.log('\n⚠️ اكتملت عملية الهجرة مع بعض الأخطاء');
            console.log('يرجى مراجعة السجلات أعلاه وإعادة المحاولة');
        }
    }
};

// استخدام الأداة:
// اضغط F12 لفتح Developer Console
// ثم اكتب: MigrationTool.runMigration()
// أو تحقق من البيانات أولاً: MigrationTool.validateData()
