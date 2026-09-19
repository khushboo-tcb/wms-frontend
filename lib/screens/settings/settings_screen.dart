import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool emailNotifications = true;
  bool stockAlerts = true;
  bool expiryAlerts = true;
  bool lowStockAlerts = true;
  bool autoRefresh = true;

  String selectedTheme = 'Light';
  String selectedDateFormat = 'DD/MM/YYYY';
  String selectedTimeZone = 'Asia/Kolkata';

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
                      ),

                      _menuItem(
                        Icons.inventory_2_outlined,
                        'Inventory',
                      ),

                      _menuItem(
                        Icons.download_outlined,
                        'Inbound',
                      ),

                      _menuItem(
                        Icons.upload_outlined,
                        'Outbound',
                      ),

                      _menuItem(
                        Icons.warehouse_outlined,
                        'Warehouse',
                      ),

                      _menuItem(
                        Icons.bar_chart_outlined,
                        'Reports',
                      ),

                      const SizedBox(height: 10),

                      const Divider(
                        color: Colors.white12,
                      ),

                      const SizedBox(height: 10),

                      _menuItem(
                        Icons.notifications_none,
                        'Notifications',
                      ),

                      _menuItem(
                        Icons.settings_outlined,
                        'Settings',
                        selected: true,
                      ),

                      _menuItem(
                        Icons.person_outline,
                        'Profile',
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
                        'Settings',
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
                // SETTINGS CONTENT
                // =================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manage your warehouse system preferences and configuration.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ================= GENERAL =================

                        _settingsSection(
                          title: 'General Settings',
                          subtitle:
                              'Configure basic system preferences.',
                          icon: Icons.tune_outlined,
                          children: [
                            _dropdownSetting(
                              title: 'Theme',
                              subtitle:
                                  'Choose the application appearance.',
                              value: selectedTheme,
                              items: const [
                                'Light',
                                'Dark',
                                'System Default',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedTheme = value!;
                                });
                              },
                            ),

                            _dropdownSetting(
                              title: 'Date Format',
                              subtitle:
                                  'Select the format used across the system.',
                              value: selectedDateFormat,
                              items: const [
                                'DD/MM/YYYY',
                                'MM/DD/YYYY',
                                'YYYY-MM-DD',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedDateFormat = value!;
                                });
                              },
                            ),

                            _dropdownSetting(
                              title: 'Time Zone',
                              subtitle:
                                  'Set the default system time zone.',
                              value: selectedTimeZone,
                              items: const [
                                'Asia/Kolkata',
                                'UTC',
                                'Asia/Dubai',
                                'Europe/London',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedTimeZone = value!;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ================= WAREHOUSE =================

                        _settingsSection(
                          title: 'Warehouse Settings',
                          subtitle:
                              'Configure warehouse-related preferences.',
                          icon: Icons.warehouse_outlined,
                          children: [
                            _switchSetting(
                              title: 'Auto Refresh',
                              subtitle:
                                  'Automatically refresh warehouse data.',
                              value: autoRefresh,
                              onChanged: (value) {
                                setState(() {
                                  autoRefresh = value;
                                });
                              },
                            ),

                            _switchSetting(
                              title: 'Warehouse Stock Tracking',
                              subtitle:
                                  'Track stock quantities by warehouse.',
                              value: true,
                              onChanged: (value) {},
                            ),

                            _switchSetting(
                              title: 'Rack & Bin Tracking',
                              subtitle:
                                  'Enable rack, level and bin tracking.',
                              value: true,
                              onChanged: (value) {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ================= INVENTORY =================

                        _settingsSection(
                          title: 'Inventory Settings',
                          subtitle:
                              'Configure inventory and stock management.',
                          icon: Icons.inventory_2_outlined,
                          children: [
                            _switchSetting(
                              title: 'Low Stock Alerts',
                              subtitle:
                                  'Receive alerts when stock reaches the minimum level.',
                              value: lowStockAlerts,
                              onChanged: (value) {
                                setState(() {
                                  lowStockAlerts = value;
                                });
                              },
                            ),

                            _switchSetting(
                              title: 'Expiry Alerts',
                              subtitle:
                                  'Receive notifications for items approaching expiry.',
                              value: expiryAlerts,
                              onChanged: (value) {
                                setState(() {
                                  expiryAlerts = value;
                                });
                              },
                            ),

                            _dropdownSetting(
                              title: 'Stock Valuation Method',
                              subtitle:
                                  'Select the method used for stock valuation.',
                              value: 'FIFO',
                              items: const [
                                'FIFO',
                                'LIFO',
                                'Moving Average',
                              ],
                              onChanged: (value) {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ================= NOTIFICATIONS =================

                        _settingsSection(
                          title: 'Notification Settings',
                          subtitle:
                              'Manage warehouse alerts and notifications.',
                          icon: Icons.notifications_none,
                          children: [
                            _switchSetting(
                              title: 'Email Notifications',
                              subtitle:
                                  'Receive important system notifications by email.',
                              value: emailNotifications,
                              onChanged: (value) {
                                setState(() {
                                  emailNotifications = value;
                                });
                              },
                            ),

                            _switchSetting(
                              title: 'Stock Alerts',
                              subtitle:
                                  'Get notified about important stock changes.',
                              value: stockAlerts,
                              onChanged: (value) {
                                setState(() {
                                  stockAlerts = value;
                                });
                              },
                            ),

                            _switchSetting(
                              title: 'Low Stock Notifications',
                              subtitle:
                                  'Notify users when inventory falls below threshold.',
                              value: lowStockAlerts,
                              onChanged: (value) {
                                setState(() {
                                  lowStockAlerts = value;
                                });
                              },
                            ),

                            _switchSetting(
                              title: 'Expiry Notifications',
                              subtitle:
                                  'Notify users about upcoming item expirations.',
                              value: expiryAlerts,
                              onChanged: (value) {
                                setState(() {
                                  expiryAlerts = value;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ================= SYSTEM =================

                        _settingsSection(
                          title: 'System Information',
                          subtitle:
                              'View application and system details.',
                          icon: Icons.info_outline,
                          children: [
                            _informationRow(
                              'Application',
                              'WMS - Warehouse Management System',
                            ),
                            _informationRow(
                              'Version',
                              '1.0.0',
                            ),
                            _informationRow(
                              'Backend',
                              'ERPNext / Frappe',
                            ),
                            _informationRow(
                              'Frontend',
                              'Flutter',
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // ================= SAVE BUTTON =================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedTheme = 'Light';
                                  selectedDateFormat =
                                      'DD/MM/YYYY';
                                  selectedTimeZone =
                                      'Asia/Kolkata';
                                  emailNotifications = true;
                                  stockAlerts = true;
                                  expiryAlerts = true;
                                  lowStockAlerts = true;
                                  autoRefresh = true;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                              ),
                            ),

                            const SizedBox(width: 12),

                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Settings saved successfully.',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.save_outlined,
                                size: 18,
                              ),
                              label: const Text(
                                'Save Changes',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF2563EB),
                                foregroundColor:
                                    Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
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
    String title, {
    bool selected = false,
  }) {
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
          // ================= DASHBOARD =================

          if (title == 'Dashboard') {
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ReportsScreen(),
              ),
            );
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

          // ================= SETTINGS =================

          else if (title == 'Settings') {
            // Already on Settings.
          }

          // ================= LOGOUT =================

          else if (title == 'Logout') {
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          }
        },
      ),
    );
  }

  // ============================================================
  // SETTINGS SECTION
  // ============================================================

  Widget _settingsSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius:
                      BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2563EB),
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: Color(0xFFE5E7EB),
          ),

          const SizedBox(height: 4),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // SWITCH SETTING
  // ============================================================

  Widget _switchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: const Color(0xFF2563EB),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DROPDOWN SETTING
  // ============================================================

  Widget _dropdownSetting({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Container(
            width: 180,
            height: 42,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
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
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 11,
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION ROW
  // ============================================================

  Widget _informationRow(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}