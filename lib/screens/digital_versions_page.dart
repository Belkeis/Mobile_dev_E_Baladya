import 'package:flutter/material.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';

class DigitalVersionsPage extends StatelessWidget {
  const DigitalVersionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: GenericListPage(
        //  Custom App Bar
        customAppBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: Directionality(
            textDirection: TextDirection.ltr, // keep icons LTR
            child: CustomAppBar(
              onProfileTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('الملف الشخصي')));
              },
              onNotificationTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('الإشعارات')));
              },
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        title: 'الوثائق الرقمية',
        subtitle:
            'الوصول إلى جميع الوثائق الرسمية الرقمية بسهولة\nوتنزيلها مباشرة من هذه الصفحة.',
        showDownloadIcon: true,
        showTrailingArrow: false,

        items: const [
          ListItem(title: 'شهادة الميلاد', subtitle: 'نسخة 2024'),
          ListItem(title: 'جواز السفر', subtitle: 'صالح حتى 2028'),
          ListItem(title: 'رخصة السياقة', subtitle: 'فئة B - 2026'),
          ListItem(title: 'شهادة الزواج', subtitle: '2020'),
          ListItem(title: 'شهادة الإقامة'),
        ],
      ),
    );
  }
}
