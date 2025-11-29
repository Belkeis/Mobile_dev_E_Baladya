import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Home Page
  String get welcome => 'مرحبا بك في البلدية الرقمية';
  String get digitalDocuments => 'الوثائق الرقمية';
  String get onlineRequests => 'طلبات عبر الإنترنت';
  String get requiredDocuments => 'الوثائق المطلوبة';
  String get trackingRequests => 'تتبع الطلبات';
  String get bookAppointment => 'حجز موعد';

  // Online Requests
  String get onlineRequestsTitle => 'الطلبات الإلكترونية';
  String get onlineRequestsSubtitle => 'اختر نوع الطلب وأكمل تأكيد معلوماتك لتقديمه إلكترونيًا بسهولة.';

  // Tracking Requests
  String get trackingTitle => 'تتبع الطلب';
  String get newRequest => 'طلب جديد';
  String get requestStatus => 'حالة الطلب:';
  String get remainingTime => 'الوقت المتبقي:';
  String get requestDate => 'وقت الطلب:';

  // Required Documents
  String get requiredDocumentsTitle => 'الوثائق المطلوبة';
  String get requiredDocumentsSubtitle => 'تعرّف على الوثائق المطلوبة لإتمام مختلف المعاملات الإدارية بسهولة.';

  // Digital Documents
  String get digitalDocumentsTitle => 'الوثائق الرقمية';
  String get viewDocument => 'عرض الوثيقة';
  String get downloadDocument => 'تحميل الوثيقة';

  // Status
  String get pending => 'قيد المراجعة';
  String get approved => 'مقبول';
  String get ready => 'جاهز';
  String get rejected => 'مرفوض';

  // Common
  String get submit => 'إرسال';
  String get cancel => 'إلغاء';
  String get confirm => 'تأكيد';
  String get loading => 'جاري التحميل...';
  String get error => 'حدث خطأ';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}


