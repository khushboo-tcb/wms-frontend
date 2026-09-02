import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const WMSApp());
}

class WMSApp extends StatelessWidget {
  const WMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WMS',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  // ============================================================
  // ERPNext URL
  // ============================================================

  static const String baseUrl = 'http://127.0.0.1:8000';

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // ERPNext LOGIN
  // ============================================================

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    // Check empty fields
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ERPNext Login API
      final url = Uri.parse('$baseUrl/api/method/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'usr': username,
          'pwd': password,
        },
      );

      // ==========================================================
      // LOGIN SUCCESSFUL
      // ==========================================================

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message']?.toString() ??
                  'Login successful',
            ),
          ),
        );

        // Go to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }

      // ==========================================================
      // LOGIN FAILED
      // ==========================================================

      else {
        String errorMessage = 'Invalid username or password';

        try {
          final responseData = jsonDecode(response.body);

          if (responseData['message'] != null) {
            errorMessage = responseData['message'].toString();
          }
        } catch (_) {
          // Keep default error message
        }

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }

    // ============================================================
    // CONNECTION ERROR
    // ============================================================

    catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to ERPNext.\n$e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ======================================================
          // LEFT SIDE
          // ======================================================

          Expanded(
            child: Container(
              color: const Color(0xFF0F172A),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warehouse,
                        size: 90,
                        color: Colors.white,
                      ),

                      SizedBox(height: 25),

                      Text(
                        'WMS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        'Warehouse Management System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 25),

                      Text(
                        'Manage warehouse operations, inventory, '
                        'locations and stock efficiently.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // RIGHT SIDE
          // ======================================================

          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Login to your WMS account',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // USERNAME
                        // ==================================================

                        const Text(
                          'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: usernameController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // PASSWORD
                        // ==================================================

                        const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: passwordController,
                          enabled: !isLoading,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        obscurePassword =
                                            !obscurePassword;
                                      });
                                    },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // LOGIN BUTTON
                        // ==================================================

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Center(
                          child: Text(
                            'WMS • Warehouse Management System',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}