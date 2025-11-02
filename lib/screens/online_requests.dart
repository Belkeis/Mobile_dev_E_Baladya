import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'passport_online_request.dart';
import 'id_card_online_request.dart';

class MyOnlineRequestsPage extends StatelessWidget {
  const MyOnlineRequestsPage({super.key});

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
        title: 'الطلبات الإلكترونية',
        subtitle:
            'اختر نوع الطلب وأكمل تأكيد معلوماتك \nلتقديمه إلكترونيًا بسهولة.',
        showTrailingArrow: true,
        items: [
          ListItem(
            title: 'بطاقة تعريف وطنية',
            icon: FontAwesomeIcons.idCard,
            iconColor: const Color.fromARGB(255, 3, 129, 255),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IdRequest(),
                ),
              );
            },
          ),
          ListItem(
            title: 'جواز سفر',
            icon: FontAwesomeIcons.passport,
            iconColor: const Color.fromARGB(255, 13, 168, 57),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const onlineRequestPassport(),
                ),
              );
            },
          ),
          ListItem(
            title: 'شهادة ميلاد',
            icon: FontAwesomeIcons.certificate,
            iconColor: const Color(0xFF9C27B0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const onlineRequestPassport(),
                ),
              );
            },
          ),
          ListItem(
            title: 'عقد زواج',
            icon: FontAwesomeIcons.heart,
            iconColor: const Color.fromARGB(255, 224, 60, 188),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const onlineRequestPassport(),
                ),
              );
            },
          ),
          ListItem(
            title: 'شهادة إقامة',
            icon: FontAwesomeIcons.home,
            iconColor: const Color.fromARGB(255, 223, 111, 26),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const onlineRequestPassport(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
