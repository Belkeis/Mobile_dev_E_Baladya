import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class IdRequest extends StatefulWidget {
  const IdRequest({Key? key}) : super(key: key);

  @override
  State<IdRequest> createState() => _State();
}

class _State extends State<IdRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    'بطاقة التعريف الوطنية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'تقدم بطلب الحصول على بطاقة التعريف أو تجديده\nبسهولة وسرعة من خلال هذه الصفحة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description,
                                color: Color(0xFF2563EB),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'الوثائق المطلوبة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildRequirement('جواز السفر منتهي الصلاحية'),
                              _buildRequirement(
                                'بطاقة التسجيل الفصلي سارية المفعول',
                              ),
                              _buildRequirement('استمارة طلب مملوءة وموقعة'),
                              _buildRequirement(
                                  'شهادة ميلاد خاصة أصلية ( 12S )'),
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إرسال الطلب بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00D26A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'طلب تجديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6, left: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
