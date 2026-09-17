import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'main_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username == 'Cella' && password == '12345') {
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => MainNavigation(username: username),
      ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username atau password salah',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.dmSansTextTheme
        (Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
      
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
      
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 30,
                    color: AppColors.ink,
                  ),
                  
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign in to  ',
                        style: GoogleFonts.dmSans(
                          color: AppColors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sela Kala',
                        style: GoogleFonts.lora(
                          color: AppColors.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
      
      
                  const SizedBox(height: 8),
      
                  Text(
                    'Himpunan kata berkala di sela waktu.',
                    style: GoogleFonts.dmSans(
                      color: AppColors.ink,
                    ),
                  ),
      
                  const SizedBox(height: 40),
      
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      iconColor: AppColors.ink,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 16),
      
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      iconColor: AppColors.ink,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 24),
      
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}