import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../inventory/inventory_screen.dart';
import '../inbound/inbound_screen.dart';
import '../outbound/outbound_screen.dart';
import '../warehouse/warehouse_screen.dart';
import '../dashboard/dashboard_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState
    extends State<UserManagementScreen> {
  // ============================================================
  // API
  // ============================================================

  static const String baseUrl = 'http://127.0.0.1:8001';

  // ============================================================
  // USERS
  // ============================================================

  List<Map<String, dynamic>> _users = [];

  bool _isLoadingUsers = true;

  // ============================================================
  // SEARCH / FILTER
  // ============================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _searchText = '';

  String _statusFilter = 'All';
  String _roleFilter = 'All';

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        _searchText =
            _searchController.text.trim().toLowerCase();
      });
    });

    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // GET USERS
  // ============================================================

  Future<void> _loadUsers() async {
    if (!mounted) return;

    setState(() {
      _isLoadingUsers = true;
    });

    final token = AppSession.token;

    if (token == null || token.isEmpty) {
      if (!mounted) return;

      setState(() {
        _isLoadingUsers = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Session expired. Please login again.'),
        ),
      );

      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> apiUsers =
            data['users'] ?? [];

        final List<Map<String, dynamic>> loadedUsers = [];

        for (final user in apiUsers) {
          final role = user['role'];

          final List<dynamic> warehouses =
              user['warehouses'] ?? [];

          String warehouseName = 'No Warehouse';

          if (warehouses.isNotEmpty) {
            warehouseName = warehouses
                .map(
                  (warehouse) =>
                      warehouse['name']?.toString() ?? '',
                )
                .where(
                  (name) => name.isNotEmpty,
                )
                .join(', ');
          }

          final String name =
              user['name']?.toString() ?? 'Unknown User';

          final bool isActive =
              user['is_active'] == true;

          loadedUsers.add({
            'id': user['id'],
            'name': name,
            'email':
                user['email']?.toString() ?? '',
            'role':
                role?['name']?.toString() ?? 'No Role',
            'role_id': role?['id'],
            'warehouse': warehouseName,
            'warehouse_ids': warehouses
                .map((warehouse) => warehouse['id'])
                .where((id) => id != null)
                .toList(),
            'status':
                isActive ? 'Active' : 'Inactive',
            'is_active': isActive,
            'initial': name.isNotEmpty
                ? name[0].toUpperCase()
                : 'U',
            'color':
                const Color(0xFFE9D5FF),
          });
        }

        if (!mounted) return;

        setState(() {
          _users = loadedUsers;
          _isLoadingUsers = false;
        });
      } else if (response.statusCode == 401) {
        if (!mounted) return;

        setState(() {
          _isLoadingUsers = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Session expired. Please login again.'),
          ),
        );
      } else if (response.statusCode == 403) {
        if (!mounted) return;

        setState(() {
          _isLoadingUsers = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin access required.'),
          ),
        );
      } else {
        if (!mounted) return;

        setState(() {
          _isLoadingUsers = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load users. Status: '
              '${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingUsers = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to WMS server.\n$e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // FILTERED USERS
  // ============================================================

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final String name =
          user['name']?.toString().toLowerCase() ?? '';

      final String email =
          user['email']?.toString().toLowerCase() ?? '';

      final String role =
          user['role']?.toString().toLowerCase() ?? '';

      final String warehouse =
          user['warehouse']?.toString().toLowerCase() ?? '';

      final String status =
          user['status']?.toString() ?? '';

      final bool matchesSearch =
          _searchText.isEmpty ||
          name.contains(_searchText) ||
          email.contains(_searchText) ||
          role.contains(_searchText) ||
          warehouse.contains(_searchText);

      final bool matchesStatus =
          _statusFilter == 'All' ||
          status == _statusFilter;

      final bool matchesRole =
          _roleFilter == 'All' ||
          role == _roleFilter.toLowerCase();

      return matchesSearch &&
          matchesStatus &&
          matchesRole;
    }).toList();
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<void> _deleteUser(
    Map<String, dynamic> user,
  ) async {
    final userId = user['id'];

    final userName =
        user['name']?.toString() ?? 'this user';

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID not found.'),
        ),
      );
      return;
    }

    final bool? confirmDelete =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text(
            'Are you sure you want to delete $userName?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) {
      return;
    }

    final token = AppSession.token;

    if (token == null || token.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Session expired. Please login again.'),
        ),
      );

      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {
        await _loadUsers();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('User deleted successfully.'),
          ),
        );

        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data['detail']?.toString() ??
                'Failed to delete user.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to WMS server.\n$e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // ADD USER
  // ============================================================

  void _openAddUserDialog() {
    final nameController =
        TextEditingController();

    final emailController =
        TextEditingController();

    final passwordController =
        TextEditingController();

    String selectedRole =
        'Warehouse Staff';

    int selectedRoleId = 3;

    int selectedWarehouseId = 1;

    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Container(
                width: 480,
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'Add Warehouse Staff / User',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF111827),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              Navigator.pop(
                            dialogContext,
                          ),
                          padding:
                              EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller:
                          nameController,
                      decoration:
                          _inputDecoration(
                        'Enter full name',
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Work Email',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller:
                          emailController,
                      decoration:
                          _inputDecoration(
                        'staff@company.com',
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Temporary Password',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller:
                          passwordController,
                      obscureText: true,
                      decoration:
                          _inputDecoration(
                        'Create temporary password',
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Role',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              DropdownButtonFormField<
                                  String>(
                                initialValue:
                                    selectedRole,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Admin',
                                    child:
                                        Text('Admin'),
                                  ),
                                  DropdownMenuItem(
                                    value:
                                        'Warehouse Manager',
                                    child: Text(
                                      'Warehouse Manager',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value:
                                        'Warehouse Staff',
                                    child: Text(
                                      'Warehouse Staff',
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value ==
                                      null) {
                                    return;
                                  }

                                  setDialogState(() {
                                    selectedRole =
                                        value;

                                    if (value ==
                                        'Admin') {
                                      selectedRoleId =
                                          1;
                                    } else if (value ==
                                        'Warehouse Manager') {
                                      selectedRoleId =
                                          2;
                                    } else {
                                      selectedRoleId =
                                          3;
                                    }
                                  });
                                },
                                decoration:
                                    _dropdownDecoration(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Warehouse',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              DropdownButtonFormField<
                                  String>(
                                initialValue:
                                    'Main Warehouse',
                                items: const [
                                  DropdownMenuItem(
                                    value:
                                        'Main Warehouse',
                                    child: Text(
                                      'Main Warehouse',
                                    ),
                                  ),
                                ],
                                onChanged: (_) {},
                                decoration:
                                    _dropdownDecoration(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () =>
                                  Navigator.pop(
                                dialogContext,
                              ),
                          child:
                              const Text('Cancel'),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  final name =
                                      nameController
                                          .text
                                          .trim();

                                  final email =
                                      emailController
                                          .text
                                          .trim();

                                  final password =
                                      passwordController
                                          .text
                                          .trim();

                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty) {
                                    ScaffoldMessenger
                                            .of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all required fields.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final token =
                                      AppSession
                                          .token;

                                  if (token ==
                                          null ||
                                      token.isEmpty) {
                                    ScaffoldMessenger
                                            .of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Session expired. Please login again.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setDialogState(() {
                                    isSaving = true;
                                  });

                                  try {
                                    final response =
                                        await http.post(
                                      Uri.parse(
                                        '$baseUrl/users',
                                      ),
                                      headers: {
                                        'Authorization':
                                            'Bearer $token',
                                        'Content-Type':
                                            'application/json',
                                      },
                                      body:
                                          jsonEncode({
                                        'name': name,
                                        'email': email,
                                        'password':
                                            password,
                                        'role_id':
                                            selectedRoleId,
                                        'warehouse_ids':
                                            [
                                          selectedWarehouseId
                                        ],
                                      }),
                                    );

                                    final data =
                                        jsonDecode(
                                      response.body,
                                    );

                                    if (response.statusCode ==
                                            200 ||
                                        response.statusCode ==
                                            201) {
                                      if (!mounted) {
                                        return;
                                      }

                                      Navigator.pop(
                                        dialogContext,
                                      );

                                      await _loadUsers();

                                      if (!mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger
                                              .of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'User created successfully.',
                                          ),
                                        ),
                                      );
                                    } else {
                                      setDialogState(
                                        () {
                                          isSaving =
                                              false;
                                        },
                                      );

                                      ScaffoldMessenger
                                              .of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(
                                            data['detail']
                                                    ?.toString() ??
                                                'Failed to create user.',
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    setDialogState(
                                      () {
                                        isSaving =
                                            false;
                                      },
                                    );

                                    ScaffoldMessenger
                                            .of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Unable to connect to WMS server.\n$e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF3B82F6,
                            ),
                            foregroundColor:
                                Colors.white,
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save User',
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // EDIT USER
  // ============================================================

  void _openEditUserDialog(
    Map<String, dynamic> user,
  ) {
    final userId = user['id'];

    final nameController =
        TextEditingController(
      text: user['name']?.toString() ?? '',
    );

    final emailController =
        TextEditingController(
      text: user['email']?.toString() ?? '',
    );

    String selectedRole =
        user['role']?.toString() ??
            'Warehouse Staff';

    int selectedRoleId =
        user['role_id'] ?? 3;

    bool isActive =
        user['is_active'] == true;

    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title:
                  const Text('Edit User'),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          nameController,
                      decoration:
                          _inputDecoration(
                        'Full Name',
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller:
                          emailController,
                      decoration:
                          _inputDecoration(
                        'Work Email',
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          selectedRole,
                      items: const [
                        DropdownMenuItem(
                          value: 'Admin',
                          child:
                              Text('Admin'),
                        ),
                        DropdownMenuItem(
                          value:
                              'Warehouse Manager',
                          child: Text(
                            'Warehouse Manager',
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                              'Warehouse Staff',
                          child: Text(
                            'Warehouse Staff',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          selectedRole =
                              value;

                          if (value ==
                              'Admin') {
                            selectedRoleId =
                                1;
                          } else if (value ==
                              'Warehouse Manager') {
                            selectedRoleId =
                                2;
                          } else {
                            selectedRoleId =
                                3;
                          }
                        });
                      },
                      decoration:
                          _dropdownDecoration(),
                    ),

                    const SizedBox(height: 14),

                    SwitchListTile(
                      contentPadding:
                          EdgeInsets.zero,
                      title: const Text(
                        'Active User',
                      ),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() {
                          isActive =
                              value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () =>
                          Navigator.pop(
                        dialogContext,
                      ),
                  child:
                      const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (userId == null) {
                            return;
                          }

                          final token =
                              AppSession
                                  .token;

                          if (token ==
                                  null ||
                              token.isEmpty) {
                            ScaffoldMessenger
                                    .of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Session expired. Please login again.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isSaving = true;
                          });

                          try {
                            final response =
                                await http.put(
                              Uri.parse(
                                '$baseUrl/users/$userId',
                              ),
                              headers: {
                                'Authorization':
                                    'Bearer $token',
                                'Content-Type':
                                    'application/json',
                              },
                              body:
                                  jsonEncode({
                                'name':
                                    nameController
                                        .text
                                        .trim(),
                                'email':
                                    emailController
                                        .text
                                        .trim(),
                                'role_id':
                                    selectedRoleId,
                                'is_active':
                                    isActive,
                              }),
                            );

                            final data =
                                jsonDecode(
                              response.body,
                            );

                            if (response.statusCode ==
                                    200 &&
                                data['success'] ==
                                    true) {
                              if (!mounted) {
                                return;
                              }

                              Navigator.pop(
                                dialogContext,
                              );

                              await _loadUsers();

                              if (!mounted) {
                                return;
                              }

                              ScaffoldMessenger
                                      .of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'User updated successfully.',
                                  ),
                                ),
                              );
                            } else {
                              setDialogState(
                                () {
                                  isSaving =
                                      false;
                                },
                              );

                              ScaffoldMessenger
                                      .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    data['detail']
                                            ?.toString() ??
                                        'Failed to update user.',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            setDialogState(() {
                              isSaving =
                                  false;
                            });

                            ScaffoldMessenger
                                    .of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Unable to connect to WMS server.\n$e',
                                ),
                              ),
                            );
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // FILTER DIALOG
  // ============================================================

  void _openFilterDialog() {
    String tempStatus =
        _statusFilter;

    String tempRole =
        _roleFilter;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title:
                  const Text('Filter Users'),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      String>(
                    initialValue:
                        tempStatus,
                    decoration:
                        const InputDecoration(
                      labelText: 'Status',
                      border:
                          OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: 'Active',
                        child:
                            Text('Active'),
                      ),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child:
                            Text('Inactive'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          tempStatus =
                              value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<
                      String>(
                    initialValue:
                        tempRole,
                    decoration:
                        const InputDecoration(
                      labelText: 'Role',
                      border:
                          OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: 'Admin',
                        child:
                            Text('Admin'),
                      ),
                      DropdownMenuItem(
                        value:
                            'Warehouse Manager',
                        child: Text(
                          'Warehouse Manager',
                        ),
                      ),
                      DropdownMenuItem(
                        value:
                            'Warehouse Staff',
                        child: Text(
                          'Warehouse Staff',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          tempRole =
                              value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _statusFilter =
                          'All';
                      _roleFilter =
                          'All';
                    });

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _statusFilter =
                          tempStatus;
                      _roleFilter =
                          tempRole;
                    });

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
              ),
              child:
                  const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                AppSession.token = null;

                Navigator.pop(
                  dialogContext,
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child:
                  const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
      ),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final visibleUsers =
        _filteredUsers;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),
      body: Row(
        children: [
          // ====================================================
          // SIDEBAR
          // ====================================================

          Container(
            width: 235,
            color:
                const Color(0xFF111827),
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
                            MainAxisAlignment
                                .center,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
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
                              color:
                                  Colors.white60,
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
                        false,
                        context,
                      ),
                      _menuItem(
                        Icons.bar_chart_outlined,
                        'Reports',
                        false,
                        context,
                      ),
                      _menuItem(
                        Icons.people_outline,
                        'User Management',
                        true,
                        context,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Divider(
                        color:
                            Colors.white12,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

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

          // ====================================================
          // MAIN
          // ====================================================

          Expanded(
            child: Column(
              children: [
                // TOP BAR
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
                        color:
                            Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'User Management',
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
                              const Color(
                            0xFFF8FAFC,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(8),
                          border: Border.all(
                            color:
                                const Color(
                              0xFFE5E7EB,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller:
                              _searchController,
                          decoration:
                              const InputDecoration(
                            hintText:
                                'Search...',
                            prefixIcon:
                                Icon(
                              Icons.search,
                              size: 19,
                            ),
                            border:
                                InputBorder
                                    .none,
                            contentPadding:
                                EdgeInsets.only(
                              top: 9,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger
                                      .of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Notifications module is not implemented yet.',
                                  ),
                                ),
                              );
                            },
                            icon:
                                const Icon(
                              Icons
                                  .notifications_none,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 4,
                            child:
                                Container(
                              width: 16,
                              height: 16,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Colors.red,
                                shape:
                                    BoxShape
                                        .circle,
                              ),
                              child:
                                  const Center(
                                child: Text(
                                  '5',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        9,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      const CircleAvatar(
                        radius: 18,
                        child: Icon(
                          Icons.person,
                          size: 20,
                        ),
                      ),

                      const SizedBox(
                        width: 9,
                      ),

                      const Text(
                        'Administrator',
                        style: TextStyle(
                          color:
                              Color(0xFF374151),
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      const Icon(
                        Icons
                            .keyboard_arrow_down,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                // BODY
                Expanded(
                  child:
                      SingleChildScrollView(
                    padding:
                        const EdgeInsets.all(
                      26,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children:
                                  const [
                                Text(
                                  'User Management',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Color(
                                      0xFF111827,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Create and manage users, roles and warehouse access.',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF6B7280,
                                    ),
                                    fontSize:
                                        13,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton
                                .icon(
                              onPressed:
                                  _openAddUserDialog,
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFFF3E8FF,
                                ),
                                foregroundColor:
                                    const Color(
                                  0xFF7E22CE,
                                ),
                                elevation: 0,
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      16,
                                  vertical:
                                      12,
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
                              icon:
                                  const Icon(
                                Icons.add,
                                size: 18,
                              ),
                              label:
                                  const Text(
                                'Add User',
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // STATS
                        Row(
                          children: [
                            Expanded(
                              child:
                                  _statCard(
                                title:
                                    'Total Users',
                                value:
                                    '${_users.length}',
                                icon: Icons
                                    .group_outlined,
                                iconBackground:
                                    const Color(
                                  0xFFEFF6FF,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child:
                                  _statCard(
                                title:
                                    'Active Users',
                                value:
                                    '${_users.where((u) => u['status'] == 'Active').length}',
                                icon: Icons
                                    .check_circle_outline,
                                iconBackground:
                                    const Color(
                                  0xFFECFDF5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child:
                                  _statCard(
                                title:
                                    'Inactive Users',
                                value:
                                    '${_users.where((u) => u['status'] == 'Inactive').length}',
                                icon: Icons
                                    .person_off_outlined,
                                iconBackground:
                                    const Color(
                                  0xFFF3F4F6,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // TABLE
                        Container(
                          padding:
                              const EdgeInsets
                                  .all(20),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFFE5E7EB,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        Container(
                                      height: 42,
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal:
                                            12,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.white,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          8,
                                        ),
                                        border:
                                            Border.all(
                                          color:
                                              const Color(
                                            0xFFE5E7EB,
                                          ),
                                        ),
                                      ),
                                      child:
                                          Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .search,
                                            size:
                                                19,
                                            color:
                                                Colors.grey,
                                          ),
                                          const SizedBox(
                                            width:
                                                8,
                                          ),
                                          Expanded(
                                            child:
                                                TextField(
                                              controller:
                                                  _searchController,
                                              decoration:
                                                  const InputDecoration(
                                                hintText:
                                                    'Search users...',
                                                hintStyle:
                                                    TextStyle(
                                                  fontSize:
                                                      13,
                                                  color:
                                                      Colors.grey,
                                                ),
                                                border:
                                                    InputBorder.none,
                                                isDense:
                                                    true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  OutlinedButton
                                      .icon(
                                    onPressed:
                                        _openFilterDialog,
                                    style:
                                        OutlinedButton
                                            .styleFrom(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal:
                                            14,
                                        vertical:
                                            12,
                                      ),
                                      side:
                                          const BorderSide(
                                        color:
                                            Color(
                                          0xFFE5E7EB,
                                        ),
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
                                    icon:
                                        const Icon(
                                      Icons
                                          .filter_list,
                                      size:
                                          18,
                                      color:
                                          Colors.grey,
                                    ),
                                    label:
                                        Text(
                                      _statusFilter ==
                                                  'All' &&
                                              _roleFilter ==
                                                  'All'
                                          ? 'Filter'
                                          : 'Filter Applied',
                                      style:
                                          const TextStyle(
                                        color:
                                            Color(
                                          0xFF374151,
                                        ),
                                        fontSize:
                                            13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical:
                                      12,
                                  horizontal:
                                      16,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF9FAFB,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    6,
                                  ),
                                ),
                                child:
                                    const Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:
                                          Text(
                                        'User',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child:
                                          Text(
                                        'Email',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Text(
                                        'Role',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child:
                                          Text(
                                        'Warehouse',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Text(
                                        'Status',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:
                                          Text(
                                        'Actions',
                                        textAlign:
                                            TextAlign
                                                .right,
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Color(
                                            0xFF4B5563,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (_isLoadingUsers)
                                const Padding(
                                  padding:
                                      EdgeInsets
                                          .symmetric(
                                    vertical:
                                        50,
                                  ),
                                  child:
                                      Center(
                                    child:
                                        CircularProgressIndicator(),
                                  ),
                                )
                              else if (
                                  visibleUsers
                                      .isEmpty)
                                const Padding(
                                  padding:
                                      EdgeInsets
                                          .symmetric(
                                    vertical:
                                        50,
                                  ),
                                  child:
                                      Center(
                                    child:
                                        Text(
                                      'No users found.',
                                      style:
                                          TextStyle(
                                        color:
                                            Color(
                                          0xFF6B7280,
                                        ),
                                        fontSize:
                                            13,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...visibleUsers
                                    .map(
                                  (user) =>
                                      Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      vertical:
                                          14,
                                      horizontal:
                                          16,
                                    ),
                                    decoration:
                                        const BoxDecoration(
                                      border:
                                          Border(
                                        bottom:
                                            BorderSide(
                                          color:
                                              Color(
                                            0xFFF3F4F6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child:
                                        Row(
                                      children: [
                                        Expanded(
                                          flex:
                                              3,
                                          child:
                                              Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    14,
                                                backgroundColor:
                                                    user['color'],
                                                child:
                                                    Text(
                                                  user['initial'],
                                                  style:
                                                      const TextStyle(
                                                    fontSize:
                                                        11,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color:
                                                        Color(
                                                      0xFF374151,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width:
                                                    10,
                                              ),
                                              Flexible(
                                                child:
                                                    Text(
                                                  user['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      const TextStyle(
                                                    fontSize:
                                                        12,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color:
                                                        Color(
                                                      0xFF1F2937,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          flex:
                                              3,
                                          child:
                                              Text(
                                            user[
                                                'email'],
                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  12,
                                              color:
                                                  Color(
                                                0xFF6B7280,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex:
                                              2,
                                          child:
                                              Align(
                                            alignment:
                                                Alignment
                                                    .centerLeft,
                                            child:
                                                Container(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal:
                                                    8,
                                                vertical:
                                                    3,
                                              ),
                                              decoration:
                                                  BoxDecoration(
                                                color:
                                                    const Color(
                                                  0xFFF3F4F6,
                                                ),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                  12,
                                                ),
                                              ),
                                              child:
                                                  Text(
                                                user[
                                                    'role'],
                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      11,
                                                  color:
                                                      Color(
                                                    0xFF4B5563,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex:
                                              3,
                                          child:
                                              Text(
                                            user[
                                                'warehouse'],
                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  12,
                                              color:
                                                  Color(
                                                0xFF374151,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex:
                                              2,
                                          child:
                                              Align(
                                            alignment:
                                                Alignment
                                                    .centerLeft,
                                            child:
                                                Container(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal:
                                                    8,
                                                vertical:
                                                    3,
                                              ),
                                              decoration:
                                                  BoxDecoration(
                                                color: user[
                                                            'status'] ==
                                                        'Active'
                                                    ? const Color(
                                                        0xFFDCFCE7,
                                                      )
                                                    : const Color(
                                                        0xFFFEE2E2,
                                                      ),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                  12,
                                                ),
                                              ),
                                              child:
                                                  Text(
                                                user[
                                                    'status'],
                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: user[
                                                              'status'] ==
                                                          'Active'
                                                      ? const Color(
                                                          0xFF16A34A,
                                                        )
                                                      : const Color(
                                                          0xFFDC2626,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex:
                                              1,
                                          child:
                                              Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                            children: [
                                              IconButton(
                                                icon:
                                                    const Icon(
                                                  Icons
                                                      .edit_outlined,
                                                  size:
                                                      16,
                                                  color:
                                                      Colors.grey,
                                                ),
                                                onPressed:
                                                    () =>
                                                        _openEditUserDialog(
                                                  user,
                                                ),
                                                padding:
                                                    EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),

                                              const SizedBox(
                                                width:
                                                    10,
                                              ),

                                              IconButton(
                                                icon:
                                                    const Icon(
                                                  Icons
                                                      .delete_outline,
                                                  size:
                                                      16,
                                                  color:
                                                      Colors.grey,
                                                ),
                                                onPressed:
                                                    () =>
                                                        _deleteUser(
                                                  user,
                                                ),
                                                padding:
                                                    EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
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
  // SIDEBAR
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
          if (title == 'Logout') {
            _logout(context);
          } else if (title ==
              'Dashboard') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const DashboardScreen(),
              ),
            );
          } else if (title ==
              'Inventory') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InventoryScreen(),
              ),
            );
          } else if (title ==
              'Inbound') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InboundScreen(),
              ),
            );
          } else if (title ==
              'Outbound') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OutboundScreen(),
              ),
            );
          } else if (title ==
              'Warehouse') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const WarehouseScreen(),
              ),
            );
          } else if (title ==
              'User Management') {
            // Already here.
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                content: Text(
                  '$title module is not implemented yet.',
                ),
                duration:
                    const Duration(
                  seconds: 2,
                ),
              ),
            );
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
    required IconData icon,
    required Color iconBackground,
  }) {
    return Container(
      height: 105,
      padding:
          const EdgeInsets.all(16),
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
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(
              color: iconBackground,
              borderRadius:
                  BorderRadius.circular(
                9,
              ),
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFF2563EB),
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 12,
                  color:
                      Color(0xFF6B7280),
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xFF111827),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}