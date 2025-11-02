import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class IdRequirements extends StatelessWidget {
  const IdRequirements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              'بطاقة التعريف الوطنية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
              textAlign: TextAlign.center,
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
                          Icons.description_outlined,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSection('في شهادة الميلاد وعقد الزواج :'),
                        _buildDocItem('شهادة ميلاد للمعني'),
                        _buildDocItem('شهادة ميلاد الأب'),
                        _buildDocItem('شهادة ميلاد الأم'),
                        _buildDocItem('عقد الزواج للأبوين'),
                        _buildDocItem('شهادة عائلية .'),
                        _buildDocItem(
                          'طلب مصادق عليه (يسلم من مكتب الأرشيف )',
                        ),
                        SizedBox(height: 24),
                        _buildSection('في شهادة الوفاة :'),
                        _buildDocItem(
                          'نشر الملف المطلوب في تصحيح شهادة الميلاد',
                        ),
                        _buildDocItem('شهادة الوفاة'),
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
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildDocItem(String text) {
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
