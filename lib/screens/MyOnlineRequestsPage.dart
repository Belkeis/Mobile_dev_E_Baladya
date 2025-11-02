import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'required_doc_passport.dart';

class MyOnlineRequestsPage extends StatelessWidget {
  const MyOnlineRequestsPage({super.key});

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
        title: 'الطلبات الإلكترونية',
        subtitle:
            'اختر نوع الطلب وأكمل تأكيد معلوماتك \nلتقديمه إلكترونيًا بسهولة.',
        showTrailingArrow: true,
        items: const [
          ListItem(
            title: 'بطاقة تعريف وطنية',
            icon: FontAwesomeIcons.idCard,
            iconColor: Color.fromARGB(255, 3, 129, 255),
          ),
          ListItem(
            title: 'جواز سفر',
            icon: FontAwesomeIcons.passport,
            iconColor: Color.fromARGB(255, 13, 168, 57),
          ),
          ListItem(
            title: 'شهادة ميلاد',
            icon: FontAwesomeIcons.certificate,
            iconColor: Color(0xFF9C27B0),
          ),
          ListItem(
            title: 'عقد زواج',
            icon: FontAwesomeIcons.heart,
            iconColor: Color.fromARGB(255, 224, 60, 188),
          ),
          ListItem(
            title: 'شهادة إقامة',
            icon: FontAwesomeIcons.home,
            iconColor: Color.fromARGB(255, 223, 111, 26),
          ),
        ],
      ),
    );
  }
}