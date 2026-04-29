<?php
/**
 * Email/SMTP Configuration for Saden HRMS
 */

// SMTP Settings (for real email sending - optional/internal-first)
define('SMTP_HOST', 'smtp.gmail.com');  // Change to your provider
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@gmail.com');
define('SMTP_PASSWORD', 'your-app-password');  // Gmail: App password required
define('SMTP_FROM_EMAIL', SMTP_USERNAME);
define('SMTP_FROM_NAME', 'سادن HRMS');

// Mail Database Tables (internal messages)
define('MAIL_TABLE_MESSAGES', 'messages');
define('MAIL_TABLE_INBOX', 'inbox');
define('MAIL_TABLE_SENT', 'sent');

// Default test user (emp_id from employees table)
define('TEST_USER_ID', 1);

// Uncomment to enable real SMTP sending (requires PHPMailer)
define('ENABLE_SMTP', false);
?>

