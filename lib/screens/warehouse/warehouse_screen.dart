import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../reports/reports_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  // ============================================================
  // API CONFIGURATION
  // ============================================================

  static const String baseUrl = 'http://127.0.0.1:8000';

  // IMPORTANT:
  // Paste the SAME Bearer Token which is working successfully
  // in Postman.
  static const String token = 'adcbe0b2fab0990:e172d0d217ff1e1';

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
      // Already on Warehouse
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
  // GET WAREHOUSE DETAILS
  // ============================================================

  Future<Map<String, dynamic>> _getWarehouseDetails(
    String warehouse,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/api/method/tcb_wms.tcb_wms.api.warehouse.get_warehouse_details',
    ).replace(
      queryParameters: {
        'warehouse': warehouse,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        // FIX:
        // Bearer token is required here.
        'Authorization': 'token $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'API failed with status code ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid API response.');
    }

    if (decoded['message'] == null) {
      throw Exception('Invalid API response: message not found.');
    }

    final message = decoded['message'];

    if (message is! Map<String, dynamic>) {
      throw Exception('Invalid API response: message format.');
    }

    if (message['status'] != 'success') {
      throw Exception(
        message['message']?.toString() ??
            'Unable to load warehouse details.',
      );
    }

    final data = message['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid API response: warehouse data not found.',
      );
    }

    return data;
  }

  // ============================================================
  // SHOW WAREHOUSE DETAILS
  // ============================================================

  Future<void> _showWarehouseDetails(
    BuildContext context,
    String warehouse,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final data = await _getWarehouseDetails(warehouse);

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (!context.mounted) return;

      _showWarehouseDetailDialog(
        context,
        data,
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (!context.mounted) return;

      _showErrorDialog(
        context,
        e.toString(),
      );
    }
  }

  // ============================================================
  // WAREHOUSE DETAIL DIALOG
  // ============================================================

  void _showWarehouseDetailDialog(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final warehouseData =
        data['warehouse'] as Map<String, dynamic>? ?? {};

    final racks =
        (data['racks'] as List<dynamic>?) ?? [];

    final warehouseName =
        warehouseData['warehouse_name']?.toString() ??
            warehouseData['name']?.toString() ??
            'Warehouse';

    final warehouseCode =
        warehouseData['name']?.toString() ?? '';

    final company =
        warehouseData['company']?.toString() ?? '-';

    final warehouseType =
        warehouseData['warehouse_type']?.toString() ?? '-';

    final status =
        warehouseData['disabled'] == 1
            ? 'Inactive'
            : 'Active';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Container(
            width: 850,
            constraints: const BoxConstraints(
              maxHeight: 700,
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FF),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.warehouse_outlined,
                        color: Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            warehouseName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            warehouseCode,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _statusBadge(status),

                    const SizedBox(width: 10),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==================================================
                // WAREHOUSE INFORMATION
                // ==================================================

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(9),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _detailInfo(
                          'Company',
                          company,
                        ),
                      ),

                      Expanded(
                        child: _detailInfo(
                          'Warehouse Type',
                          warehouseType,
                        ),
                      ),

                      Expanded(
                        child: _detailInfo(
                          'Racks',
                          racks.length.toString(),
                        ),
                      ),

                      Expanded(
                        child: _detailInfo(
                          'Levels',
                          _countLevels(racks).toString(),
                        ),
                      ),

                      Expanded(
                        child: _detailInfo(
                          'Bins',
                          _countBins(racks).toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Storage Structure',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // RACK → LEVEL → BIN → STOCK
                // ==================================================

                Expanded(
                  child: racks.isEmpty
                      ? const Center(
                          child: Text(
                            'No racks found for this warehouse.',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: racks.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            final rack =
                                racks[index]
                                    as Map<String, dynamic>;

                            return _buildRack(
                              rack,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // RACK
  // ============================================================

  Widget _buildRack(
    Map<String, dynamic> rack,
  ) {
    final rackName =
        rack['rack_name']?.toString() ??
            rack['rack_code']?.toString() ??
            'Rack';

    final rackCode =
        rack['rack_code']?.toString() ?? '';

    final rackType =
        rack['rack_type']?.toString() ?? '-';

    final rackStatus =
        rack['status']?.toString() ?? '-';

    final levels =
        (rack['levels'] as List<dynamic>?) ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1E4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.view_module_outlined,
            color: Color(0xFFEA580C),
            size: 20,
          ),
        ),

        title: Text(
          rackName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          '$rackCode  •  $rackType  •  $rackStatus',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),

        children: [
          if (levels.isEmpty)
            const Padding(
              padding: EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No levels found in this rack.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),

          for (final levelItem in levels)
            _buildLevel(
              levelItem as Map<String, dynamic>,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // LEVEL
  // ============================================================

  Widget _buildLevel(
    Map<String, dynamic> level,
  ) {
    final levelName =
        level['level_name']?.toString() ??
            level['name']?.toString() ??
            'Level';

    final bins =
        (level['bins'] as List<dynamic>?) ?? [];

    return Container(
      margin: const EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(
            Icons.layers_outlined,
            color: Color(0xFF2563EB),
            size: 18,
          ),
        ),

        title: Text(
          levelName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          '${bins.length} bin${bins.length == 1 ? '' : 's'}',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),

        children: [
          if (bins.isEmpty)
            const Padding(
              padding: EdgeInsets.all(13),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No bins found in this level.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),

          for (final binItem in bins)
            _buildBin(
              binItem as Map<String, dynamic>,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BIN
  // ============================================================

  Widget _buildBin(
    Map<String, dynamic> bin,
  ) {
    final binName =
        bin['bin_name']?.toString() ??
            bin['name']?.toString() ??
            'Bin';

    final capacity =
        bin['capacity']?.toString() ?? '0';

    final binStatus =
        bin['status']?.toString() ?? '-';

    final stock =
        (bin['stock'] as List<dynamic>?) ?? [];

    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ======================================================
          // BIN HEADER
          // ======================================================

          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFFF),
                  borderRadius:
                      BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.grid_view,
                  color: Color(0xFF7C3AED),
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
                      binName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Capacity: $capacity  •  Status: $binStatus',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${stock.length} item${stock.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ======================================================
          // STOCK
          // ======================================================

          if (stock.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: const Text(
                'No stock available in this bin.',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            )
          else
            Column(
              children: [
                for (final stockItem in stock)
                  _buildStockItem(
                    stockItem
                        as Map<String, dynamic>,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ============================================================
  // STOCK ITEM
  // ============================================================

  Widget _buildStockItem(
    Map<String, dynamic> stock,
  ) {
    final item =
        stock['item']?.toString() ?? '-';

    final quantity =
        stock['quantity']?.toString() ?? '0';

    final reserved =
        stock['reserved_quantity']?.toString() ??
            '0';

    final available =
        stock['available_quantity']?.toString() ??
            '0';

    final uom =
        stock['uom']?.toString() ?? '-';

    final storageLocation =
        stock['storage_location']?.toString() ??
            '-';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [

          const Icon(
            Icons.inventory_2_outlined,
            size: 17,
            color: Color(0xFF2563EB),
          ),

          const SizedBox(width: 9),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _stockValue(
              'Quantity',
              quantity,
            ),
          ),

          Expanded(
            child: _stockValue(
              'Reserved',
              reserved,
            ),
          ),

          Expanded(
            child: _stockValue(
              'Available',
              available,
            ),
          ),

          Expanded(
            child: _stockValue(
              'UOM',
              uom,
            ),
          ),

          Expanded(
            flex: 2,
            child: _stockValue(
              'Location',
              storageLocation,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STOCK VALUE
  // ============================================================

  Widget _stockValue(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL INFO
  // ============================================================

  Widget _detailInfo(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF9CA3AF),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // COUNT LEVELS
  // ============================================================

  int _countLevels(
    List<dynamic> racks,
  ) {
    int count = 0;

    for (final rackItem in racks) {
      final rack =
          rackItem as Map<String, dynamic>;

      final levels =
          (rack['levels'] as List<dynamic>?) ??
              [];

      count += levels.length;
    }

    return count;
  }

  // ============================================================
  // COUNT BINS
  // ============================================================

  int _countBins(
    List<dynamic> racks,
  ) {
    int count = 0;

    for (final rackItem in racks) {
      final rack =
          rackItem as Map<String, dynamic>;

      final levels =
          (rack['levels'] as List<dynamic>?) ??
              [];

      for (final levelItem in levels) {
        final level =
            levelItem as Map<String, dynamic>;

        final bins =
            (level['bins'] as List<dynamic>?) ??
                [];

        count += bins.length;
      }
    }

    return count;
  }

  // ============================================================
  // ERROR DIALOG
  // ============================================================

  void _showErrorDialog(
    BuildContext context,
    String error,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Unable to Load Warehouse Details',
          ),
          content: Text(
            error.replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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

                Container(
                  height: 88,
                  padding:
                      const EdgeInsets.symmetric(
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
                              fontWeight:
                                  FontWeight.bold,
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

                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.symmetric(
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
                        true,
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

                Padding(
                  padding:
                      const EdgeInsets.all(12),
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
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  decoration:
                      const BoxDecoration(
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
                        'Warehouse',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF111827),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: 270,
                        height: 40,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(0xFFF8FAFC),
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: const TextField(
                          decoration:
                              InputDecoration(
                            hintText:
                                'Search warehouse...',
                            prefixIcon:
                                Icon(
                              Icons.search,
                              size: 19,
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(
                              top: 9,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You have 5 notifications.',
                                  ),
                                ),
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

                      InkWell(
                        borderRadius:
                            BorderRadius.circular(20),
                        onTap: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Profile clicked.',
                              ),
                            ),
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
                          fontWeight:
                              FontWeight.w600,
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
                    padding:
                        const EdgeInsets.all(26),
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
                                    'Warehouse Management',
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
                                    'Manage warehouses, storage capacity and warehouse locations.',
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
                                  'Add Warehouse feature will be connected to backend.',
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 18,
                              ),
                              label: const Text(
                                'Add Warehouse',
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
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
                                title:
                                    'Total Warehouses',
                                value: '8',
                                subtitle:
                                    'Registered warehouses',
                                icon: Icons
                                    .warehouse_outlined,
                                iconBackground:
                                    const Color(
                                  0xFFE8F0FF,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title:
                                    'Active Warehouses',
                                value: '6',
                                subtitle:
                                    'Currently operational',
                                icon: Icons
                                    .check_circle_outline,
                                iconBackground:
                                    const Color(
                                  0xFFE8F8EF,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Total Racks',
                                value: '100',
                                subtitle:
                                    'Across all warehouses',
                                icon: Icons
                                    .view_module_outlined,
                                iconBackground:
                                    const Color(
                                  0xFFFFF1E4,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title:
                                    'Total Levels',
                                value: '200',
                                subtitle:
                                    'Across all racks',
                                icon: Icons
                                    .layers_outlined,
                                iconBackground:
                                    const Color(
                                  0xFFEAF4FF,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _statCard(
                                title: 'Total Bins',
                                value: '300',
                                subtitle:
                                    'Storage bins',
                                icon:
                                    Icons.grid_view,
                                iconBackground:
                                    const Color(
                                  0xFFF3EFFF,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================= FILTER =================

                        _panel(
                          title:
                              'Warehouse Filters',
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 14,
                              ),

                              Row(
                                children: [

                                  Expanded(
                                    child:
                                        _filterField(
                                      context,
                                      'Warehouse Type',
                                      Icons
                                          .category_outlined,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child:
                                        _filterField(
                                      context,
                                      'Status',
                                      Icons
                                          .check_circle_outline,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child:
                                        _filterField(
                                      context,
                                      'Location',
                                      Icons
                                          .location_on_outlined,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  SizedBox(
                                    height: 43,
                                    child:
                                        ElevatedButton
                                            .icon(
                                      onPressed: () {
                                        _showMessage(
                                          context,
                                          'Warehouse filters applied.',
                                        );
                                      },
                                      icon:
                                          const Icon(
                                        Icons.search,
                                        size: 17,
                                      ),
                                      label:
                                          const Text(
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

                        // ================= WAREHOUSE TABLE =================

                        _panel(
                          title: 'Warehouses',
                          action: 'Export',
                          actionOnTap: () {
                            _showMessage(
                              context,
                              'Warehouse export started.',
                            );
                          },
                          child: Column(
                            children: [

                              const SizedBox(
                                height: 15,
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      Color(0xFFF8FAFC),
                                  borderRadius:
                                      BorderRadius.vertical(
                                    top:
                                        Radius.circular(
                                      7,
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  children: [

                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Warehouse',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Type',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Location',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Racks',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Levels',
                                        style:
                                            _tableHeaderStyle,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Bins',
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
                                  ],
                                ),
                              ),

                              _warehouseRow(
                                context,
                                'Main Warehouse - WD',
                                'Main Warehouse',
                                'Central',
                                'Main',
                                '40',
                                '80',
                                '120',
                                'Active',
                              ),

                              _warehouseRow(
                                context,
                                'Goods In Transit - WD',
                                'Goods In Transit',
                                'Transit',
                                'Transit',
                                '0',
                                '0',
                                '0',
                                'Active',
                              ),

                              _warehouseRow(
                                context,
                                'Finished Goods - WD',
                                'Finished Goods',
                                'Industrial Area',
                                'Finished Goods',
                                '20',
                                '40',
                                '60',
                                'Active',
                              ),

                              _warehouseRow(
                                context,
                                'Stores - WD',
                                'Stores',
                                'Industrial Area',
                                'Stores',
                                '25',
                                '50',
                                '80',
                                'Active',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= QUICK ACTIONS =================

                        _panel(
                          title:
                              'Warehouse Quick Actions',
                          child: Row(
                            children: [

                              Expanded(
                                child: _quickAction(
                                  context,
                                  Icons
                                      .add_business_outlined,
                                  'Add Warehouse',
                                  'Create a new warehouse',
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: _quickAction(
                                  context,
                                  Icons
                                      .view_module_outlined,
                                  'Manage Racks',
                                  'Manage warehouse racks',
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: _quickAction(
                                  context,
                                  Icons
                                      .layers_outlined,
                                  'Manage Levels',
                                  'Manage rack levels',
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: _quickAction(
                                  context,
                                  Icons.grid_view,
                                  'Manage Bins',
                                  'Manage storage bins',
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: _quickAction(
                                  context,
                                  Icons
                                      .location_on_outlined,
                                  'Storage Locations',
                                  'View storage locations',
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
      margin:
          const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF3B82F6)
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(8),
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
      borderRadius:
          BorderRadius.circular(8),
      onTap: () {
        _showMessage(
          context,
          '$title filter selected.',
        );
      },
      child: Container(
        height: 43,
        padding:
            const EdgeInsets.symmetric(
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
  // WAREHOUSE ROW
  // ============================================================

  Widget _warehouseRow(
    BuildContext context,
    String code,
    String name,
    String location,
    String type,
    String racks,
    String levels,
    String bins,
    String status,
  ) {
    return InkWell(
      onTap: () {
        _showWarehouseDetails(
          context,
          code,
        );
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration:
            const BoxDecoration(
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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 9,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Text(
                type,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),

            Expanded(
              child: Text(
                location,
                style: const TextStyle(
                  fontSize: 10,
                  color:
                      Color(0xFF6B7280),
                ),
              ),
            ),

            Expanded(
              child: Text(
                racks,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Text(
                levels,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Text(
                bins,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: _statusBadge(status),
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
    final Color color =
        status == 'Active'
            ? Colors.green
            : Colors.orange;

    return Align(
      alignment:
          Alignment.centerLeft,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color:
              color.withOpacity(0.10),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTION
  // ============================================================

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(9),
      onTap: () {
        _showMessage(
          context,
          '$title selected.',
        );
      },
      child: Container(
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(9),
          border: Border.all(
            color:
                const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
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

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 9,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
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
      padding:
          const EdgeInsets.all(18),
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
                  color:
                      Color(0xFF111827),
                ),
              ),

              const Spacer(),

              if (action != null)
                InkWell(
                  onTap: actionOnTap,
                  child: Text(
                    action,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF2563EB),
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

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            const Duration(seconds: 2),
      ),
    );
  }
}

// ============================================================
// TABLE HEADER STYLE
// ============================================================

const TextStyle _tableHeaderStyle =
    TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: Color(0xFF6B7280),
);