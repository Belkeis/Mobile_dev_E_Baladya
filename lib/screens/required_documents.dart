import 'package:flutter/material.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'passport_requirement.dart';
import 'id_card_requirement.dart';

class MyRequiredDocumentsPage extends StatelessWidget {
  const MyRequiredDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        onArrowTap: () {
          // Navigate back or to home
          Navigator.pop(context);
        },
      ),
      body: GenericListPage(
        title: 'الوثائق المطلوبة',
        subtitle:
            'تعرّف على الوثائق المطلوبة لإتمام مختلف \nالمعاملات الإدارية بسهولة.',
        showTrailingArrow: true,
        items: [
          ListItem(
            title: 'بطاقة تعريف وطنية',
            subtitle: 'الحصول على البطاقة الوطنية',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IdRequirements(),
                ),
              );
            },
          ),
          ListItem(
            title: 'جواز السفر',
            subtitle: 'صالح حتى 2028',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequiredDocumentsPage(),
                ),
              );
            },
          ),
          ListItem(
            title: 'رخصة السياقة',
            subtitle: 'فئة B - 2026',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequiredDocumentsPage(),
                ),
              );
            },
          ),
          ListItem(
            title: 'شهادة الزواج',
            subtitle: '2020',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequiredDocumentsPage(),
                ),
              );
            },
          ),
          ListItem(
            title: 'شهادة الإقامة',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequiredDocumentsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
