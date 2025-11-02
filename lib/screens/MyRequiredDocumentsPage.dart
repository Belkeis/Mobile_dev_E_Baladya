import 'package:flutter/material.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'online_request_page.dart'; // Add this import

class MyRequiredDocumentsPage extends StatelessWidget {
  const MyRequiredDocumentsPage({super.key});

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
        title: 'الوثائق المطلوبة',
        subtitle:
            'تعرّف على الوثائق المطلوبة لإتمام مختلف \nالمعاملات الإدارية بسهولة.',
        showTrailingArrow: true,
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
      ),
    );
  }
}