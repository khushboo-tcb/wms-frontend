import 'package:flutter/material.dart';
import '../../main.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ================= LOGOUT =================

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
                        true,
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

                      // ================= REPORTS =================

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
          // MAIN CONTENT
          // =====================================================

          Expanded(
            child: Column(
              children: [
                // ================= TOP BAR =================

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
                        'Dashboard',
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
                          "Here's what's happening in your warehouse today.",
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ================= KPI CARDS =================

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                title: 'Total Stock',
                                value: '1,250',
                                subtitle: 'Items in stock',
                                icon: Icons
                                    .inventory_2_outlined,
                                iconBackground:
                                    const Color(0xFFE8F0FF),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Stock In Today',
                                value: '120',
                                subtitle: 'Items received',
                                icon:
                                    Icons.arrow_downward,
                                iconBackground:
                                    const Color(0xFFE8F8EF),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Stock Out Today',
                                value: '45',
                                subtitle: 'Items dispatched',
                                icon:
                                    Icons.arrow_upward,
                                iconBackground:
                                    const Color(0xFFFFF1E4),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Available Bins',
                                value: '240',
                                subtitle: 'Bins available',
                                icon: Icons.grid_view,
                                iconBackground:
                                    const Color(0xFFEFF2FF),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Pending Tasks',
                                value: '12',
                                subtitle: 'Tasks pending',
                                icon: Icons
                                    .assignment_outlined,
                                iconBackground:
                                    const Color(0xFFF3EFFF),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================= MIDDLE =================

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  _inventoryOverview(),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child:
                                  _warehouseUtilization(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================= BOTTOM =================

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  _recentActivities(),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: _pendingTasks(),
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

          // ================= INVENTORY =================

          else if (title == 'Inventory') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InventoryScreen(),
              ),
            );
          }

          // ================= INBOUND =================

          else if (title == 'Inbound') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InboundScreen(),
              ),
            );
          }

          // ================= OUTBOUND =================

          else if (title == 'Outbound') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OutboundScreen(),
              ),
            );
          }

          // ================= WAREHOUSE =================

          else if (title == 'Warehouse') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const WarehouseScreen(),
              ),
            );
          }

          // ================= REPORTS =================

          else if (title == 'Reports') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ReportsScreen(),
              ),
            );
          }

          // ================= NOTIFICATIONS =================

          else if (title == 'Notifications') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NotificationScreen(),
              ),
            );
          }
          // ================= SETTINGS =================

           else if (title == 'Settings') {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) =>
                     const SettingsScreen(),
                ),
              );
            }
            // ================= PROFILE =================

           else if (title == 'Profile') {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) =>
                     const ProfileScreen(),
                ),
              );
            }

          // ================= DASHBOARD =================

          else if (title == 'Dashboard') {
            // Already on Dashboard.
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
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBackground,
  }) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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

          const SizedBox(height: 8),

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
    );
  }

  // ============================================================
  // INVENTORY OVERVIEW
  // ============================================================

  Widget _inventoryOverview() {
    return _panel(
      title: 'Inventory Overview',
      action: 'View All',
      child: Column(
        children: [
          const SizedBox(height: 15),

          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child:
                          CircularProgressIndicator(
                        value: 0.72,
                        strokeWidth: 27,
                        backgroundColor:
                            const Color(0xFFE5E7EB),
                        color:
                            const Color(0xFF3B82F6),
                      ),
                    ),

                    const Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          '1,250',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total Stock',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 25),

              Expanded(
                child: Column(
                  children: [
                    _inventoryRow(
                      'Raw Materials',
                      '650',
                      '52%',
                      const Color(0xFF3B82F6),
                    ),

                    _inventoryRow(
                      'Finished Goods',
                      '320',
                      '25.6%',
                      const Color(0xFF22C55E),
                    ),

                    _inventoryRow(
                      'Packaging',
                      '180',
                      '14.4%',
                      const Color(0xFFF59E0B),
                    ),

                    _inventoryRow(
                      'Consumables',
                      '100',
                      '8%',
                      const Color(0xFF8B5CF6),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F6FF),
              borderRadius:
                  BorderRadius.circular(7),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.assessment_outlined,
                  size: 17,
                  color: Color(0xFF2563EB),
                ),

                SizedBox(width: 7),

                Text(
                  'View Full Inventory Report',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 11,
                  ),
                ),

                Spacer(),

                Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: Color(0xFF2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INVENTORY ROW
  // ============================================================

  Widget _inventoryRow(
    String name,
    String value,
    String percentage,
    Color color,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              name,
              style:
                  const TextStyle(fontSize: 11),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            '($percentage)',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WAREHOUSE UTILIZATION
  // ============================================================

  Widget _warehouseUtilization() {
    return _panel(
      title: 'Warehouse Utilization',
      child: Column(
        children: [
          const SizedBox(height: 14),

          _utilizationRow(
            'Rack Utilization',
            '80%',
            '80 / 100 Racks',
            0.80,
            const Color(0xFF3B82F6),
            Icons.warehouse_outlined,
          ),

          _utilizationRow(
            'Bin Utilization',
            '65%',
            '195 / 300 Bins',
            0.65,
            const Color(0xFF22C55E),
            Icons.grid_view,
          ),

          _utilizationRow(
            'Level Utilization',
            '70%',
            '42 / 60 Levels',
            0.70,
            const Color(0xFFF59E0B),
            Icons.layers_outlined,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UTILIZATION ROW
  // ============================================================

  Widget _utilizationRow(
    String title,
    String percentage,
    String detail,
    double value,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 19),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 19,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

              Text(
                percentage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  borderRadius:
                      BorderRadius.circular(10),
                  backgroundColor:
                      const Color(0xFFE5E7EB),
                  color: color,
                ),
              ),

              const SizedBox(width: 9),

              SizedBox(
                width: 82,
                child: Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                  textAlign:
                      TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT ACTIVITIES
  // ============================================================

  Widget _recentActivities() {
    return _panel(
      title: 'Recent Activities',
      action: 'View All',
      child: Column(
        children: [
          _activity(
            Icons.arrow_downward,
            'Stock Received',
            'PO-1024 • Supplier ABC Pvt. Ltd.',
            '10:30 AM',
          ),

          _activity(
            Icons.swap_horiz,
            'Material Transfer',
            'ST-0045 • WH-01 to WH-02',
            '11:15 AM',
          ),

          _activity(
            Icons.arrow_upward,
            'Stock Dispatched',
            'SO-2088 • Customer XYZ Corp.',
            '12:20 PM',
          ),

          _activity(
            Icons.check_circle_outline,
            'Putaway Completed',
            'PO-1024 • 120 Items',
            '01:05 PM',
          ),

          _activity(
            Icons.done_all,
            'Picking Completed',
            'SO-2088 • 45 Items',
            '01:45 PM',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  Widget _activity(
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Icon(
              icon,
              size: 16,
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
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFEAF8EF),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                color:
                    Color(0xFF16A34A),
                fontSize: 8,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PENDING TASKS
  // ============================================================

  Widget _pendingTasks() {
    return _panel(
      title: 'Pending Tasks',
      action: 'View All',
      child: Column(
        children: [
          _task(
            Icons.move_to_inbox_outlined,
            'Putaway',
            'PO-1025 • 85 Items',
            'High',
            '09:30 AM',
          ),

          _task(
            Icons.swap_horiz,
            'Picking',
            'SO-2090 • 60 Items',
            'Medium',
            '10:00 AM',
          ),

          _task(
            Icons.compare_arrows,
            'Stock Transfer',
            'ST-0046 • 150 Items',
            'Medium',
            '11:30 AM',
          ),

          _task(
            Icons.inventory_2_outlined,
            'Inventory Count',
            'WH-01 • Zone A',
            'Low',
            '02:00 PM',
          ),

          _task(
            Icons.verified_outlined,
            'Quality Check',
            'PO-1026 • 50 Items',
            'Low',
            '03:30 PM',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TASK
  // ============================================================

  Widget _task(
    IconData icon,
    String title,
    String subtitle,
    String priority,
    String time,
  ) {
    Color priorityColor;

    if (priority == 'High') {
      priorityColor = Colors.red;
    } else if (priority == 'Medium') {
      priorityColor = Colors.orange;
    } else {
      priorityColor = Colors.blue;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Icon(
              icon,
              size: 16,
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
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: priorityColor
                  .withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              priority,
              style: TextStyle(
                color: priorityColor,
                fontSize: 8,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 9,
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
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const Spacer(),

              if (action != null)
                Text(
                  action,
                  style: const TextStyle(
                    color:
                        Color(0xFF2563EB),
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
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