import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginSelected = false;
  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _isLoginSelected ? _buildLoginSection() : _buildSignUpSection(),
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
    );
  }

  // 🔹 HEADER
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
          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo_small.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.location_city,
                    color: Colors.white,
                    size: 32,
                  );
                },
              ),
            ),
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

  // 🔹 TAB BUTTONS
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

  // 🔹 LOGIN SECTION
  Widget _buildLoginSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
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
              label: 'الاسم',
              hintText: 'أدخل اسمك',
              controller: _emailController,
              iconData: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'كلمة المرور',
              hintText: 'أدخل كلمة المرور',
              controller: _passwordController,
            ),
            const SizedBox(height: 12),
            // Remember Me & Forgot Password
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
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0x19000000),
                ),
                child: const Text(
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
    );
  }

  // 🔹 SIGN UP SECTION
  Widget _buildSignUpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
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
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: 'رقم الهاتف',
              hintText: 'أدخل رقم هاتفك',
              controller: _phoneController,
              iconData: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: 'رقم البطاقة',
              hintText: 'أدخل رقم البطاقة',
              controller: _cardNumberController,
              iconData: Icons.credit_card_outlined,
            ),
            const SizedBox(height: 24),
            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0x19000000),
                ),
                child: const Text(
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
            // Already have account link
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
    );
  }

  // 🔹 FORM FIELD WITH CUTE GRAY ICONS
  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData iconData,
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
              // Icon Container (positioned on the left)
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
              // Text Field
              Expanded(
                child: TextField(
                  controller: controller,
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 PASSWORD FIELD WITH SHOW/HIDE
  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
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
              // Icon Container (positioned on the left)
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
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              // Text Field
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  obscureText: !_showPassword,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      child: Icon(
                        _showPassword
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
      ],
    );
  }

  void _createAccount() {
    if (_fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _cardNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'الرجاء ملء جميع الحقول',
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'جاري إنشاء الحساب...',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'الرجاء ملء جميع الحقول',
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'جاري تسجيل الدخول...',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
