import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'online_request_page.dart';

class MyOnlineRequestsPage extends StatelessWidget {
  const MyOnlineRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericListPage(
      // CUSTOM APP BAR
      customAppBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomAppBar(
            onNotificationTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification tapped!')),
              );
            },
            onProfileTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Profile tapped!')));
            },
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),

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
                builder: (context) => const onlineRequestPassport(),
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
    );
  }
}
