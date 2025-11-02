import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenericListPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ListItem> items;
  final bool showDownloadIcon;
  final bool showTrailingArrow;
  final PreferredSizeWidget? customAppBar;

  const GenericListPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.showDownloadIcon = false,
    this.showTrailingArrow = true,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: customAppBar,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
          child: ListView(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Color(0xFF3F76ED),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 30),

              // Search bar
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 36,
                  width: 340,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade400, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFE5E7EB),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(bottom: 1),
                        hintText: 'ابحث...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // List of items
              ...items.map(
                (item) => Container(
                  height: 70,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFE5E7EB),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: item.icon != null
                        ? FaIcon(
                            item.icon,
                            color: item.iconColor ?? const Color(0xFF2563EB),
                          )
                        : null,
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          )
                        : null,
                    trailing: showDownloadIcon
                        ? SizedBox(
                            width: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.filePdf,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                FaIcon(
                                  FontAwesomeIcons.download,
                                  color: Color(0xFF4B5564),
                                  size: 18,
                                ),
                              ],
                            ),
                          )
                        : showTrailingArrow
                        ? const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  const ListItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
  });
}
