import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/dashboard/dashboard_screen.dart';

class AppSession {
  static String? token;
}

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

// ============================================================
// LOGIN SCREEN
// ============================================================

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
  // FASTAPI URL
  // ============================================================

  static const String baseUrl = 'http://127.0.0.1:8001';

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // FASTAPI LOGIN
  // ============================================================

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

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
      final url = Uri.parse('$baseUrl/auth/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usr': username,
          'pwd': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppSession.token = responseData['access_token']?.toString();

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        String errorMessage = 'Invalid username or password';

        if (responseData['detail'] != null) {
          errorMessage = responseData['detail'].toString();
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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
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
  // LOGIN SCREEN UI
  // ============================================================

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

                        const SizedBox(height: 18),

                        // ==================================================
                        // REGISTER
                        // ==================================================

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CompanyRegistrationScreen(),
                                          ),
                                        );
                                      },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

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

// ============================================================
// COMPANY REGISTRATION SCREEN
// ============================================================

class CompanyRegistrationScreen extends StatefulWidget {
  const CompanyRegistrationScreen({super.key});

  @override
  State<CompanyRegistrationScreen> createState() =>
      _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState
    extends State<CompanyRegistrationScreen> {
  final TextEditingController companyNameController =
      TextEditingController();

  final TextEditingController adminNameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  static const String baseUrl = 'http://127.0.0.1:8001';

  @override
  void dispose() {
    companyNameController.dispose();
    adminNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // COMPANY REGISTRATION API
  // ============================================================

  Future<void> registerCompany() async {
    final companyName = companyNameController.text.trim();
    final adminName = adminNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (companyName.isEmpty ||
        adminName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // --------------------------------------------------------
      // FASTAPI REGISTER COMPANY
      // --------------------------------------------------------

      final url = Uri.parse('$baseUrl/auth/register-company');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'company_name': companyName,
          'admin_name': adminName,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Company registered successfully. Please login.',
            ),
          ),
        );

        // ------------------------------------------------------
        // RETURN TO LOGIN SCREEN
        // ------------------------------------------------------

        Navigator.pop(context);
      } else {
        String errorMessage = 'Registration failed';

        if (responseData['detail'] != null) {
          errorMessage = responseData['detail'].toString();
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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
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
  // REGISTRATION SCREEN UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.business,
                    size: 60,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Company Registration',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Create your company and administrator account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // COMPANY NAME
                // ==================================================

                const Text(
                  'Company Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: companyNameController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: 'Enter company name',
                    prefixIcon: const Icon(
                      Icons.business_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // ADMIN NAME
                // ==================================================

                const Text(
                  'Admin Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: adminNameController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: 'Enter administrator name',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // EMAIL
                // ==================================================

                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: confirmPasswordController,
                  enabled: !isLoading,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
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
                // REGISTER BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : registerCompany,
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // BACK TO LOGIN
                // ==================================================

                Center(
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Already have an account? Login',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}