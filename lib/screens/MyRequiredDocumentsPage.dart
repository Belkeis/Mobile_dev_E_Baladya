import 'package:flutter/material.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';

class MyRequiredDocumentsPage extends StatelessWidget {
  const MyRequiredDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericListPage(
      title: 'الوثائق المطلوبة',
      subtitle:
          'تعرّف على الوثائق المطلوبة لإتمام مختلف \nالمعاملات الإدارية بسهولة.',
      showTrailingArrow: true,

      // CUSTOM APP BAR
      customAppBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Directionality(
          textDirection: TextDirection.ltr, // keep icons left-to-right
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

      items: const [
        ListItem(
          title: 'شهادة الميلاد',
          subtitle: 'الحصول على البطاقة الوطنية',
        ),
        ListItem(title: 'جواز السفر', subtitle: 'صالح حتى 2028'),
        ListItem(title: 'رخصة السياقة', subtitle: 'فئة B - 2026'),
        ListItem(title: 'شهادة الزواج', subtitle: '2020'),
        ListItem(title: 'شهادة الإقامة'),
      ],
    );
  }
}
