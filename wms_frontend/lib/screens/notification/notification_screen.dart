import 'package:flutter/material.dart';
import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
      // Already on Notifications
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

                // ================= SIDEBAR MENU =================

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
                        true,
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
                        'Notifications',
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
                            hintText: 'Search notifications...',
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
                                'You are viewing notifications.',
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

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          Color(0xFF111827),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    'View and manage warehouse, inventory and stock notifications.',
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
                                  'All notifications marked as read.',
                                );
                              },
                              icon: const Icon(
                                Icons.done_all,
                                size: 18,
                              ),
                              label: const Text(
                                'Mark All as Read',
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // ================= KPI CARDS =================

                        Row(
                          children: [

                            Expanded(
                              child: _statCard(
                                title: 'Total Notifications',
                                value: '12',
                                subtitle:
                                    'All notifications',
                                icon:
                                    Icons.notifications_none,
                                iconBackground:
                                    const Color(0xFFE8F0FF),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Unread',
                                value: '5',
                                subtitle:
                                    'Need your attention',
                                icon:
                                    Icons.mark_email_unread_outlined,
                                iconBackground:
                                    const Color(0xFFFFF1E4),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Stock Alerts',
                                value: '3',
                                subtitle:
                                    'Inventory related',
                                icon:
                                    Icons.inventory_2_outlined,
                                iconBackground:
                                    const Color(0xFFF3EFFF),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'System Alerts',
                                value: '4',
                                subtitle:
                                    'System notifications',
                                icon:
                                    Icons.warning_amber_outlined,
                                iconBackground:
                                    const Color(0xFFE8F8EF),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================= FILTER =================

                        _panel(
                          title: 'Notification Filters',
                          child: Column(
                            children: [

                              const SizedBox(height: 14),

                              Row(
                                children: [

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Notification Type',
                                      Icons.category_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Status',
                                      Icons
                                          .check_circle_outline,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _filterField(
                                      context,
                                      'Priority',
                                      Icons.priority_high_outlined,
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
                                          'Notification filters applied.',
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

                        // ================= NOTIFICATION LIST =================

                        _panel(
                          title: 'Recent Notifications',
                          action: 'Clear All',
                          actionOnTap: () {
                            _showMessage(
                              context,
                              'Notifications cleared.',
                            );
                          },
                          child: Column(
                            children: [

                              const SizedBox(height: 15),

                              _notificationItem(
                                context,
                                Icons.warning_amber_outlined,
                                'Low Stock Alert',
                                'Item RM-102 has reached the minimum stock level.',
                                '10 minutes ago',
                                'High',
                                false,
                              ),

                              _notificationItem(
                                context,
                                Icons.inventory_2_outlined,
                                'Stock Received',
                                'New stock has been received in Main Warehouse.',
                                '35 minutes ago',
                                'Normal',
                                false,
                              ),

                              _notificationItem(
                                context,
                                Icons.download_outlined,
                                'Inbound Shipment',
                                'Inbound shipment IN-0045 has been received.',
                                '1 hour ago',
                                'Normal',
                                true,
                              ),

                              _notificationItem(
                                context,
                                Icons.upload_outlined,
                                'Outbound Shipment',
                                'Outbound order OUT-0032 has been dispatched.',
                                '2 hours ago',
                                'Normal',
                                true,
                              ),

                              _notificationItem(
                                context,
                                Icons.warehouse_outlined,
                                'Warehouse Capacity Alert',
                                'Main Warehouse has reached 85% capacity.',
                                '3 hours ago',
                                'High',
                                false,
                              ),

                              _notificationItem(
                                context,
                                Icons.check_circle_outline,
                                'Stock Transfer Completed',
                                'Stock transfer ST-0021 was completed successfully.',
                                '5 hours ago',
                                'Normal',
                                true,
                              ),

                              _notificationItem(
                                context,
                                Icons.system_update_outlined,
                                'System Update',
                                'Warehouse management system data was synchronized.',
                                'Yesterday',
                                'Low',
                                true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= NOTIFICATION SUMMARY =================

                        _panel(
                          title: 'Notification Summary',
                          child: Row(
                            children: [

                              Expanded(
                                child: _summaryItem(
                                  Icons.warning_amber_outlined,
                                  'High Priority',
                                  '3',
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _summaryItem(
                                  Icons.notifications_none,
                                  'Unread',
                                  '5',
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _summaryItem(
                                  Icons.check_circle_outline,
                                  'Read',
                                  '7',
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _summaryItem(
                                  Icons.access_time,
                                  'Today',
                                  '9',
                                ),
                              ),
                            ],
                          ),
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
  // SIDEBAR MENU ITEM
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
  }) {
    return Container(
      height: 145,
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
          borderRadius: BorderRadius.circular(8),
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
  // NOTIFICATION ITEM
  // ============================================================

  Widget _notificationItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String time,
    String priority,
    bool read,
  ) {
    return InkWell(
      onTap: () {
        _showMessage(
          context,
          '$title selected.',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFF0F0F0),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: read
                    ? const Color(0xFFF3F4F6)
                    : const Color(0xFFE8F0FF),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: read
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF2563EB),
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: read
                                ? FontWeight.w500
                                : FontWeight.bold,
                            color:
                                const Color(0xFF111827),
                          ),
                        ),
                      ),

                      _priorityBadge(priority),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            if (!read)
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(
                  top: 6,
                ),
                decoration:
                    const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRIORITY BADGE
  // ============================================================

  Widget _priorityBadge(String priority) {
    Color color;

    if (priority == 'High') {
      color = Colors.red;
    } else if (priority == 'Low') {
      color = Colors.grey;
    } else {
      color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY ITEM
  // ============================================================

  Widget _summaryItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 19,
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
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
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