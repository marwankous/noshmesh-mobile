// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'NoshMesh';

  @override
  String get welcomeMessage => 'مرحبًا بك في NoshMesh';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemMode => 'وضع النظام';

  @override
  String get language => 'اللغة';

  @override
  String get change_language => 'تغيير لغة التطبيق';

  @override
  String get theme => 'المظهر';

  @override
  String get change_theme => 'تغيير مظهر التطبيق';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notification_settings => 'تكوين تفضيلات الإشعارات';

  @override
  String get localization_demo => 'عرض توضيحي للترجمة';

  @override
  String get localization_demo_description => 'عرض ميزات الترجمة أثناء العمل';

  @override
  String get language_settings => 'إعدادات اللغة';

  @override
  String get select_your_language => 'اختر لغتك المفضلة';

  @override
  String get language_explanation =>
      'سيتم تطبيق اللغة المحددة عبر التطبيق بأكمله';

  @override
  String get localization_assets_demo => 'عرض توضيحي للترجمة والأصول';

  @override
  String get current_language => 'اللغة الحالية';

  @override
  String get language_code => 'رمز اللغة';

  @override
  String get language_name => 'اسم اللغة';

  @override
  String get formatting_examples => 'أمثلة التنسيق';

  @override
  String get date_full => 'التاريخ (كامل)';

  @override
  String get date_short => 'التاريخ (قصير)';

  @override
  String get time => 'الوقت';

  @override
  String get currency => 'العملة';

  @override
  String get percent => 'النسبة المئوية';

  @override
  String get localized_assets => 'الأصول المترجمة';

  @override
  String get localized_assets_explanation =>
      'يوضح هذا القسم كيفية تحميل أصول مختلفة بناءً على اللغة المحددة. يمكن أن تكون الصور والصوت والموارد الأخرى خاصة باللغة.';

  @override
  String get image_example => 'مثال صورة مترجمة';

  @override
  String get welcome_image_caption =>
      'يتم تحميل هذه الصورة بناءً على لغتك المحددة';

  @override
  String get common_image_example => 'مثال صورة مشتركة';

  @override
  String get common_image_caption => 'هذه الصورة هي نفسها في جميع اللغات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get content_not_found => 'المحتوى غير موجود';

  @override
  String get content_not_found_generic =>
      'المحتوى غير موجود أو حدث خطأ أثناء جلب البيانات.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String greeting(String name) {
    return 'مرحبًا، $name !';
  }

  @override
  String itemCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عناصر',
      one: 'عنصر واحد',
      zero: 'لا توجد عناصر',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'آخر تحديث: $dateString';
  }

  @override
  String get content_published_successfully => 'تم نشر المحتوى بنجاح';

  @override
  String get clear_all => 'مسح الكل';

  @override
  String get search_articles => 'البحث عن مقالات...';

  @override
  String get enter_email => 'أدخل بريدك الإلكتروني';

  @override
  String get enter_password => 'أدخل كلمة المرور';

  @override
  String get no_matching_articles_found => 'لم يتم العثور على مقالات مطابقة.';

  @override
  String get selected => 'محدد';

  @override
  String get select => 'اختيار';

  @override
  String get filter_by_source => 'الفرز حسب المصدر';

  @override
  String get clear_all_filters => 'مسح جميع الفلاتر';

  @override
  String get select_all => 'تحديد الكل';

  @override
  String get unselect_all => 'إلغاء تحديد الكل';

  @override
  String get merge => 'دمج';

  @override
  String get external_endpoints => 'نقاط النهاية الخارجية';

  @override
  String get manage_endpoints => 'إدارة منصاتك المتكاملة';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get current_password => 'كلمة المرور الحالية';

  @override
  String get new_password => 'كلمة المرور الجديدة';

  @override
  String get confirm_new_password => 'تأكيد كلمة المرور الجديدة';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get profile_updated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get update_profile_failed => 'فشل تحديث الملف الشخصي';

  @override
  String get name => 'الاسم';

  @override
  String get name_required => 'الاسم مطلوب';

  @override
  String get email_required => 'البريد الإلكتروني مطلوب';

  @override
  String get invalid_email => 'البريد الإلكتروني غير صالح';

  @override
  String get required => 'مطلوب';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get reset_password_instruction =>
      'Enter your email to receive a password reset link.';

  @override
  String get reset_your_password => 'Reset Your Password';

  @override
  String get back_to_login => 'العودة لتسجيل الدخول';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get reset_token => 'رمز إعادة التعيين';

  @override
  String get reset_token_hint => 'قم بلصق الرمز من بريدك الإلكتروني';

  @override
  String get enter_reset_token => 'يرجى إدخال رمز إعادة التعيين';

  @override
  String get password_reset_success => 'تمت إعادة تعيين كلمة المرور بنجاح';

  @override
  String get failed_to_reset_password => 'فشل إعادة تعيين كلمة المرور';

  @override
  String get verify_email => 'التحقق من البريد الإلكتروني';

  @override
  String get check_your_email => 'تحقق من بريدك الإلكتروني';

  @override
  String get verification_code_sent =>
      'لقد أرسلنا رمز تحقق إلى بريدك الإلكتروني';

  @override
  String get verification_code => 'رمز التحقق';

  @override
  String get enter_6_digit_code => 'أدخل الرمز المكون من 6 أرقام';

  @override
  String get enter_verification_code => 'يرجى إدخال رمز التحقق';

  @override
  String get code_must_be_6_digits => 'يجب أن يتكون الرمز من 6 أرقام';

  @override
  String get verify => 'تحقق';

  @override
  String get resend_code => 'إعادة إرسال الرمز';

  @override
  String get reset_link_sent =>
      'إذا كان هناك حساب بهذا البريد الإلكتروني، فقد تم إرسال رابط لإعادة تعيين كلمة المرور.';

  @override
  String get passwords_dont_match => 'كلمات المرور غير متطابقة';

  @override
  String get update_your_security => 'تحديث الأمان الخاص بك';

  @override
  String get ensure_account_secure =>
      'تأكد من بقاء حسابك آمنًا باستخدام كلمة مرور قوية.';

  @override
  String get password_changed_success => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get password_changed_error => 'فشل تغيير كلمة المرور';

  @override
  String get ai_text_generation => 'توليد النصوص بالذكاء الاصطناعي';

  @override
  String get quota_exceeded_web_upgrade =>
      'تم تجاوز الحصة. يرجى زيارة موقعنا لتحديث خطتك والمتابعة.';

  @override
  String get monthly_limit_reached_web_upgrade =>
      'تم الوصول إلى الحد الشهري. يرجى زيارة موقعنا لتحديث خطتك.';

  @override
  String get enter_your_prompt => 'أدخل مطالبتك';

  @override
  String get generate => 'توليد';

  @override
  String get validate_and_merge => 'التحقق والدمج';

  @override
  String get no_articles_to_validate => 'لا توجد مقالات للتحقق منها.';

  @override
  String get previous => 'السابق';

  @override
  String get please_enter_title => 'يرجى إدخال عنوان.';

  @override
  String get articles_merged_successfully =>
      'تم دمج المقالات بنجاح! جاري التحويل للتعديل.';

  @override
  String get merge_articles => 'دمج المقالات';

  @override
  String get cancel => 'إلغاء';

  @override
  String validate_article(Object current, Object total) {
    return 'التحقق من المقال $current من $total';
  }

  @override
  String get captcha_instruction => 'لقد أكملت تسجيل الدخول/الكابتشا في الصفحة';

  @override
  String get quota_reached_web =>
      'تم الوصول إلى الحصة. يرجى زيارة موقعنا للتحديث.';

  @override
  String get title_merged_article => 'عنوان المقال المدمج';

  @override
  String failed_to_merge(Object error) {
    return 'فشل دمج المقالات: $error';
  }

  @override
  String get next => 'التالي';

  @override
  String get title => 'العنوان';

  @override
  String get error => 'خطأ';

  @override
  String get loading_content => 'جاري تحميل المحتوى...';

  @override
  String get edit_merged_content => 'تعديل المحتوى المدمج';

  @override
  String get body => 'المحتوى';

  @override
  String get please_enter_content => 'يرجى إدخال بعض المحتوى.';

  @override
  String get no_articles_found => 'لم يتم العثور على مقالات.';

  @override
  String get fetching_all_feeds => 'جاري جلب جميع الخلاصات...';

  @override
  String get all => 'الكل';

  @override
  String get draft => 'مسودة';

  @override
  String get published => 'منشور';

  @override
  String get no_merged_contents => 'لم يتم العثور على محتويات مدمجة.';

  @override
  String status_label(Object status) {
    return 'الحالة: $status';
  }

  @override
  String get no_rss_feeds => 'لم يتم العثور على خلاصات RSS.';

  @override
  String get delete_rss_feed => 'حذف خلاصة RSS';

  @override
  String get delete_feed_confirmation =>
      'هل أنت متأكد أنك تريد حذف هذه الخلاصة؟';

  @override
  String get delete => 'حذف';

  @override
  String get publish_options => 'خيارات النشر';

  @override
  String get status => 'الحالة';

  @override
  String get external_endpoint => 'نقطة نهاية خارجية';

  @override
  String get none => 'لا يوجد';

  @override
  String get publish => 'نشر';

  @override
  String get update_rss_feed => 'تحديث خلاصة RSS';

  @override
  String get add_rss_feed => 'إضافة خلاصة RSS';

  @override
  String get feed_url => 'رابط الخلاصة';

  @override
  String get enter_url => 'يرجى إدخال رابط صحيح';

  @override
  String get auto_generate_name => 'توليد الاسم تلقائياً';

  @override
  String get save => 'حفظ';

  @override
  String get add => 'إضافة';

  @override
  String get no_external_endpoints => 'لم يتم العثور على نقاط نهاية خارجية.';

  @override
  String get delete_endpoint => 'حذف نقطة النهاية';

  @override
  String delete_endpoint_confirmation(Object name) {
    return 'هل أنت متأكد أنك تريد حذف $name؟';
  }

  @override
  String get endpoint_deleted_successfully => 'تم حذف نقطة النهاية بنجاح!';

  @override
  String get external_endpoint_updated =>
      'تم تحديث نقطة النهاية الخارجية بنجاح!';

  @override
  String get external_endpoint_created =>
      'تم إنشاء نقطة النهاية الخارجية بنجاح!';

  @override
  String get edit_endpoint => 'تعديل نقطة النهاية';

  @override
  String get create_new_endpoint => 'إنشاء نقطة نهاية جديدة';

  @override
  String get platform_name => 'اسم المنصة';

  @override
  String get api_url => 'رابط API';

  @override
  String get auth_token_label => 'رمز المصادقة (مفتاح API)';

  @override
  String get update_endpoint => 'تحديث نقطة النهاية';

  @override
  String get create_endpoint => 'إنشاء نقطة النهاية';

  @override
  String failed_to_save_options(Object error) {
    return 'فشل حفظ الخيارات: $error';
  }

  @override
  String failed_to_publish(Object error) {
    return 'فشل النشر: $error';
  }

  @override
  String get page_not_found => 'الصفحة غير موجودة';

  @override
  String page_path_not_found(Object path) {
    return 'الصفحة $path غير موجودة';
  }

  @override
  String get go_home => 'الذهاب للرئيسية';

  @override
  String get live_chat => 'الدعم المباشر';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get no_messages => 'لا توجد رسائل بعد. أرسل رسالة لبدء الدردشة!';

  @override
  String get type_message => 'اكتب رسالة...';

  @override
  String get quota_reached => 'تم الوصول إلى الحصة';

  @override
  String get quota_reached_upgrade =>
      'تم الوصول إلى الحصة. يرجى زيارة موقعنا للتحديث.';

  @override
  String get monthly_limit_reached => 'تم الوصول إلى الحد الشهري';

  @override
  String get quota_reached_explanation =>
      'لقد وصلت إلى حصتك الشهرية من الرموز. يرجى زيارة موقعنا لتحديث خطتك والمتابعة في استخدام ميزات الذكاء الاصطناعي.';

  @override
  String get enjoying_app => 'هل تستمتع بالتطبيق؟';

  @override
  String get no_thanks => 'لا شكراً';

  @override
  String get sure => 'بالتأكيد!';

  @override
  String get whats_new => 'ما الجديد:';

  @override
  String get later => 'لاحقاً';

  @override
  String get view_plans => 'عرض الخطط';

  @override
  String get close => 'إغلاق';

  @override
  String get share_feedback_question => 'هل ترغب في مشاركة تعليقاتك معنا؟';

  @override
  String get feedback_matters => 'رأيك يهمنا';

  @override
  String get share_thoughts =>
      'يرجى مشاركة أفكارك حول التطبيق. إذا كنت تستمتع به، فسنكون ممتنين جداً لتقييمك على متجر التطبيقات!';

  @override
  String get feedback_hint => 'أدخل تعليقاتك هنا';

  @override
  String get submit => 'إرسال';

  @override
  String get required_update => 'تحديث مطلوب';

  @override
  String get update_available => 'تحديث متاح';

  @override
  String critical_update_message(Object version) {
    return 'مطلوب تحديث مهم (الإصدار $version) للمتابعة في استخدام هذا التطبيق.';
  }

  @override
  String new_version_available(Object version) {
    return 'يتوفر إصدار جديد ($version).';
  }

  @override
  String get update_now => 'تحديث الآن';

  @override
  String get update => 'تحديث';
}
