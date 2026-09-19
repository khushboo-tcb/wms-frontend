import 'package:flutter/material.dart';
import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class OutboundScreen extends StatelessWidget {
  const OutboundScreen({super.key});

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InboundScreen(),
        ),
      );
    } else if (title == 'Outbound') {
      // Already on Outbound
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
      _showMessage(
        context,
        '$title module is not implemented yet.',
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
                        false,
                        context,
                      ),

                      _menuItem(
                        Icons.upload_outlined,
                        'Outbound',
                        true,
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
                        'Outbound',
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
                            hintText: 'Search outbound...',

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
                                    'Outbound Management',
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
                                    'Manage outgoing orders, picking, packing and dispatch operations.',
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
                                  'Create Outbound clicked.',
                                );
                              },

                              icon: const Icon(
                                Icons.add,
                                size: 17,
                              ),

                              label: const Text(
                                'Create Outbound',
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
                                title: 'Orders Today',
                                value: '24',
                                subtitle:
                                    'Outbound orders',
                                icon:
                                    Icons.shopping_cart_outlined,
                                iconBackground:
                                    const Color(0xFFE8F0FF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '24 outbound orders today.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Pending Picking',
                                value: '8',
                                subtitle:
                                    'Orders awaiting picking',
                                icon:
                                    Icons.inventory_2_outlined,
                                iconBackground:
                                    const Color(0xFFFFF1E4),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '8 orders are pending picking.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Ready to Dispatch',
                                value: '10',
                                subtitle:
                                    'Orders ready',
                                icon:
                                    Icons.local_shipping_outlined,
                                iconBackground:
                                    const Color(0xFFE8F8EF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '10 orders are ready to dispatch.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Dispatched',
                                value: '18',
                                subtitle:
                                    'Orders dispatched',
                                icon:
                                    Icons.done_all_outlined,
                                iconBackground:
                                    const Color(0xFFF3EFFF),
                                onTap: () {
                                  _showMessage(
                                    context,
                                    '18 orders dispatched.',
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
                          title: 'Outbound Filters',

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
                                      'Customer',
                                      Icons
                                          .person_outline,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Status',
                                      Icons.flag_outlined,
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
                                          'Outbound filters applied.',
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
                        // OUTBOUND ORDERS
                        // =================================================

                        _panel(
                          title: 'Outbound Orders',

                          action: 'View All',

                          actionOnTap: () {
                            _showMessage(
                              context,
                              'Showing all outbound orders.',
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
                                        'Order ID',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Customer',
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

                              _outboundRow(
                                context,
                                'OUT-2025',
                                'ABC Retail',
                                'WH-01',
                                '120',
                                'Picked',
                                '09:15 AM',
                              ),

                              _outboundRow(
                                context,
                                'OUT-2026',
                                'XYZ Traders',
                                'WH-01',
                                '250',
                                'Packing',
                                '10:00 AM',
                              ),

                              _outboundRow(
                                context,
                                'OUT-2027',
                                'Global Mart',
                                'WH-02',
                                '180',
                                'Ready to Dispatch',
                                '10:45 AM',
                              ),

                              _outboundRow(
                                context,
                                'OUT-2028',
                                'Prime Retail',
                                'WH-02',
                                '90',
                                'Dispatched',
                                '11:30 AM',
                              ),

                              _outboundRow(
                                context,
                                'OUT-2029',
                                'ABC Retail',
                                'WH-01',
                                '310',
                                'Pending Picking',
                                '12:15 PM',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =================================================
                        // PROCESS + QUICK ACTIONS
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
                              child: _quickActions(context),
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
                    color: const Color(0xFF2563EB),
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
  // OUTBOUND ROW
  // ============================================================

  Widget _outboundRow(
    BuildContext context,
    String orderId,
    String customer,
    String warehouse,
    String items,
    String status,
    String time,
  ) {
    return InkWell(
      onTap: () {
        _showOutboundDetails(
          context,
          orderId,
          customer,
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
                orderId,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),

            Expanded(
              child: Text(
                customer,
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

  Widget _statusBadge(String status) {
    Color color;

    if (status == 'Picked') {
      color = Colors.blue;
    } else if (status == 'Packing') {
      color = Colors.orange;
    } else if (status == 'Ready to Dispatch') {
      color = Colors.purple;
    } else if (status == 'Dispatched') {
      color = Colors.green;
    } else {
      color = Colors.red;
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
  // OUTBOUND PROCESS
  // ============================================================

  Widget _processPanel() {
    return _panel(
      title: 'Outbound Process',

      child: Column(
        children: [

          const SizedBox(height: 18),

          _processStep(
            1,
            'Order Received',
            '24 orders',
            Icons.shopping_cart_outlined,
            true,
          ),

          _processStep(
            2,
            'Picking',
            '8 pending',
            Icons.inventory_2_outlined,
            false,
          ),

          _processStep(
            3,
            'Packing',
            '6 orders',
            Icons.inventory_outlined,
            true,
          ),

          _processStep(
            4,
            'Ready to Dispatch',
            '10 orders',
            Icons.local_shipping_outlined,
            true,
          ),

          _processStep(
            5,
            'Dispatched',
            '18 orders',
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

  Widget _quickActions(BuildContext context) {
    return _panel(
      title: 'Quick Actions',

      child: Column(
        children: [

          const SizedBox(height: 14),

          _quickAction(
            context,
            Icons.add_shopping_cart_outlined,
            'Create Outbound',
            'Create a new outbound order.',
          ),

          _quickAction(
            context,
            Icons.inventory_2_outlined,
            'Start Picking',
            'Pick items for an order.',
          ),

          _quickAction(
            context,
            Icons.inventory_outlined,
            'Packing',
            'Pack picked items.',
          ),

          _quickAction(
            context,
            Icons.local_shipping_outlined,
            'Dispatch',
            'Dispatch packed orders.',
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
  // OUTBOUND DETAILS
  // ============================================================

  void _showOutboundDetails(
    BuildContext context,
    String orderId,
    String customer,
    String warehouse,
    String items,
    String status,
    String time,
  ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(orderId),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                'Customer: $customer',
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