import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vending_machine_ordering_app/pages/home.dart';

class Signup extends StatefulWidget {
  final Function()? onTap;
  const Signup({
    super.key,
    required this.onTap,
  });

  @override
  State<Signup> createState() => _SignUpState();
}

class _SignUpState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final double _borderRadius = 12;
  bool _obscurePassword = true;

  void signInUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading screen
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (context) {
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // );
        print('creating user');
        print(emailController.text.trim().toString());

        // Create a user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: confirmPasswordController.text.trim(),
        );
        // Navigate to home page after signup
        Timer(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.code}')),
        );
      }
    } else {
      // If the form is not valid, display the error messages
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section
              Image.asset(
                'assets/signup_page_1.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Title
              const Center(
                child: Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // email textfield
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null; // No error
                },
              ),
              const SizedBox(height: 16),
              // Password TextField
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    fontFamily: 'Centaur',
                    fontSize: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password is required';
                  }
                  return null; // No error
                },
              ),
              const SizedBox(height: 16),
              // confrim pass TextField
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    fontFamily: 'Centaur',
                    fontSize: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null; // No error
                },
              ),
              const SizedBox(height: 20),
              // Social media sign up section
              // const Row(
              //   children: [
              //     Expanded(
              //       child: Divider(
              //         thickness: 1,
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Text(
              //         'or sign up with',
              //         style: TextStyle(color: Colors.black54),
              //       ),
              //     ),
              //     Expanded(
              //       child: Divider(
              //         thickness: 1,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // // Social media buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         // Google sign in action
              //       },
              //       icon: const Icon(Icons.facebook),
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         // Facebook sign in action
              //       },
              //       icon: const Icon(Icons.facebook),
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         // Twitter sign in action
              //       },
              //       icon: const Icon(Icons.facebook),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              // Next Button
              ElevatedButton(
                onPressed: signInUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAA22F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              //Already have an account ?
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(9, 25, 9, 9),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account ?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: ' Login',
                          style: TextStyle(
                            color: Color(0xFFD07506),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
