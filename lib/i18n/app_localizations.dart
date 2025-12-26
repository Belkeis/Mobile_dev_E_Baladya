import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';
  bool get isFrench => locale.languageCode == 'fr';

  String translate(String key) {
    switch (key) {
      case 'profile':
        return isArabic ? 'الملف الشخصي' : 'Profil';
      case 'admin_login':
        return isArabic ? 'تسجيل دخول المسؤول' : 'Connexion Admin';
      case 'admin_login_subtitle':
        return isArabic
            ? 'أدخل بياناتك للدخول كمسؤول'
            : 'Entrez vos informations pour vous connecter en tant qu\'administrateur';
      case 'admin_login_button':
        return isArabic ? 'تسجيل الدخول كمسؤول' : 'Connexion Administrateur';
      case 'admin_dashboard':
        return isArabic ? 'لوحة تحكم المسؤول' : 'Tableau de Bord Admin';
      case 'admin_notifications':
        return isArabic ? 'إشعارات المسؤول' : 'Notifications Admin';
      case 'admin_welcome':
        return isArabic ? 'مرحباً بك' : 'Bienvenue';
      case 'admin_dashboard_subtitle':
        return isArabic
            ? 'قم بإدارة الطلبات والحجوزات ومتابعة آخر المستجدات.'
            : 'Gérez les demandes, les réservations et suivez les dernières mises à jour.';
      case 'quick_actions':
        return isArabic ? 'إجراءات سريعة' : 'Actions Rapides';
      case 'recent_activity':
        return isArabic ? 'آخر النشاطات' : 'Activité Récente';

      case 'track_requests':
        return trackingRequests;
      case 'track_bookings':
        return isArabic ? 'تتبع الحجوزات' : 'Suivi des Réservations';
      case 'manage_users':
        return isArabic ? 'إدارة المستخدمين' : 'Gérer les Utilisateurs';
      case 'settings':
        return isArabic ? 'الإعدادات' : 'Paramètres';

      case 'search_bookings':
        return isArabic ? 'ابحث عن الحجوزات...' : 'Rechercher des réservations...';
      case 'no_bookings_found':
        return isArabic ? 'لا توجد حجوزات مطابقة' : 'Aucune réservation trouvée';
      case 'booking':
        return isArabic ? 'حجز' : 'Réservation';
      case 'booking_date':
        return isArabic ? 'تاريخ الموعد' : 'Date du rendez-vous';
      case 'booking_details':
        return isArabic ? 'تفاصيل الحجز' : 'Détails de la Réservation';
      case 'booking_type':
        return isArabic ? 'نوع الحجز' : 'Type de réservation';
      case 'update_booking_status':
        return isArabic ? 'تحديث حالة الحجز' : 'Mettre à jour le statut de réservation';
      case 'booking_status_updated':
        return isArabic ? 'تم تحديث حالة الحجز' : 'Statut de réservation mis à jour';
      case 'booking_details_short':
        return isArabic ? 'اضغط لعرض التفاصيل' : 'Appuyez pour voir les détails';

      case 'search_users':
        return isArabic ? 'ابحث عن المستخدمين...' : 'Rechercher des utilisateurs...';
      case 'no_users_found':
        return isArabic ? 'لا يوجد مستخدمون مطابقون' : 'Aucun utilisateur trouvé';
      case 'filter_role':
        return isArabic ? 'الدور' : 'Rôle';
      case 'filter_user_status':
        return isArabic ? 'الحالة' : 'Statut';
      case 'role_all':
        return isArabic ? 'الكل' : 'Tous';
      case 'role_citizen':
        return isArabic ? 'مواطن' : 'Citoyen';
      case 'role_admin':
        return isArabic ? 'مسؤول' : 'Administrateur';
      case 'user_active':
        return isArabic ? 'نشط' : 'Actif';
      case 'user_blocked':
        return isArabic ? 'محظور' : 'Bloqué';
      case 'block_user':
        return isArabic ? 'حظر' : 'Bloquer';
      case 'unblock_user':
        return isArabic ? 'إلغاء الحظر' : 'Débloquer';

      case 'admin_settings_title':
        return isArabic ? 'إعدادات المسؤول' : 'Paramètres Admin';
      case 'setting_push_notifications':
        return isArabic ? 'تفعيل الإشعارات' : 'Activer les notifications';
      case 'setting_sound':
        return isArabic ? 'الصوت' : 'Son';
      case 'setting_email_notifications':
        return isArabic ? 'إشعارات البريد الإلكتروني' : 'Notifications e-mail';
      case 'setting_maintenance_mode':
        return isArabic ? 'وضع الصيانة' : 'Mode maintenance';

      case 'admin_profile_title':
        return isArabic ? 'حساب المسؤول' : 'Profil Administrateur';
      case 'admin_role':
        return isArabic ? 'الصفة' : 'Rôle';
      case 'municipality':
        return isArabic ? 'البلدية' : 'Municipalité';

      case 'citizen_login':
        return isArabic ? 'تسجيل الدخول كمواطن' : 'Connexion Citoyen';
      case 'invalid_credentials':
        return isArabic
            ? 'بيانات الدخول غير صحيحة. الرجاء المحاولة مرة أخرى.'
            : 'Identifiants invalides. Veuillez réessayer.';

      case 'search':
        return isArabic ? 'بحث' : 'Recherche';

      case 'requests':
        return isArabic ? 'الطلبات' : 'Demandes';
      case 'bookings':
        return isArabic ? 'الحجوزات' : 'Réservations';
      case 'users':
        return isArabic ? 'المستخدمون' : 'Utilisateurs';

      case 'update_status_dialog_title':
        return isArabic ? 'تحديث الحالة' : 'Mettre à jour le statut';
      case 'current_status':
        return isArabic ? 'الحالة الحالية' : 'Statut actuel';
      case 'new_status':
        return isArabic ? 'الحالة الجديدة' : 'Nouveau statut';
      case 'cancel_upper':
        return isArabic ? 'إلغاء' : 'ANNULER';
      case 'update_upper':
        return isArabic ? 'تحديث' : 'METTRE À JOUR';
      case 'status_updated':
        return isArabic ? 'تم تحديث الحالة' : 'Statut mis à jour';

      case 'all':
        return isArabic ? 'الكل' : 'Tous';
      case 'pending_key':
        return pending;
      case 'approved_key':
        return approved;
      case 'ready_key':
        return ready;
      case 'rejected_key':
        return rejected;
      case 'filter_status':
        return isArabic ? 'الحالة' : 'Statut';
      case 'filter_priority':
        return isArabic ? 'الأولوية' : 'Priorité';
      case 'priority_high':
        return isArabic ? 'مرتفعة' : 'Haute';
      case 'priority_medium':
        return isArabic ? 'متوسطة' : 'Moyenne';
      case 'priority_low':
        return isArabic ? 'منخفضة' : 'Faible';

      case 'email':
        return email;
      case 'password':
        return password;
      case 'login':
        return login;
      case 'back_to_home':
        return backToHome;

      case 'email_required':
        return pleaseEnterEmail;
      case 'invalid_email':
        return pleaseEnterValidEmail;
      case 'password_required':
        return pleaseEnterPassword;
      case 'password_too_short':
        return passwordMinLength;

      case 'search_requests':
        return isArabic ? 'ابحث عن الطلبات...' : 'Rechercher des demandes...';
      case 'no_requests_found':
        return isArabic ? 'لا توجد طلبات مطابقة' : 'Aucune demande trouvée';
      case 'request':
        return isArabic ? 'طلب' : 'Demande';
      case 'submitted':
        return isArabic ? 'تم الإرسال:' : 'Soumis :';
      case 'update_status':
        return isArabic ? 'تحديث الحالة' : 'Mettre à jour le statut';

      case 'request_details':
        return isArabic ? 'تفاصيل الطلب' : 'Détails de la Demande';
      case 'request_type':
        return isArabic ? 'نوع الطلب' : 'Type de Demande';
      case 'citizen_name':
        return isArabic ? 'اسم المواطن' : 'Nom du Citoyen';
      case 'submission_date':
        return isArabic ? 'تاريخ الإرسال' : 'Date de Soumission';
      case 'status':
        return isArabic ? 'الحالة' : 'Statut';
      case 'priority':
        return isArabic ? 'الأولوية' : 'Priorité';

      case 'close':
        return close;

      default:
        return key;
    }
  }

  // Home Page
  String get welcome => isArabic ? 'مرحبا بك في البلدية الرقمية' : 'Bienvenue dans la Mairie Numérique';
  String get digitalDocuments => isArabic ? 'الوثائق الرقمية' : 'Documents Numériques';
  String get onlineRequests => isArabic ? 'طلبات عبر الإنترنت' : 'Demandes en Ligne';
  String get requiredDocuments => isArabic ? 'الوثائق المطلوبة' : 'Documents Requis';
  String get trackingRequests => isArabic ? 'تتبع الطلبات' : 'Suivi des Demandes';
  String get bookAppointment => isArabic ? 'حجز موعد' : 'Réserver un Rendez-vous';
  String get myBookings => isArabic ? 'حجوزاتي' : 'Mes Réservations';

  // Online Requests
  String get onlineRequestsTitle => isArabic ? 'الطلبات الإلكترونية' : 'Demandes Électroniques';
  String get onlineRequestsSubtitle => isArabic 
      ? 'اختر نوع الطلب وأكمل تأكيد معلوماتك لتقديمه إلكترونيًا بسهولة.'
      : 'Choisissez le type de demande et complétez la confirmation de vos informations pour la soumettre facilement en ligne.';

  // Tracking Requests
  String get trackingTitle => isArabic ? 'تتبع الطلب' : 'Suivi de la Demande';
  String get newRequest => isArabic ? 'طلب جديد' : 'Nouvelle Demande';
  String get requestStatus => isArabic ? 'حالة الطلب:' : 'Statut de la Demande:';
  String get remainingTime => isArabic ? 'الوقت المتبقي:' : 'Temps Restant:';
  String get requestDate => isArabic ? 'وقت الطلب:' : 'Date de la Demande:';
  String get noRequests => isArabic ? 'لا توجد طلبات' : 'Aucune Demande';

  // Required Documents
  String get requiredDocumentsTitle => isArabic ? 'الوثائق المطلوبة' : 'Documents Requis';
  String get requiredDocumentsSubtitle => isArabic 
      ? 'تعرّف على الوثائق المطلوبة لإتمام مختلف المعاملات الإدارية بسهولة.'
      : 'Découvrez les documents requis pour compléter facilement diverses transactions administratives.';

  // Digital Documents
  String get digitalDocumentsTitle => isArabic ? 'الوثائق الرقمية' : 'Documents Numériques';
  String get viewDocument => isArabic ? 'عرض الوثيقة' : 'Voir le Document';
  String get downloadDocument => isArabic ? 'تحميل الوثيقة' : 'Télécharger le Document';
  String get noDigitalDocuments => isArabic ? 'لا توجد وثائق رقمية' : 'Aucun Document Numérique';
  String get digitalDocumentsSubtitle => isArabic 
      ? 'الوصول إلى جميع الوثائق الرسمية الرقمية بسهولة وتنزيلها مباشرة من هذه الصفحة'
      : 'Accédez facilement à tous les documents officiels numériques et téléchargez-les directement depuis cette page';

  // Status
  String get pending => isArabic ? 'قيد المراجعة' : 'En Attente';
  String get approved => isArabic ? 'مقبول' : 'Approuvé';
  String get ready => isArabic ? 'جاهز' : 'Prêt';
  String get rejected => isArabic ? 'مرفوض' : 'Rejeté';
  String get waiting => isArabic ? 'قيد الانتظار' : 'En Attente';
  String get confirmed => isArabic ? 'مؤكد' : 'Confirmé';
  String get cancelled => isArabic ? 'ملغي' : 'Annulé';

  // Common
  String get submit => isArabic ? 'إرسال' : 'Envoyer';
  String get cancel => isArabic ? 'إلغاء' : 'Annuler';
  String get confirm => isArabic ? 'تأكيد' : 'Confirmer';
  String get loading => isArabic ? 'جاري التحميل...' : 'Chargement...';
  String get error => isArabic ? 'حدث خطأ' : 'Une Erreur s\'est Produite';
  String get back => isArabic ? 'رجوع' : 'Retour';
  String get save => isArabic ? 'حفظ' : 'Enregistrer';
  String get edit => isArabic ? 'تعديل' : 'Modifier';
  String get delete => isArabic ? 'حذف' : 'Supprimer';
  String get close => isArabic ? 'إغلاق' : 'Fermer';
  String get yes => isArabic ? 'نعم' : 'Oui';
  String get no => isArabic ? 'لا' : 'Non';
  String get ok => isArabic ? 'موافق' : 'OK';

  // Auth & Sign Up
  String get login => isArabic ? 'تسجيل الدخول' : 'Se Connecter';
  String get signUp => isArabic ? 'إنشاء حساب' : 'Créer un Compte';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Se Déconnecter';
  String get logoutConfirm => isArabic ? 'هل أنت متأكد من رغبتك في تسجيل الخروج؟' : 'Êtes-vous sûr de vouloir vous déconnecter?';
  String get forgotPassword => isArabic ? 'نسيت كلمة المرور؟' : 'Mot de Passe Oublié?';
  String get rememberMe => isArabic ? 'تذكرني' : 'Se Souvenir de Moi';
  String get alreadyHaveAccount => isArabic ? 'لديك حساب بالفعل؟ ' : 'Vous avez déjà un compte? ';
  String get createAccount => isArabic ? 'إنشاء حساب جديد' : 'Créer un Nouveau Compte';
  String get createAccountSubtitle => isArabic ? 'أنشئ حسابك للبدء' : 'Créez votre compte pour commencer';
  String get loginSubtitle => isArabic ? 'أدخل بياناتك للوصول إلى حسابك' : 'Entrez vos informations pour accéder à votre compte';
  String get systemTitle => isArabic ? 'نظام إدارة الخدمات البلدية' : 'Système de Gestion des Services Municipaux';
  String get allRightsReserved => isArabic ? 'جميع الحقوق محفوظة © 2024 البلدية\nالإلكترونية' : 'Tous Droits Réservés © 2024 Mairie\nÉlectronique';
  String get startNow => isArabic ? 'ابدأ الآن' : 'Commencer Maintenant';

  // Form Fields
  String get fullName => isArabic ? 'الاسم الكامل' : 'Nom Complet';
  String get email => isArabic ? 'البريد الإلكتروني' : 'E-mail';
  String get phone => isArabic ? 'رقم الهاتف' : 'Numéro de Téléphone';
  String get nationalId => isArabic ? 'رقم البطاقة الوطنية' : 'Numéro de Carte Nationale';
  String get password => isArabic ? 'كلمة المرور' : 'Mot de Passe';
  String get enterFullName => isArabic ? 'أدخل اسمك الكامل' : 'Entrez votre nom complet';
  String get enterEmail => isArabic ? 'أدخل بريدك الإلكتروني' : 'Entrez votre e-mail';
  String get enterPhone => isArabic ? 'أدخل رقم هاتفك' : 'Entrez votre numéro de téléphone';
  String get enterNationalId => isArabic ? 'أدخل رقم البطاقة' : 'Entrez le numéro de carte';
  String get enterPassword => isArabic ? 'أدخل كلمة المرور' : 'Entrez votre mot de passe';
  String get notAvailable => isArabic ? 'غير متوفر' : 'Non Disponible';

  // Validation Messages
  String get pleaseEnterName => isArabic ? 'الرجاء إدخال الاسم' : 'Veuillez entrer le nom';
  String get pleaseEnterEmail => isArabic ? 'الرجاء إدخال البريد الإلكتروني' : 'Veuillez entrer l\'e-mail';
  String get pleaseEnterValidEmail => isArabic ? 'الرجاء إدخال بريد إلكتروني صحيح' : 'Veuillez entrer un e-mail valide';
  String get pleaseEnterPhone => isArabic ? 'الرجاء إدخال رقم الهاتف' : 'Veuillez entrer le numéro de téléphone';
  String get pleaseEnterValidPhone => isArabic ? 'الرجاء إدخال رقم هاتف  صحيح' : 'Veuillez entrer un numéro de téléphone valide';
  String get pleaseEnterPassword => isArabic ? 'الرجاء إدخال كلمة المرور' : 'Veuillez entrer le mot de passe';
  String get passwordMinLength => isArabic ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Le mot de passe doit contenir au moins 6 caractères';
  String get pleaseEnterNationalId => isArabic ? 'الرجاء إدخال رقم البطاقة' : 'Veuillez entrer le numéro de carte';
  String get nationalIdLength => isArabic ? 'رقم البطاقة يجب أن يتكون من 18 رقماً' : 'Le numéro de carte doit contenir 18 chiffres';
  String get pleaseFillAllFields => isArabic ? 'الرجاء ملء جميع الحقول المطلوبة' : 'Veuillez remplir tous les champs requis';
  String get pleaseFillAllFieldsCorrectly => isArabic ? 'الرجاء ملء جميع الحقول بشكل صحيح' : 'Veuillez remplir tous les champs correctement';
  String get pleaseFillAllInfo => isArabic ? 'الرجاء ملء جميع المعلومات بشكل صحيح' : 'Veuillez remplir toutes les informations correctement';
  String get pleaseLogin => isArabic ? 'الرجاء تسجيل الدخول' : 'Veuillez vous connecter';

  // Profile
  String get editData => isArabic ? 'تعديل البيانات' : 'Modifier les Données';
  String get saveChanges => isArabic ? 'حفظ التغييرات' : 'Enregistrer les Modifications';
  String get dataUpdatedSuccessfully => isArabic ? 'تم تحديث البيانات بنجاح' : 'Données mises à jour avec succès';
  String get confirmPersonalData => isArabic ? 'تأكيد البيانات الشخصية' : 'Confirmer les Données Personnelles';
  String get confirmPersonalDataSubtitle => isArabic 
      ? 'يرجى مراجعة معلوماتك لتأكيد هويتك واستكمال الطلب بسهولة.'
      : 'Veuillez vérifier vos informations pour confirmer votre identité et compléter la demande facilement.';

  // Booking
  String get bookYourAppointment => isArabic ? 'احجز موعدك' : 'Réservez votre Rendez-vous';
  String get selectServiceType => isArabic ? 'اختر نوع الخدمة المطلوبة' : 'Sélectionnez le Type de Service Requis';
  String get civilStatus => isArabic ? 'الحالة المدنية' : 'État Civil';
  String get civilStatusSubtitle => isArabic ? 'استخراج وثائق الحالة المدنية' : 'Extraction de documents d\'état civil';
  String get biometricServices => isArabic ? 'المصالح البيومترية' : 'Services Biométriques';
  String get biometricServicesSubtitle => isArabic ? 'خدمات البصمة والبيانات البيومترية' : 'Services d\'empreintes et données biométriques';
  String get pickup => isArabic ? 'الاستلام' : 'Collecte';
  String get pickupSubtitle => isArabic ? 'استلام الوثائق الجاهزة' : 'Collecte des documents prêts';
  String get bookingIn => isArabic ? 'حجز في' : 'Réservation dans';
  String get book => isArabic ? 'احجز' : 'Réserver';
  String get greenAvailable => isArabic ? 'الأخضر متاح للحجز' : 'Vert Disponible pour Réservation';
  String get redNotAvailable => isArabic ? 'الأحمر غير متاح للحجز' : 'Rouge Non Disponible pour Réservation';
  String get mustLoginFirst => isArabic ? 'يجب تسجيل الدخول أولاً' : 'Vous devez d\'abord vous connecter';
  String get bookingSuccess => isArabic ? 'تم حجز الموعد بنجاح' : 'Rendez-vous réservé avec succès';
  String get processingTime => isArabic ? 'مدة المعالجة' : 'Délai de Traitement';
  String get fees => isArabic ? 'الرسوم' : 'Frais';
  String get requestNow => isArabic ? 'طلب الآن' : 'Demander Maintenant';
  String get afterRequestMessage => isArabic 
      ? 'بعد تقديم الطلب، ستحصل على إشعار تأكيد. ثم قم بزيارة البلدية لاستلام الوثيقة والدفع (مثال: {fee} دج).'
      : 'Après avoir soumis la demande, vous recevrez une notification de confirmation. Ensuite, visitez la mairie pour récupérer le document et payer (exemple: {fee} DA).';
  String afterRequestMessageReplace(String fee) => afterRequestMessage.replaceAll('{fee}', fee);

  // My Bookings
  String get myBookingsTitle => isArabic ? 'حجوزاتي' : 'Mes Réservations';
  String get myBookingsSubtitle => isArabic ? 'عرض جميع حجوزاتك والمواعيد المحددة' : 'Voir toutes vos réservations et rendez-vous programmés';
  String get noBookings => isArabic ? 'لا توجد حجوزات' : 'Aucune Réservation';
  String get status => isArabic ? 'الحالة:' : 'Statut:';
  String get service => isArabic ? 'خدمة' : 'Service';

  // After Request
  String get requestSubmittedSuccessfully => isArabic ? 'تم تقديم طلبك بنجاح!' : 'Votre demande a été soumise avec succès!';
  String get requestSubmittedSubtitle => isArabic 
      ? 'سيتم التواصل معك قريباً لتأكيد الخطوات القادمة.'
      : 'Nous vous contacterons bientôt pour confirmer les prochaines étapes.';
  String get backToHome => isArabic ? 'العودة إلى الصفحة الرئيسية' : 'Retour à la Page d\'Accueil';

  // Service Requirements
  String get noRequiredDocuments => isArabic ? 'لا توجد وثائق مطلوبة' : 'Aucun Document Requis';
  String get bringAllDocuments => isArabic 
      ? 'يرجى التأكد من إحضار جميع الوثائق المطلوبة عند زيارة البلدية.'
      : 'Veuillez vous assurer d\'apporter tous les documents requis lors de votre visite à la mairie.';

  // Notifications
  String get notifications => isArabic ? 'الإشعارات' : 'Notifications';
  String get requestApproved => isArabic ? 'تم الموافقة على طلبك' : 'Votre demande a été approuvée';
  String get requestApprovedDesc => isArabic ? 'تم الموافقة على طلب تجديد بطاقة الهوية الخاصة بك' : 'Votre demande de renouvellement de carte d\'identité a été approuvée';
  String get appointmentReminder => isArabic ? 'تذكير بموعدك' : 'Rappel de Rendez-vous';
  String get appointmentReminderDesc => isArabic ? 'لديك موعد غداً في الساعة 10:00 صباحاً' : 'Vous avez un rendez-vous demain à 10h00';
  String get requestStatusUpdate => isArabic ? 'تحديث في حالة الطلب' : 'Mise à Jour du Statut de la Demande';
  String get requestStatusUpdateDesc => isArabic ? 'طلب تجديد جواز السفر الخاص بك قيد المراجعة' : 'Votre demande de renouvellement de passeport est en cours d\'examen';
  String get documentsRequired => isArabic ? 'وثائق مطلوبة' : 'Documents Requis';
  String get documentsRequiredDesc => isArabic ? 'يرجى تحميل الوثائق الإضافية لإكمال طلبك' : 'Veuillez télécharger les documents supplémentaires pour compléter votre demande';
  String get documentExpiring => isArabic ? 'انتهت صلاحية الوثيقة' : 'Document Expiré';
  String get documentExpiringDesc => isArabic ? 'بطاقة الهوية الخاصة بك ستنتهي صلاحيتها خلال 30 يوماً' : 'Votre carte d\'identité expirera dans 30 jours';
  String get appointmentConfirmed => isArabic ? 'تم تأكيد الموعد' : 'Rendez-vous Confirmé';
  String get appointmentConfirmedDesc => isArabic ? 'تم تأكيد موعدك بنجاح ليوم 15 نوفمبر 2025' : 'Votre rendez-vous a été confirmé avec succès pour le 15 novembre 2025';

  // Calendar
  List<String> get weekDays => isArabic 
      ? ['خ', 'ج', 'س', 'ح', 'إ', 'ث', 'أ']
      : ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  List<String> get months => isArabic
      ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
      : ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];

  // Document
  String get documentWillOpenSoon => isArabic ? 'سيتم فتح الوثيقة قريباً' : 'Le document sera ouvert bientôt';
  String get digitalDocument => isArabic ? 'وثيقة رقمية' : 'Document Numérique';
  String get days => isArabic ? 'أيام' : 'jours';
  String get expired => isArabic ? 'منتهي' : 'Expiré';
  String get currency => isArabic ? 'دج' : 'DA';
  
  // Service Details & Confirmation Dialog
  String get confirmRequest => isArabic ? 'تأكيد الطلب' : 'Confirmer la Demande';
  String get fullNameLabel => isArabic ? 'الاسم الكامل:' : 'Nom Complet:';
  String get emailLabel => isArabic ? 'البريد الإلكتروني:' : 'E-mail:';
  String get phoneLabel => isArabic ? 'رقم الهاتف:' : 'Numéro de Téléphone:';
  String get nationalIdLabel => isArabic ? 'رقم الهوية:' : 'Numéro d\'Identité:';
  String get processingTimeLabel => isArabic ? 'مدة المعالجة' : 'Délai de Traitement';
  String get feesLabel => isArabic ? 'الرسوم' : 'Frais';
  String get requiredDocumentsLabel => isArabic ? 'الوثائق المطلوبة' : 'Documents Requis';
  
  // Error Messages
  String get errorOccurred => isArabic ? 'حدث خطأ' : 'Une Erreur s\'est Produite';
  String errorMessage(String error) => isArabic ? 'حدث خطأ: $error' : 'Une Erreur s\'est Produite: $error';

  // Service Name Translations (mapping from Arabic to French)
  String translateServiceName(String arabicName) {
    if (isArabic) return arabicName;
    
    final translations = {
      'تجديد بطاقة تعريف وطنية': 'Renouvellement de Carte d\'Identité Nationale',
      'تجديد بطاقة التعريف الوطنية': 'Renouvellement de Carte d\'Identité Nationale',
      'تجديد جواز السفر': 'Renouvellement de Passeport',
      'شهادة ميلاد': 'Acte de Naissance',
      'عقد زواج': 'Acte de Mariage',
      'عقد الزواج': 'Acte de Mariage',
      'شهادة إقامة': 'Certificat de Résidence',
      'بطاقة التعريف الوطنية': 'Carte d\'Identité Nationale',
      'بطاقة تعريف وطنية': 'Carte d\'Identité Nationale',
      'الحالة المدنية': 'État Civil',
      'المصالح البيومترية': 'Services Biométriques',
      'الاستلام': 'Collecte',
      'جواز السفر': 'Passeport',
    };
    
    return translations[arabicName] ?? arabicName;
  }
  
  // Service Description Translations
  String translateServiceDescription(String arabicDescription) {
    if (isArabic) return arabicDescription;
    
    // Common descriptions
    final translations = {
      'استخراج وثائق الحالة المدنية': 'Extraction de documents d\'état civil',
      'خدمات البصمة والبيانات البيومترية': 'Services d\'empreintes et données biométriques',
      'استلام الوثائق الجاهزة': 'Collecte des documents prêts',
      'تجديد البطاقة الوطنية عند انتهاء صلاحيتها': 'Renouvellement de la carte nationale à l\'expiration de sa validité',
      'تجديد جواز السفر عند انتهاء صلاحيته': 'Renouvellement du passeport à l\'expiration de sa validité',
      'الحصول على شهادة ميلاد جديدة': 'Obtenir un nouvel acte de naissance',
      'الحصول على عقد زواج': 'Obtenir un acte de mariage',
      'الحصول على شهادة إقامة': 'Obtenir un certificat de résidence',
    };
    
    return translations[arabicDescription] ?? arabicDescription;
  }

  // Document Name Translations
  String translateDocumentName(String arabicName) {
    if (isArabic) return arabicName;
    
    final translations = {
      'شهادة ميلاد': 'Acte de Naissance',
      'نسخة من بطاقة الهوية': 'Copie de la Carte d\'Identité',
      'نموذج الطلب': 'Formulaire de Demande',
      'صورة شخصية': 'Photo d\'Identité',
      'إثبات الإقامة': 'Preuve de Résidence',
      'بطاقة التعريف الوطنية': 'Carte d\'Identité Nationale',
      'جواز السفر': 'Passeport',
      'شهادة الجنسية': 'Certificat de Nationalité',
      'شهادة الإقامة': 'Certificat de Résidence',
      'عقد الزواج': 'Acte de Mariage',
      'شهادة الطلاق': 'Acte de Divorce',
      'شهادة الوفاة': 'Acte de Décès',
    };
    
    return translations[arabicName] ?? arabicName;
  }
  
  // Processing Time Translation (e.g., "7 أيام" -> "7 jours")
  String translateProcessingTime(String arabicTime) {
    if (isArabic) return arabicTime;
    
    // Replace "أيام" with "jours"
    return arabicTime.replaceAll('أيام', 'jours').replaceAll('يوم', 'jour');
  }
}

