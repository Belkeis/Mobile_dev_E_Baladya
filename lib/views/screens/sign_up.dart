import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/user_model.dart';
import '../../i18n/app_localizations.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // For login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Form keys
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _isLoginSelected = true;
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _showLoginPassword = false;

  // Validators
  String? _emailValidator(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty)
      return localizations.pleaseEnterEmail;
    final email = value.trim();
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return localizations.pleaseEnterValidEmail;
    return null;
  }

  String? _phoneValidator(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) return localizations.pleaseEnterPhone;
    final phone = value.trim();
    final regex = RegExp(r'^(05|06|07)\d{8}$');
    if (!regex.hasMatch(phone)) return localizations.pleaseEnterValidPhone;
    return null;
  }

  String? _passwordValidator(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return localizations.pleaseEnterPassword;
    if (value.length < 6) return localizations.passwordMinLength;
    return null;
  }

  String? _nationalIdValidator(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty)
      return localizations.pleaseEnterNationalId;
    final s = value.trim();
    final regex = RegExp(r'^\d{18}$');
    if (!regex.hasMatch(s)) return localizations.nationalIdLength;
    return null;
  }

  // External field errors to show outside inputs
  final Map<String, String?> _fieldErrors = {};

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFE5E7EB),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
                  ),
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildTabButtons(),
                    const SizedBox(height: 20),
                    _isLoginSelected
                        ? _buildLoginSection()
                        : _buildSignUpSection(),
                    const SizedBox(height: 24),
                    Text(
                      localizations.allRightsReserved,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xFF9CA3AF),
                        fontSize: 11,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [
          // SVG Logo
          SvgPicture.asset(
            'assets/images/logo_blue.svg',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            isArabic ? 'مرحبا بكم في e-Baladya' : 'Bienvenue dans e-Baladya',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isArabic ? const Color(0xFF1F2937) : Colors.black,
              fontSize: 20,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            AppLocalizations.of(context)!.systemTitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoginSelected = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _isLoginSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      localizations.login,
                      style: TextStyle(
                        color: _isLoginSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoginSelected = false;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: !_isLoginSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      localizations.signUp,
                      style: TextStyle(
                        color: !_isLoginSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final localizations = AppLocalizations.of(context)!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _loginFormKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF1F2937),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.loginSubtitle,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    controller: _loginEmailController,
                    iconData: Icons.email_outlined,
                    validator: (v) => _emailValidator(v, context),
                    fieldKey: 'loginEmail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: AppLocalizations.of(context)!.password,
                    hintText: AppLocalizations.of(context)!.enterPassword,
                    controller: _loginPasswordController,
                    showPassword: _showLoginPassword,
                    onToggle: () {
                      setState(() {
                        _showLoginPassword = !_showLoginPassword;
                      });
                    },
                    validator: (v) => _passwordValidator(v, context),
                    fieldKey: 'loginPassword',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.rememberMe,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0x19000000),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.login,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpSection() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _signupFormKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF1F2937),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.createAccountSubtitle,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: AppLocalizations.of(context)!.fullName,
                    hintText: AppLocalizations.of(context)!.enterFullName,
                    controller: _fullNameController,
                    iconData: Icons.person_outline_rounded,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? AppLocalizations.of(context)!.pleaseEnterName
                        : null,
                    fieldKey: 'fullName',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    controller: _emailController,
                    iconData: Icons.email_outlined,
                    validator: (v) => _emailValidator(v, context),
                    fieldKey: 'email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: AppLocalizations.of(context)!.phone,
                    hintText: AppLocalizations.of(context)!.enterPhone,
                    controller: _phoneController,
                    iconData: Icons.phone_outlined,
                    validator: (v) => _phoneValidator(v, context),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    fieldKey: 'phone',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: AppLocalizations.of(context)!.nationalId,
                    hintText: AppLocalizations.of(context)!.enterNationalId,
                    controller: _nationalIdController,
                    iconData: Icons.credit_card_outlined,
                    validator: (v) => _nationalIdValidator(v, context),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    keyboardType: TextInputType.number,
                    fieldKey: 'nationalId',
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: AppLocalizations.of(context)!.password,
                    hintText: AppLocalizations.of(context)!.enterPassword,
                    controller: _passwordController,
                    showPassword: _showPassword,
                    onToggle: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    validator: (v) => _passwordValidator(v, context),
                    fieldKey: 'password',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0x19000000),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.createAccount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoginSelected = true;
                      });
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.alreadyHaveAccount,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 13,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData iconData,
    String fieldKey = '',
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isArabic ? 4 : 0,
            left: isArabic ? 0 : 4,
            bottom: 8,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xFF374151),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    right: isArabic ? const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ) : BorderSide.none,
                    left: isArabic ? BorderSide.none : const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    size: 18,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: null,
                  keyboardType: keyboardType ?? TextInputType.text,
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    counterText: '',
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFFADAEBC),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (fieldKey.isNotEmpty && _fieldErrors[fieldKey] != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(
              right: isArabic ? 4 : 0,
              left: isArabic ? 0 : 4,
            ),
            child: Text(
              _fieldErrors[fieldKey]!,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool showPassword,
    required VoidCallback onToggle,
    String fieldKey = '',
    String? Function(String?)? validator,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isArabic ? 4 : 0,
            left: isArabic ? 0 : 4,
            bottom: 8,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xFF374151),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    right: isArabic ? const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ) : BorderSide.none,
                    left: isArabic ? BorderSide.none : const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: null,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  obscureText: !showPassword,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    counterText: '',
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFFADAEBC),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    suffixIcon: isArabic ? GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ) : null,
                    prefixIcon: !isArabic ? GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ) : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (fieldKey.isNotEmpty && _fieldErrors[fieldKey] != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(
              right: isArabic ? 4 : 0,
              left: isArabic ? 0 : 4,
            ),
            child: Text(
              _fieldErrors[fieldKey]!,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _createAccount() {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    _fieldErrors.clear();
    _fieldErrors['fullName'] =
        _fullNameController.text.trim().isEmpty ? localizations.pleaseEnterName : null;
    _fieldErrors['email'] = _emailValidator(_emailController.text, context);
    _fieldErrors['phone'] = _phoneValidator(_phoneController.text, context);
    _fieldErrors['nationalId'] =
        _nationalIdValidator(_nationalIdController.text, context);
    _fieldErrors['password'] = _passwordValidator(_passwordController.text, context);
    setState(() {});

    final hasError = _fieldErrors.values.any((e) => e != null);
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.pleaseFillAllFieldsCorrectly,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final user = UserModel(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      nationalId: _nationalIdController.text,
      password: _passwordController.text,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<AuthCubit>().register(user);
  }

  void _login() {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    _fieldErrors.clear();
    _fieldErrors['loginEmail'] = _emailValidator(_loginEmailController.text, context);
    _fieldErrors['loginPassword'] =
        _passwordValidator(_loginPasswordController.text, context);
    setState(() {});

    final hasError = _fieldErrors.values.any((e) => e != null);
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.pleaseFillAllInfo,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    context.read<AuthCubit>().login(
          _loginEmailController.text,
          _loginPasswordController.text,
        );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }
}
