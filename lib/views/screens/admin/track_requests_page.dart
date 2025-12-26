import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../i18n/app_localizations.dart';
import '../../widgets/custom_app_bar.dart';

class TrackRequestsPage extends StatefulWidget {
  const TrackRequestsPage({super.key});

  @override
  State<TrackRequestsPage> createState() => _TrackRequestsPageState();
}

class _TrackRequestsPageState extends State<TrackRequestsPage> {
  // Dummy data for requests
  final List<Map<String, dynamic>> _allRequests = [
    {
      'id': 'REQ-1001',
      'typeAr': 'شهادة إقامة',
      'typeFr': 'Certificat de Résidence',
      'citizenName': 'أحمد محمد',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'pending',
    },
    {
      'id': 'REQ-1002',
      'typeAr': 'شهادة ميلاد',
      'typeFr': 'Acte de Naissance',
      'citizenName': 'فاطمة علي',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'approved',
    },
    {
      'id': 'REQ-1003',
      'typeAr': 'عقد زواج',
      'typeFr': 'Acte de Mariage',
      'citizenName': 'خالد حسن',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'ready',
    },
    {
      'id': 'REQ-1004',
      'typeAr': 'رخصة تجارية',
      'typeFr': 'Licence Commerciale',
      'citizenName': 'نورة عبد الله',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'rejected',
    },
    {
      'id': 'REQ-1005',
      'typeAr': 'رخصة بناء',
      'typeFr': 'Permis de Construire',
      'citizenName': 'عمر خالد',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'pending',
    },
  ];

  // Filter variables
  String _statusFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _statusList = ['all', 'pending', 'approved', 'ready', 'rejected'];

