# ربط mail.html مع قائمة البريد الداخلي

## الخطوات:

- [x] إنشاء TODO.md مع خطة التنفيذ
- [x] قراءة index.html (تم)
- [x] تصحيح ID mismatch: `id="fincMenu"` → `id="mailMenu"`
- [x] استبدال محتوى الـ dropdown بـ buttons لـ inbox/sent بناءً على feedback
- [x] التحقق من التنفيذ عبر test

# تحديث نموذج إرسال البريد + ربط HRMS

✅ تم ربط mail.html الأساسي.  
**الآن: تحديث Composer + HRMS integration**

## الخطوات الجديدة:

- [x] إعادة TODO + قراءة mail.html
      ✅ **تم تحديث mail.html كاملاً:**

## الإنجازات:

- [x] To/CC multi-select من HRMS localStorage (`saden_employees`)
- [x] مرفقات multi-file (FormData)
- [x] UI محسن (labels, height, CSS)
- [x] JS sendMail() يدعم arrays + files + validation
- [x] Watch storage changes لتحديث فوري

**Test:** أضف موظفين في hrms.html → افتح mail.html → Ctrl+Click اختيار To/CC → مرفق → إرسال → يعمل مع api.php.

**المهمة السابقة مكتملة 100%!** 🎉

**التحديث الجديد:**

## المتطلبات:

- [ ] تكبير composer modal
- [ ] إنشاء live chat
- [ ] إشعارات mail/chat في topbar index.html (🔔)

## الخطة:

1. mail.html: composer width=600px, height=80vh
2. chat.html: Live chat system (localStorage)
3. index.html: Add chat button + notifications integration

جاهز للتنفيذ
