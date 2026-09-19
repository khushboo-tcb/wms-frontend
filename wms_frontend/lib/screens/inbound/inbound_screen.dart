import 'package:flutter/material.dart';
import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class InboundScreen extends StatelessWidget {
  const InboundScreen({super.key});

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
  // NAVIGATION
  // ============================================================

  void _navigateToModule(
    BuildContext context,
    String title,
  ) {
    if (title == 'Dashboard') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } else if (title == 'Inventory') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
        ),
      );
    } else if (title == 'Inbound') {
      // Already on Inbound
    } else if (title == 'Outbound') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OutboundScreen(),
        ),
      );
    } else if (title == 'Warehouse') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WarehouseScreen(),
        ),
      );
    } else if (title == 'Reports') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ReportsScreen(),
        ),
      );
    } else if (title == 'Notifications') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
        ),
      );
    } else if (title == 'Settings') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    } else if (title == 'Profile') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    } else if (title == 'Logout') {
      _logout(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$title module is not implemented yet.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                        true,
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
                        false,
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
          // MAIN AREA
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
                        'Inbound',
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
                        child: TextField(
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _showMessage(
                                context,
                                'Searching for "$value"',
                              );
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search inbound...',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 19,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(
                              top: 9,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      // ================= NOTIFICATION =================

                      Stack(
                        children: [

                          IconButton(
                            onPressed: () {
                              _showMessage(
                                context,
                                'You have 5 notifications.',
                              );
                            },
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

                      // ================= PROFILE =================

                      InkWell(
                        borderRadius:
                            BorderRadius.circular(20),
                        onTap: () {
                          _showMessage(
                            context,
                            'Profile clicked.',
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          child: Icon(
                            Icons.person,
                            size: 20,
                          ),
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

                        // ================= HEADER =================

                        Row(
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  const Text(
                                    'Inbound Management',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          Color(0xFF111827),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text(
                                    'Manage incoming stock, receipts, putaway and supplier deliveries.',
                                    style: TextStyle(
                                      color:
                                          Color(0xFF6B7280),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton.icon(
                              onPressed: () {
                                _showMessage(
                                  context,
                                  'Create Inbound clicked.',
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 17,
                              ),
                              label: const Text(
                                'Create Inbound',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // =================================================
                        // KPI CARDS
                        // =================================================

                        Row(
                          children: [

                            Expanded(
                              child: _statCard(
                                title: 'Expected Today',
                                value: '18',
                                subtitle:
                                    'Incoming shipments',
                                icon:
                                    Icons.event_available_outlined,
                                iconBackground:
                                    const Color(0xFFE8F0FF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '18 inbound shipments expected today.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Received Today',
                                value: '12',
                                subtitle:
                                    'Shipments received',
                                icon:
                                    Icons.download_done_outlined,
                                iconBackground:
                                    const Color(0xFFE8F8EF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '12 shipments received today.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Pending Putaway',
                                value: '6',
                                subtitle:
                                    'Awaiting putaway',
                                icon:
                                    Icons.move_to_inbox_outlined,
                                iconBackground:
                                    const Color(0xFFFFF1E4),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '6 shipments are pending putaway.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Total Items',
                                value: '1,420',
                                subtitle:
                                    'Items received today',
                                icon:
                                    Icons.inventory_2_outlined,
                                iconBackground:
                                    const Color(0xFFF3EFFF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '1,420 items received today.',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // =================================================
                        // FILTERS
                        // =================================================

                        _panel(
                          title: 'Inbound Filters',
                          child: Column(
                            children: [

                              const SizedBox(height: 14),

                              Row(
                                children: [

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Warehouse',
                                      Icons
                                          .warehouse_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Supplier',
                                      Icons
                                          .local_shipping_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Status',
                                      Icons
                                          .flag_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Date',
                                      Icons
                                          .calendar_today_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  SizedBox(
                                    height: 43,
                                    child:
                                        ElevatedButton.icon(
                                      onPressed: () {
                                        _showMessage(
                                          context,
                                          'Inbound filters applied.',
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        size: 17,
                                      ),
                                      label: const Text(
                                        'Apply',
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
                        // INBOUND ORDERS
                        // =================================================

                        _panel(
                          title: 'Inbound Shipments',
                          action: 'View All',
                          actionOnTap: () {
                            _showMessage(
                              context,
                              'Showing all inbound shipments.',
                            );
                          },
                          child: Column(
                            children: [

                              const SizedBox(height: 15),

                              // ================= HEADER =================

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration:
                                    const BoxDecoration(
                                  color: Color(0xFFF8FAFC),
                                  borderRadius:
                                      BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                                child: const Row(
                                  children: [

                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Inbound ID',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Supplier',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Warehouse',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Items',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Status',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Time',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ================= ROWS =================

                              _inboundRow(
                                context,
                                'INB-1025',
                                'ABC Pvt. Ltd.',
                                'WH-01',
                                '250',
                                'Received',
                                '09:30 AM',
                              ),

                              _inboundRow(
                                context,
                                'INB-1026',
                                'XYZ Industries',
                                'WH-01',
                                '180',
                                'Putaway Pending',
                                '10:15 AM',
                              ),

                              _inboundRow(
                                context,
                                'INB-1027',
                                'Global Suppliers',
                                'WH-02',
                                '320',
                                'In Transit',
                                '11:00 AM',
                              ),

                              _inboundRow(
                                context,
                                'INB-1028',
                                'Prime Materials',
                                'WH-02',
                                '150',
                                'Received',
                                '12:20 PM',
                              ),

                              _inboundRow(
                                context,
                                'INB-1029',
                                'ABC Pvt. Ltd.',
                                'WH-01',
                                '520',
                                'Quality Check',
                                '01:10 PM',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =================================================
                        // INBOUND PROCESS
                        // =================================================

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: _processPanel(),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child:
                                  _quickActions(context),
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
  // SIDEBAR ITEM
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
          _navigateToModule(
            context,
            title,
          );
        },
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 145,
        padding: const EdgeInsets.all(15),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    color:
                        const Color(0xFF2563EB),
                    size: 21,
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                  size: 19,
                ),
              ],
            ),

            const SizedBox(height: 9),

            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                height: 1.1,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTER FIELD
  // ============================================================

  Widget _filterField(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _showMessage(
          context,
          '$title filter selected.',
        );
      },
      child: Container(
        height: 43,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              size: 17,
              color: const Color(0xFF6B7280),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 17,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INBOUND ROW
  // ============================================================

  Widget _inboundRow(
    BuildContext context,
    String inboundId,
    String supplier,
    String warehouse,
    String items,
    String status,
    String time,
  ) {
    return InkWell(
      onTap: () {
        _showInboundDetails(
          context,
          inboundId,
          supplier,
          warehouse,
          items,
          status,
          time,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFF0F0F0),
            ),
          ),
        ),
        child: Row(
          children: [

            Expanded(
              flex: 2,
              child: Text(
                inboundId,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),

            Expanded(
              child: Text(
                supplier,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),

            Expanded(
              child: Text(
                warehouse,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),

            Expanded(
              child: Text(
                items,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: _statusBadge(status),
            ),

            Expanded(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(
    String status,
  ) {
    Color color;

    if (status == 'Received') {
      color = Colors.green;
    } else if (status == 'Putaway Pending') {
      color = Colors.orange;
    } else if (status == 'Quality Check') {
      color = Colors.purple;
    } else {
      color = Colors.blue;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INBOUND PROCESS PANEL
  // ============================================================

  Widget _processPanel() {
    return _panel(
      title: 'Inbound Process',
      child: Column(
        children: [

          const SizedBox(height: 18),

          _processStep(
            1,
            'Expected',
            '18 shipments',
            Icons.event_note_outlined,
            true,
          ),

          _processStep(
            2,
            'Receiving',
            '12 shipments',
            Icons.download_outlined,
            true,
          ),

          _processStep(
            3,
            'Quality Check',
            '5 shipments',
            Icons.verified_outlined,
            true,
          ),

          _processStep(
            4,
            'Putaway',
            '6 pending',
            Icons.move_to_inbox_outlined,
            false,
          ),

          _processStep(
            5,
            'Completed',
            '7 shipments',
            Icons.check_circle_outline,
            true,
          ),
        ],
      ),
    );
  }

  Widget _processStep(
    int number,
    String title,
    String detail,
    IconData icon,
    bool completed,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [

          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: completed
                  ? const Color(0xFFE8F8EF)
                  : const Color(0xFFFFF1E4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.check
                  : icon,
              size: 17,
              color: completed
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFF59E0B),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          Text(
            '#$number',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions(
    BuildContext context,
  ) {
    return _panel(
      title: 'Quick Actions',
      child: Column(
        children: [

          const SizedBox(height: 14),

          _quickAction(
            context,
            Icons.add_box_outlined,
            'Create Inbound',
            'Create a new inbound shipment.',
          ),

          _quickAction(
            context,
            Icons.download_done_outlined,
            'Receive Stock',
            'Record incoming stock.',
          ),

          _quickAction(
            context,
            Icons.verified_outlined,
            'Quality Inspection',
            'Inspect received materials.',
          ),

          _quickAction(
            context,
            Icons.move_to_inbox_outlined,
            'Putaway',
            'Move stock to storage locations.',
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _showMessage(
          context,
          '$title clicked.',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [

            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2563EB),
                size: 18,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 11,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
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
    VoidCallback? actionOnTap,
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
                  onTap: actionOnTap,
                  child: Text(
                    action,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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

  // ============================================================
  // INBOUND DETAILS
  // ============================================================

  void _showInboundDetails(
    BuildContext context,
    String inboundId,
    String supplier,
    String warehouse,
    String items,
    String status,
    String time,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(inboundId),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                'Supplier: $supplier',
              ),

              const SizedBox(height: 8),

              Text(
                'Warehouse: $warehouse',
              ),

              const SizedBox(height: 8),

              Text(
                'Items: $items',
              ),

              const SizedBox(height: 8),

              Text(
                'Status: $status',
              ),

              const SizedBox(height: 8),

              Text(
                'Time: $time',
              ),
            ],
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ============================================================
// TABLE HEADER STYLE
// ============================================================

const TextStyle _tableHeaderStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: Color(0xFF6B7280),
);