  // Get filtered requests based on filters
  List<Map<String, dynamic>> get _filteredRequests {
    return _allRequests.where((request) {
      final matchesStatus =
          _statusFilter == 'all' || request['status'] == _statusFilter;
      final searchTerm = _searchController.text.toLowerCase();
      final typeText =
          ((AppLocalizations.of(context)?.isArabic ?? true) ? request['typeAr'] : request['typeFr'])
              .toString()
              .toLowerCase();
      final matchesSearch = searchTerm.isEmpty ||
          request['id'].toLowerCase().contains(searchTerm) ||
          typeText.contains(searchTerm) ||
          request['citizenName'].toLowerCase().contains(searchTerm);
      
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ready':
        return const Color(0xFF059669);
      case 'approved':
        return const Color(0xFF2563EB);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'rejected':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  ({
    IconData icon,
    Color iconColor,
    Color iconBgColor,
    Color pillBgColor,
    Color pillTextColor,
  }) _statusUi(String status) {
    switch (status) {
      case 'pending':
        return (
          icon: Icons.pending,
          iconColor: const Color(0xFFF59E0B),
          iconBgColor: const Color(0xFFFEF3C7),
          pillBgColor: const Color(0xFFFEF3C7),
          pillTextColor: const Color(0xFF92400E),
        );
      case 'approved':
        return (
          icon: Icons.check_circle,
          iconColor: const Color(0xFF2563EB),
          iconBgColor: const Color(0xFFDBEAFE),
          pillBgColor: const Color(0xFFDBEAFE),
          pillTextColor: const Color(0xFF1E40AF),
        );
      case 'ready':
        return (
          icon: Icons.done_all,
          iconColor: const Color(0xFF059669),
          iconBgColor: const Color(0xFFD1FAE5),
          pillBgColor: const Color(0xFFD1FAE5),
          pillTextColor: const Color(0xFF065F46),
        );
      case 'rejected':
        return (
          icon: Icons.cancel,
          iconColor: const Color(0xFFDC2626),
          iconBgColor: const Color(0xFFFEE2E2),
          pillBgColor: const Color(0xFFFEE2E2),
          pillTextColor: const Color(0xFF991B1B),
        );
      default:
        return (
          icon: Icons.info,
          iconColor: const Color(0xFF6B7280),
          iconBgColor: const Color(0xFFF3F4F6),
          pillBgColor: const Color(0xFFF3F4F6),
          pillTextColor: const Color(0xFF6B7280),
        );
    }
  }

  String _statusText(BuildContext context, String status) {
    final localizations = AppLocalizations.of(context)!;
    switch (status) {
      case 'pending':
        return localizations.pending;
      case 'approved':
        return localizations.approved;
      case 'ready':
        return localizations.ready;
      case 'rejected':
        return localizations.rejected;
      default:
        return status;
    }
  }

  // Show update status dialog
  void _showUpdateStatusDialog(Map<String, dynamic> request) {
    String? newStatus = request['status'] as String?;
    final localizations = AppLocalizations.of(context)!;
    final requestType = localizations.isArabic
        ? request['typeAr'] as String
        : request['typeFr'] as String;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          textDirection:
              localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Expanded(
              child: Text(
                localizations.translate('update_status_dialog_title'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign:
                    localizations.isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 20,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        actionsAlignment:
            localizations.isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection:
                localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection:
                      localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Text(
                      requestType,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF111827)),
                      textDirection:
                          localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                      textAlign:
                          localizations.isArabic ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${localizations.translate('current_status')}: ${_statusText(context, request['status'] as String)}',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: Color(0xFF6B7280)),
                      textDirection:
                          localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                      textAlign:
                          localizations.isArabic ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localizations.translate('new_status'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: newStatus,
                isDense: true,
                isExpanded: true,
                menuMaxHeight: 320,
                borderRadius: BorderRadius.circular(16),
                elevation: 4,
                items: _statusList.where((s) => s != 'all').map((status) {
                  final color = _getStatusColor(status);

                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection:
                          localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _statusText(context, status),
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (context) {
                  return _statusList.where((s) => s != 'all').map((status) {
                    final color = _getStatusColor(status);

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection:
                          localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _statusText(context, status),
                            style: const TextStyle(fontFamily: 'Cairo'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                onChanged: (value) {
                  newStatus = value;
                },
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: localizations.isArabic
            ? [
                ElevatedButton(
                  onPressed: () {
                    if (newStatus != null) {
                      setState(() {
                        request['status'] = newStatus;
                      });
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${localizations.translate('status_updated')}: ${_statusText(context, newStatus!)}',
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.translate('update_upper'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    localizations.translate('cancel_upper'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ]
            : [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    localizations.translate('cancel_upper'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newStatus != null) {
                      setState(() {
                        request['status'] = newStatus;
                      });
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${localizations.translate('status_updated')}: ${_statusText(context, newStatus!)}',
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.translate('update_upper'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;
    
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: CustomAppBar(
          title: localizations.translate('track_requests'),
          onArrowTap: () => Navigator.pop(context),
          onProfileTap: () {
            Navigator.pushNamed(context, '/admin/profile');
          },
          onNotificationTap: () {
            Navigator.pushNamed(context, '/admin/notifications');
          },
        ),
        body: Column(
          children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  decoration: InputDecoration(
                    hintText: localizations.translate('search_requests'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                
                const SizedBox(height: 12),
                
                // Filters row
                Align(
                  alignment:
                      isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(_statusFilter)
                              .withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getStatusColor(_statusFilter),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.filter_list_rounded,
                            size: 18,
                            color: _getStatusColor(_statusFilter),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _statusFilter,
                                isDense: true,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(16),
                                elevation: 4,
                                dropdownColor: Colors.white,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                  color: Color(0xFF6B7280),
                                ),
                                items: _statusList.map((status) {
                                  final statusColor = _getStatusColor(status);
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Row(
                                      textDirection: isArabic
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            status == 'all'
                                                ? localizations.translate('all')
                                                : _statusText(context, status),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cairo',
                                            ),
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            textAlign: isArabic
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _statusFilter = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Request list
          Expanded(
            child: _filteredRequests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.translate('no_requests_found'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = _filteredRequests[index];
                      final requestType = isArabic
                          ? request['typeAr'] as String
                          : request['typeFr'] as String;
                      final statusText = _statusText(context, request['status']);
                      final statusUi = _statusUi(request['status']);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            _showRequestDetails(context, request);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                            child: Row(
                              textDirection:
                                  isArabic ? TextDirection.rtl : TextDirection.ltr,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: statusUi.iconBgColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    statusUi.icon,
                                    color: statusUi.iconColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    textDirection:
                                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        requestType,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF111827),
                                        ),
                                        textDirection:
                                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                                        textAlign:
                                            isArabic ? TextAlign.right : TextAlign.left,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        textDirection: isArabic
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${localizations.translate('status')}:',
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 14,
                                              color: Color(0xFF6B7280),
                                            ),
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusUi.pillBgColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: statusUi.pillTextColor,
                                              ),
                                              textDirection: isArabic
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '${localizations.translate('citizen_name')}: ${request['citizenName']}',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                        textDirection:
                                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                                        textAlign:
                                            isArabic ? TextAlign.right : TextAlign.left,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        textDirection:
                                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                _showUpdateStatusDialog(request),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF2563EB),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              textStyle: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            child: Text(
                                              localizations.translate('update_status'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${localizations.translate('submitted')} ${_formatDate(request['date'] as DateTime, context)}',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                                color: Color(0xFF6B7280),
                                              ),
                                              textDirection: isArabic
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              textAlign: isArabic
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
);
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    final localizations = AppLocalizations.of(context)!;
    final requestType = localizations.isArabic
        ? request['typeAr'] as String
        : request['typeFr'] as String;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 24),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          textDirection:
              localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Expanded(
              child: Text(
                localizations.translate('request_details'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
                textAlign:
                    localizations.isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_rounded,
                size: 18,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        actionsAlignment:
            localizations.isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              textDirection:
                  localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  context,
                  Icons.description,
                  localizations.translate('request_type'),
                  requestType,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  Icons.person_outline,
                  localizations.translate('citizen_name'),
                  request['citizenName'] as String,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  Icons.calendar_today,
                  localizations.translate('submission_date'),
                  _formatDate(request['date'] as DateTime, context),
                ),
                const SizedBox(height: 12),
                _buildStatusDetailRow(
                  context,
                  Icons.flag,
                  localizations.translate('status'),
                  _statusText(context, request['status'] as String),
                  _getStatusColor(request['status'] as String),
                ),
              ],
            ),
          ),
        ),
        actions: localizations.isArabic
            ? [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showUpdateStatusDialog(request);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.translate('update_status'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    localizations.close,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ]
            : [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    localizations.close,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showUpdateStatusDialog(request);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.translate('update_status'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isArabic = AppLocalizations.of(context)?.isArabic ?? true;

    Color iconColor;
    Color iconBgColor;
    if (icon == Icons.person_outline) {
      iconColor = const Color(0xFF4F46E5);
      iconBgColor = const Color(0xFFE0E7FF);
    } else if (icon == Icons.calendar_today) {
      iconColor = const Color(0xFFF59E0B);
      iconBgColor = const Color(0xFFFEF3C7);
    } else {
      iconColor = const Color(0xFF2563EB);
      iconBgColor = const Color(0xFFDBEAFE);
    }

    return Row(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final isArabic = AppLocalizations.of(context)?.isArabic ?? true;

    return Row(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _toWesternDigits(String input) {
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const easternArabicIndic = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var out = input;
    for (var i = 0; i < 10; i++) {
      out = out.replaceAll(arabicIndic[i], i.toString());
      out = out.replaceAll(easternArabicIndic[i], i.toString());
    }
    return out;
  }

  String _formatDate(DateTime date, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = localizations.isArabic ? 'ar' : 'fr';
    final pattern = localizations.isArabic
        ? 'HH:mm - yyyy/MM/dd'
        : 'yyyy/MM/dd - HH:mm';
    return _toWesternDigits(intl.DateFormat(pattern, locale).format(date));
  }
}
