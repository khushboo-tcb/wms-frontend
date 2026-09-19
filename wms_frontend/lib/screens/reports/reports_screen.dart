import 'package:flutter/material.dart';
import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ============================================================
  // REPORT FILTERS
  // ============================================================

  String selectedReport = 'Inventory Report';
  String selectedWarehouse = 'All Warehouses';
  String selectedStatus = 'All Status';

  DateTime? fromDate;
  DateTime? toDate;

  bool reportGenerated = false;

  // ============================================================
  // LOGOUT
  // ============================================================

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate({
    required bool isFromDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  // ============================================================
  // GENERATE REPORT
  // ============================================================

  void _generateReport() {
    setState(() {
      reportGenerated = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report generated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  void _clearFilters() {
    setState(() {
      selectedReport = 'Inventory Report';
      selectedWarehouse = 'All Warehouses';
      selectedStatus = 'All Status';
      fromDate = null;
      toDate = null;
      reportGenerated = false;
    });
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select Date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Row(
        children: [
          // =====================================================
          // SIDEBAR
          // =====================================================

          Container(
            width: 235,
            color: const Color(0xFF111827),
            child: Column(
              children: [
                // ================= WMS LOGO =================

                Container(
                  height: 88,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.warehouse,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 11),
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WMS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Warehouse Management',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(
                  color: Colors.white12,
                ),

                // ================= MENU =================

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    children: [
                      _menuItem(
                        Icons.dashboard_outlined,
                        'Dashboard',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.inventory_2_outlined,
                        'Inventory',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.download_outlined,
                        'Inbound',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.upload_outlined,
                        'Outbound',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.warehouse_outlined,
                        'Warehouse',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.bar_chart_outlined,
                        'Reports',
                        true,
                        context,
                      ),

                      const SizedBox(height: 10),

                      const Divider(
                        color: Colors.white12,
                      ),

                      const SizedBox(height: 10),

                      _menuItem(
                        Icons.notifications_none,
                        'Notifications',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.settings_outlined,
                        'Settings',
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.person_outline,
                        'Profile',
                        false,
                        context,
                      ),
                    ],
                  ),
                ),

                // ================= LOGOUT =================

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: _menuItem(
                    Icons.logout,
                    'Logout',
                    false,
                    context,
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // MAIN CONTENT
          // =====================================================

          Expanded(
            child: Column(
              children: [
                // =================================================
                // TOP BAR
                // =================================================

                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Reports',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const Spacer(),

                      // ================= SEARCH =================

                      Container(
                        width: 270,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 19,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(top: 9),
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      // ================= NOTIFICATION =================

                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 24,
                            ),
                          ),

                          Positioned(
                            right: 5,
                            top: 4,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration:
                                  const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      const CircleAvatar(
                        radius: 18,
                        child: Icon(
                          Icons.person,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 9),

                      const Text(
                        'Administrator',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                // =================================================
                // CONTENT
                // =================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Generate and view warehouse management reports.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =================================================
                        // REPORT FILTER PANEL
                        // =================================================

                        _panel(
                          title: 'Report Filters',
                          action: 'Reset',
                          onAction: _clearFilters,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),

                              Row(
                                children: [
                                  Expanded(
                                    child: _dropdownField(
                                      label: 'Report Type',
                                      value: selectedReport,
                                      items: const [
                                        'Inventory Report',
                                        'Stock Movement Report',
                                        'Inbound Report',
                                        'Outbound Report',
                                        'Warehouse Utilization Report',
                                        'Low Stock Report',
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedReport =
                                                value;
                                          });
                                        }
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: _dropdownField(
                                      label: 'Warehouse',
                                      value:
                                          selectedWarehouse,
                                      items: const [
                                        'All Warehouses',
                                        'Main Warehouse',
                                        'Raw Material Warehouse',
                                        'Finished Goods Warehouse',
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedWarehouse =
                                                value;
                                          });
                                        }
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: _dropdownField(
                                      label: 'Status',
                                      value: selectedStatus,
                                      items: const [
                                        'All Status',
                                        'Active',
                                        'Completed',
                                        'Pending',
                                        'Cancelled',
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedStatus =
                                                value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _dateField(
                                      label: 'From Date',
                                      value:
                                          _formatDate(fromDate),
                                      onTap: () {
                                        _selectDate(
                                          isFromDate: true,
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: _dateField(
                                      label: 'To Date',
                                      value:
                                          _formatDate(toDate),
                                      onTap: () {
                                        _selectDate(
                                          isFromDate: false,
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: _textField(
                                      label: 'Item',
                                      hint:
                                          'Search item...',
                                      icon: Icons
                                          .inventory_2_outlined,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _clearFilters,
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 17,
                                    ),
                                    label: const Text(
                                      'Clear',
                                    ),
                                    style:
                                        OutlinedButton.styleFrom(
                                      foregroundColor:
                                          const Color(
                                              0xFF374151),
                                      side: const BorderSide(
                                        color:
                                            Color(0xFFE5E7EB),
                                      ),
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  ElevatedButton.icon(
                                    onPressed:
                                        _generateReport,
                                    icon: const Icon(
                                      Icons.assessment_outlined,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Generate Report',
                                    ),
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(
                                              0xFF2563EB),
                                      foregroundColor:
                                          Colors.white,
                                      elevation: 0,
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =================================================
                        // REPORT RESULT
                        // =================================================

                        _reportResult(),

                        const SizedBox(height: 20),

                        // =================================================
                        // REPORT INFORMATION
                        // =================================================

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _quickReportCard(
                                icon: Icons.inventory_2_outlined,
                                title: 'Inventory Report',
                                description:
                                    'View current stock, available quantity and item-wise inventory.',
                                value: '1,250 Items',
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _quickReportCard(
                                icon: Icons.swap_horiz,
                                title: 'Stock Movement',
                                description:
                                    'Track stock received, dispatched and transferred between warehouses.',
                                value: '165 Movements',
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _quickReportCard(
                                icon: Icons.warehouse_outlined,
                                title: 'Warehouse Report',
                                description:
                                    'View warehouse capacity and storage utilization information.',
                                value: '72% Utilized',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR MENU
  // ============================================================

  Widget _menuItem(
    IconData icon,
    String title,
    bool selected,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF3B82F6)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,

        leading: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),

        onTap: () {
          // ================= LOGOUT =================

          if (title == 'Logout') {
            _logout(context);
          }

          // ================= DASHBOARD =================

          else if (title == 'Dashboard') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const DashboardScreen(),
              ),
            );
          }

          // ================= INVENTORY =================

          else if (title == 'Inventory') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InventoryScreen(),
              ),
            );
          }

          // ================= INBOUND =================

          else if (title == 'Inbound') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InboundScreen(),
              ),
            );
          }

          // ================= OUTBOUND =================

          else if (title == 'Outbound') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OutboundScreen(),
              ),
            );
          }

          // ================= WAREHOUSE =================

          else if (title == 'Warehouse') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const WarehouseScreen(),
              ),
            );
          }

          // ================= REPORTS =================

          else if (title == 'Reports') {
            // Already on Reports.
          }

          // ================= NOTIFICATIONS =================

          else if (title == 'Notifications') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NotificationScreen(),
              ),
            );
          }

          // ================= SETTINGS =================

          else if (title == 'Settings') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const SettingsScreen(),
              ),
            );
          }

          // ================= PROFILE =================

          else if (title == 'Profile') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProfileScreen(),
              ),
            );
          }

          // ================= OTHER MODULES =================

          else {
            // Other modules will be implemented later.
          }
        },
      ),
    );
  }

  // ============================================================
  // DROPDOWN FIELD
  // ============================================================

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(7),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 19,
              ),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF374151),
              ),
              items: items.map(
                (String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE FIELD
  // ============================================================

  Widget _dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 7),

        InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(7),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(7),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 17,
                  color: Color(0xFF6B7280),
                ),

                const SizedBox(width: 9),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 11,
                    color: value == 'Select Date'
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(7),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
              prefixIcon: Icon(
                icon,
                size: 17,
                color: Color(0xFF6B7280),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REPORT RESULT
  // ============================================================

  Widget _reportResult() {
    return _panel(
      title: 'Report Results',
      action: reportGenerated
          ? 'Generated'
          : 'Preview',
      child: Column(
        children: [
          const SizedBox(height: 14),

          // ================= REPORT HEADER =================

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius:
                  BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.assessment_outlined,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedReport,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        '$selectedWarehouse • $selectedStatus',
                        style: const TextStyle(
                          fontSize: 9,
                          color:
                              Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                if (reportGenerated)
                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFEAF8EF),
                      borderRadius:
                          BorderRadius.circular(
                              10),
                    ),
                    child: const Text(
                      'Generated',
                      style: TextStyle(
                        color:
                            Color(0xFF16A34A),
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ================= TABLE =================

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 42,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 54,
              columnSpacing: 28,
              headingRowColor:
                  WidgetStateProperty.all(
                const Color(0xFFF8FAFC),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Item',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Warehouse',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock In',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock Out',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Current Stock',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: [
                _reportRow(
                  'Product A',
                  'Main Warehouse',
                  '150',
                  '30',
                  '120',
                  'R01-L02-B05',
                  'Available',
                ),

                _reportRow(
                  'Product B',
                  'Main Warehouse',
                  '200',
                  '80',
                  '120',
                  'R02-L01-B03',
                  'Available',
                ),

                _reportRow(
                  'Raw Material X',
                  'Raw Material Warehouse',
                  '300',
                  '100',
                  '200',
                  'R04-L03-B08',
                  'Available',
                ),

                _reportRow(
                  'Product C',
                  'Finished Goods Warehouse',
                  '90',
                  '70',
                  '20',
                  'R06-L02-B04',
                  'Low Stock',
                ),

                _reportRow(
                  'Packaging Material',
                  'Main Warehouse',
                  '120',
                  '40',
                  '80',
                  'R03-L01-B02',
                  'Available',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ================= FOOTER =================

          Row(
            children: [
              const Text(
                'Showing 5 records',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF9CA3AF),
                ),
              ),

              const Spacer(),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.download_outlined,
                  size: 16,
                ),
                label: const Text(
                  'Export Report',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF2563EB),
                  side: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORT TABLE ROW
  // ============================================================

  DataRow _reportRow(
    String item,
    String warehouse,
    String stockIn,
    String stockOut,
    String currentStock,
    String location,
    String status,
  ) {
    final bool isLowStock =
        status == 'Low Stock';

    return DataRow(
      cells: [
        DataCell(
          Text(
            item,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        DataCell(
          Text(
            warehouse,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF6B7280),
            ),
          ),
        ),

        DataCell(
          Text(
            stockIn,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF16A34A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        DataCell(
          Text(
            stockOut,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFFEA580C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        DataCell(
          Text(
            currentStock,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        DataCell(
          Text(
            location,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF6B7280),
            ),
          ),
        ),

        DataCell(
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isLowStock
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFEAF8EF),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isLowStock
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF16A34A),
                fontSize: 8,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // QUICK REPORT CARD
  // ============================================================

  Widget _quickReportCard({
    required IconData icon,
    required String title,
    required String description,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFE8F0FF),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color:
                      const Color(0xFF2563EB),
                  size: 19,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON PANEL
  // ============================================================

  Widget _panel({
    required String title,
    required Widget child,
    String? action,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const Spacer(),

              if (action != null)
                InkWell(
                  onTap: onAction,
                  child: Text(
                    action,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 3),

          child,
        ],
      ),
    );
  }
}