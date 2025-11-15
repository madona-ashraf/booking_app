import 'package:bookingapp/features/auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigation/presentation/pages/main_navigation_page.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is Authenticated) {
          // Update user display name

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.updateDisplayName(nameController.text.trim());
            await user.reload();
            print("Updated displayName: ${user.displayName}");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationPage(),
              ),
            );
          }

          // Navigation is handled by AuthWrapper in main.dart
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(child: Image.asset('assets/images/logo.jpeg')),
                TextFormField(
                  controller: nameController,
                  validator:
                      (value) => value!.isEmpty ? 'Enter your name' : null,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  validator:
                      (value) => value!.isEmpty ? 'Enter your email' : null,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator:
                      (value) => value!.isEmpty ? 'Enter your password' : null,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Confirm your password';
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Create an account',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