// Translation helper utility
class TranslationHelper {
  static String translateServiceName(String arabicName, Locale locale) {
    if (locale.languageCode == 'ar') return arabicName;
    
    final translations = {
      'تجديد بطاقة تعريف وطنية': 'Renouvellement de Carte d\'Identité Nationale',
      'تجديد جواز السفر': 'Renouvellement de Passeport',
      'شهادة ميلاد': 'Acte de Naissance',
      'عقد زواج': 'Acte de Mariage',
      'شهادة إقامة': 'Certificat de Résidence',
      'بطاقة التعريف الوطنية': 'Carte d\'Identité Nationale',
      'الحالة المدنية': 'État Civil',
      'المصالح البيومترية': 'Services Biométriques',
      'الاستلام': 'Collecte',
    };
    
    return translations[arabicName] ?? arabicName;
  }

  static String translateDocumentName(String arabicName, Locale locale) {
    if (locale.languageCode == 'ar') return arabicName;
    
    final translations = {
      'شهادة ميلاد': 'Acte de Naissance',
      'نسخة من بطاقة الهوية': 'Copie de la Carte d\'Identité',
      'نموذج الطلب': 'Formulaire de Demande',
      'صورة شخصية': 'Photo d\'Identité',
      'إثبات الإقامة': 'Preuve de Résidence',
    };
    
    return translations[arabicName] ?? arabicName;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}


