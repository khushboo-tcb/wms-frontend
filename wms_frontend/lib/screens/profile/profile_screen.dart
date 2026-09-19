import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  final TextEditingController nameController =
      TextEditingController(text: 'Administrator');

  final TextEditingController emailController =
      TextEditingController(text: 'admin@wms.com');

  final TextEditingController phoneController =
      TextEditingController(text: '+91 9876543210');

  final TextEditingController roleController =
      TextEditingController(text: 'System Administrator');

  final TextEditingController departmentController =
      TextEditingController(text: 'Warehouse Management');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  void _saveProfile() {
    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile updated successfully.',
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  void _editProfile() {
    setState(() {
      isEditing = true;
    });
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  void _changePassword() {
    final TextEditingController currentPassword =
        TextEditingController();

    final TextEditingController newPassword =
        TextEditingController();

    final TextEditingController confirmPassword =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Change Password',
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _passwordField(
                  controller: currentPassword,
                  label: 'Current Password',
                ),
                const SizedBox(height: 14),
                _passwordField(
                  controller: newPassword,
                  label: 'New Password',
                ),
                const SizedBox(height: 14),
                _passwordField(
                  controller: confirmPassword,
                  label: 'Confirm New Password',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPassword.text.isEmpty ||
                    confirmPassword.text.isEmpty) {
                  return;
                }

                if (newPassword.text !=
                    confirmPassword.text) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Passwords do not match.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password changed successfully.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Change Password',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
                      ),

                      _menuItem(
                        Icons.person_outline,
                        'Profile',
                        selected: true,
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
                        'Profile',
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
                // PROFILE CONTENT
                // =================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manage your personal information and account settings.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =================================================
                        // PROFILE HEADER CARD
                        // =================================================

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 82,
                                height: 82,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEFF6FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(
                                      0xFFDBEAFE,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 43,
                                  color:
                                      Color(0xFF2563EB),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      nameController.text,
                                      style:
                                          const TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                          0xFF111827,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    const Text(
                                      'System Administrator',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFF6B7280,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 9),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: const Color(
                                          0xFFEAF8EF,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          20,
                                        ),
                                      ),
                                      child: const Text(
                                        'Active',
                                        style: TextStyle(
                                          color: Color(
                                            0xFF16A34A,
                                          ),
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (!isEditing)
                                ElevatedButton.icon(
                                  onPressed:
                                      _editProfile,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 17,
                                  ),
                                  label: const Text(
                                    'Edit Profile',
                                  ),
                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFF2563EB,
                                    ),
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // PERSONAL INFORMATION
                        // =================================================

                        _profileSection(
                          title: 'Personal Information',
                          subtitle:
                              'View and update your account information.',
                          icon: Icons.person_outline,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _profileField(
                                    label: 'Full Name',
                                    controller:
                                        nameController,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _profileField(
                                    label: 'Email Address',
                                    controller:
                                        emailController,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: _profileField(
                                    label: 'Phone Number',
                                    controller:
                                        phoneController,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _profileField(
                                    label: 'Role',
                                    controller:
                                        roleController,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _profileField(
                              label: 'Department',
                              controller:
                                  departmentController,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // ACCOUNT INFORMATION
                        // =================================================

                        _profileSection(
                          title: 'Account Information',
                          subtitle:
                              'Information related to your WMS account.',
                          icon:
                              Icons.account_circle_outlined,
                          children: [
                            _accountRow(
                              'Username',
                              'administrator',
                            ),
                            _accountRow(
                              'Account Status',
                              'Active',
                            ),
                            _accountRow(
                              'User Role',
                              'System Administrator',
                            ),
                            _accountRow(
                              'Last Login',
                              'Today, 09:30 AM',
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // SECURITY
                        // =================================================

                        _profileSection(
                          title: 'Security',
                          subtitle:
                              'Manage your account security preferences.',
                          icon: Icons.security_outlined,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration:
                                        BoxDecoration(
                                      color: const Color(
                                        0xFFF3F4F6,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.lock_outline,
                                      size: 20,
                                      color: Color(
                                        0xFF374151,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          'Password',
                                          style:
                                              TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Keep your account secure by updating your password regularly.',
                                          style:
                                              TextStyle(
                                            fontSize: 10,
                                            color: Color(
                                              0xFF6B7280,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  OutlinedButton(
                                    onPressed:
                                        _changePassword,
                                    child: const Text(
                                      'Change Password',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // =================================================
                        // ACTION BUTTONS
                        // =================================================

                        if (isEditing)
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                style: OutlinedButton
                                    .styleFrom(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 22,
                                    vertical: 14,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                ),
                              ),

                              const SizedBox(width: 12),

                              ElevatedButton.icon(
                                onPressed:
                                    _saveProfile,
                                icon: const Icon(
                                  Icons
                                      .save_outlined,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Save Changes',
                                ),
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      const Color(
                                    0xFF2563EB,
                                  ),
                                  foregroundColor:
                                      Colors.white,
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 22,
                                    vertical: 14,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
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
            // Already on Profile.
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
  // PROFILE SECTION
  // ============================================================

  Widget _profileSection({
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

          const SizedBox(height: 5),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE FIELD
  // ============================================================

  Widget _profileField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF111827),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          color: Color(0xFF6B7280),
        ),
        filled: true,
        fillColor: isEditing
            ? Colors.white
            : const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT ROW
  // ============================================================

  Widget _accountRow(
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