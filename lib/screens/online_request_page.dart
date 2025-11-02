import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'after_req.dart';

class OnlineRequestPage extends StatefulWidget {
  const OnlineRequestPage({Key? key}) : super(key: key);

  @override
  State<OnlineRequestPage> createState() => _OnlineRequestPageState();
}

class _OnlineRequestPageState extends State<OnlineRequestPage> {
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "تأكيد البيانات الشخصية",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "يرجى مراجعة معلوماتك لتأكيد هويتك واستكمال الطلب بسهولة.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _InfoRow("الاسم الكامل:", "أحمد بن يوسف"),
                      _InfoRow("تاريخ الميلاد:", "15/06/2000"),
                      _InfoRow("العنوان:", "ولاية الجزائر، بلدية باب الزوار"),
                      _InfoRow("رقم الهاتف:", "0555 12 34 56"),
                      _InfoRow("البريد الإلكتروني:", "ahmed.benyoussef@email.com"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        text: "إلغاء",
                        textColor: Colors.black87,
                        background: Colors.white,
                        shadow: true,
                        isConfirm: false,
                      ),
                      SizedBox(width: 16),
                      _ActionButton(
                        text: "تأكيد المعلومات",
                        textColor: Colors.white,
                        background: Color(0xFF2563EB),
                        isConfirm: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications tapped')),
          );
        },
        onProfileTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile tapped')),
          );
        },
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: const [
                  Text(
                    'جواز السفر',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'تقدم بطلب الحصول على جواز السفر أو تجديده\nبسهولة وسرعة من خلال هذه الصفحة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.description, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text(
                            'الوثائق المطلوبة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildRequirement('جواز السفر منتهي الصلاحية'),
                          _buildRequirement('بطاقة التسجيل الفصلي سارية المفعول'),
                          _buildRequirement('استمارة طلب مملوءة وموقعة'),
                          _buildRequirement('شهادة ميلاد خاصة أصلية ( 12S )'),
                          _buildRequirement('إثبات الإقامة القانونية في الجزائر'),
                          _buildRequirement('أربع صور فوتوغرافية حديثة بحجم 35 × 45 مم'),
                          _buildRequirement('نسخة من بطاقة التعريف الوطنية'),
                          _buildRequirement('إيصال دفع رسوم الجواز (حوالي 6000 دج)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D26A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'طلب تجديد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, left: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color background;
  final bool isConfirm;
  final bool shadow;

  const _ActionButton({
    required this.text,
    required this.textColor,
    required this.background,
    required this.isConfirm,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (isConfirm) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AfterReq()),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}





























/*import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class OnlineRequestPage extends StatefulWidget {
  const OnlineRequestPage({Key? key}) : super(key: key);

  @override
  State<OnlineRequestPage> createState() => _OnlineRequestPageState();
}

class _OnlineRequestPageState extends State<OnlineRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        onNotificationTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Notifications tapped')));
        },
        onProfileTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Profile tapped')));
        },
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text(
                    'جواز السفر',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تقدم بطلب الحصول على جواز السفر أو تجديده\nبسهولة وسرعة من خلال هذه الصفحة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.description, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text(
                            'الوثائق المطلوبة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildRequirement('جواز السفر منتهي الصلاحية'),
                          _buildRequirement(
                            'بطاقة التسجيل الفصلي سارية المفعول',
                          ),
                          _buildRequirement('استمارة طلب مملوءة وموقعة'),
                          _buildRequirement('شهادة ميلاد خاصة أصلية ( 12S )'),
                          _buildRequirement(
                            'إثبات الإقامة القانونية في الجزائر (حال شهادة\nالعمل أو بطاقة الطالب)',
                          ),
                          _buildRequirement(
                            'أربع صور فوتوغرافية حديثة بحجم 35 × 45 مم',
                          ),
                          _buildRequirement(
                            'نسخة من بطاقة التعريف الوطنية (إذا كانت\nمتوفرة)',
                          ),
                          _buildRequirement(
                            'إيصال دفع رسوم الجواز (حوالي 6000 دج)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال الطلب بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D26A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'طلب تجديد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, left: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
