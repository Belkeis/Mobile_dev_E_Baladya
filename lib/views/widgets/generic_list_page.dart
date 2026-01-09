import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../i18n/app_localizations.dart';

class GenericListPage extends StatefulWidget {
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
  State<GenericListPage> createState() => _GenericListPageState();
}

class _GenericListPageState extends State<GenericListPage> {
  late TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ListItem> get _filteredItems {
    if (_query.trim().isEmpty) return widget.items;
    final q = _query.trim().toLowerCase();
    return widget.items.where((it) {
      final title = it.title.toLowerCase();
      final subtitle = it.subtitle?.toLowerCase() ?? '';
      return title.contains(q) || subtitle.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final localizations = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: widget.customAppBar,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              children: [
                // Header Section
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Cairo',
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Search bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          color: Color(0xFF6B7280), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            color: Color(0xFF111827),
                          ),
                          decoration: InputDecoration(
                            hintText: localizations.isArabic ? 'ابحث...' : 'Rechercher...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // List of items
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          key: Key('list_item_$index'),
                          onTap: item.onTap,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: item.icon != null
                              ? FaIcon(
                                  item.icon,
                                  color:
                                      item.iconColor ?? const Color(0xFF2563EB),
                                  size: 20,
                                )
                              : null,
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF111827),
                            ),
                          ),
                          subtitle: item.subtitle != null
                              ? Text(
                                  item.subtitle!,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xFF6B7280),
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              : null,
                          trailing: widget.showDownloadIcon
                              ? SizedBox(
                                  width: 65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: item.onTap,
                                        behavior: HitTestBehavior.opaque,
                                        child: const FaIcon(
                                          FontAwesomeIcons.filePdf,
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: item.onDownload,
                                        behavior: HitTestBehavior.opaque,
                                        child: const FaIcon(
                                          FontAwesomeIcons.download,
                                          color: Color(0xFF2563EB),
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : widget.showTrailingArrow
                                  ? const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Color(0xFF6B7280),
                                    )
                                  : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

  const ListItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onDownload,
  });
}
