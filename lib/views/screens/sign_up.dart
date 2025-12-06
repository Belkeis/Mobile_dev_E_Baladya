import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/user_model.dart';
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
  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'الرجاء إدخال البريد الإلكتروني';
    final email = value.trim();
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'الرجاء إدخال بريد إلكتروني صحيح';
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'الرجاء إدخال رقم الهاتف';
    final phone = value.trim();
    final regex = RegExp(r'^(05|06|07)\d{8}$');
    if (!regex.hasMatch(phone)) return 'الرجاء إدخال رقم هاتف  صحيح';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  String? _nationalIdValidator(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'الرجاء إدخال رقم البطاقة';
    final s = value.trim();
    final regex = RegExp(r'^\d{18}$');
    if (!regex.hasMatch(s)) return 'رقم البطاقة يجب أن يتكون من 18 رقماً';
    return null;
  }

  // External field errors to show outside inputs
  final Map<String, String?> _fieldErrors = {};

  @override
  Widget build(BuildContext context) {
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
                textAlign: TextAlign.right,
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
                  const Text(
                    'جميع الحقوق محفوظة © 2024 البلدية\nالإلكترونية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
    );
  }

  Widget _buildHeader() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'e-Baladya',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                ' مرحبا بكم في',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'نظام إدارة الخدمات البلدية',
            style: TextStyle(
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
                      'تسجيل الدخول',
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
                      'إنشاء حساب',
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
                  const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF1F2937),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'أدخل بياناتك للوصول إلى حسابك',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'البريد الإلكتروني',
                    hintText: 'أدخل بريدك الإلكتروني',
                    controller: _loginEmailController,
                    iconData: Icons.email_outlined,
                    validator: _emailValidator,
                    fieldKey: 'loginEmail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'كلمة المرور',
                    hintText: 'أدخل كلمة المرور',
                    controller: _loginPasswordController,
                    showPassword: _showLoginPassword,
                    onToggle: () {
                      setState(() {
                        _showLoginPassword = !_showLoginPassword;
                      });
                    },
                    validator: _passwordValidator,
                    fieldKey: 'loginPassword',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'تذكرني',
                            style: TextStyle(
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
                          : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
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
                  const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF1F2937),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'أنشئ حسابك للبدء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'الاسم الكامل',
                    hintText: 'أدخل اسمك الكامل',
                    controller: _fullNameController,
                    iconData: Icons.person_outline_rounded,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'الرجاء إدخال الاسم'
                        : null,
                    fieldKey: 'fullName',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'البريد الإلكتروني',
                    hintText: 'أدخل بريدك الإلكتروني',
                    controller: _emailController,
                    iconData: Icons.email_outlined,
                    validator: _emailValidator,
                    fieldKey: 'email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'رقم الهاتف',
                    hintText: 'أدخل رقم هاتفك',
                    controller: _phoneController,
                    iconData: Icons.phone_outlined,
                    validator: _phoneValidator,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    fieldKey: 'phone',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'رقم البطاقة الوطنية',
                    hintText: 'أدخل رقم البطاقة',
                    controller: _nationalIdController,
                    iconData: Icons.credit_card_outlined,
                    validator: _nationalIdValidator,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    keyboardType: TextInputType.number,
                    fieldKey: 'nationalId',
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'كلمة المرور',
                    hintText: 'أدخل كلمة المرور',
                    controller: _passwordController,
                    showPassword: _showPassword,
                    onToggle: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    validator: _passwordValidator,
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
                          : const Text(
                              'إنشاء الحساب',
                              style: TextStyle(
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
                        children: const [
                          TextSpan(
                            text: 'لديك حساب بالفعل؟ ',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'تسجيل الدخول',
                            style: TextStyle(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
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
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
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
                  textAlign: TextAlign.right,
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
            padding: EdgeInsets.only(right: 4),
            child: Text(
              _fieldErrors[fieldKey]!,
              textAlign: TextAlign.right,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
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
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
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
                  textAlign: TextAlign.right,
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
                    suffixIcon: GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (fieldKey.isNotEmpty && _fieldErrors[fieldKey] != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              _fieldErrors[fieldKey]!,
              textAlign: TextAlign.right,
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
    _fieldErrors.clear();
    _fieldErrors['fullName'] =
        _fullNameController.text.trim().isEmpty ? 'الرجاء إدخال الاسم' : null;
    _fieldErrors['email'] = _emailValidator(_emailController.text);
    _fieldErrors['phone'] = _phoneValidator(_phoneController.text);
    _fieldErrors['nationalId'] =
        _nationalIdValidator(_nationalIdController.text);
    _fieldErrors['password'] = _passwordValidator(_passwordController.text);
    setState(() {});

    final hasError = _fieldErrors.values.any((e) => e != null);
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'الرجاء ملء جميع الحقول بشكل صحيح',
            textAlign: TextAlign.right,
            style: TextStyle(
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
    _fieldErrors.clear();
    _fieldErrors['loginEmail'] = _emailValidator(_loginEmailController.text);
    _fieldErrors['loginPassword'] =
        _passwordValidator(_loginPasswordController.text);
    setState(() {});

    final hasError = _fieldErrors.values.any((e) => e != null);
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'الرجاء ملء جميع المعلومات بشكل صحيح',
            textAlign: TextAlign.right,
            style: TextStyle(
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
