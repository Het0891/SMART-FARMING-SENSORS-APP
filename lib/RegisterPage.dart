import 'package:app_dev/Pages/homepage.dart';
import 'package:app_dev/Pages/user_detail_page.dart';
import 'package:app_dev/my_button.dart';
import 'package:app_dev/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_service.dart';

final _formKey = GlobalKey<FormState>();

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController(); // New username controller
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose(); // Dispose username controller
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> addUsersDetails(String name, String email, String username) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Name': name,
      'Email': email,
      'Username': username, // Include username in Firestore data
    });
  }

  void signUserUp() async {
    try {
      if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await addUsersDetails(
          nameController.text.trim(),
          emailController.text.trim(),
          usernameController.text.trim(), // Pass username to addUsersDetails
        );

        nameController.clear();
        emailController.clear();
        usernameController.clear(); // Clear username field
        passwordController.clear();
        confirmPasswordController.clear();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Registration Success'),
              content: const Text('You have successfully registered.'),
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
      } else {
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/crop.jpg"),
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white10.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "REGISTRATION",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "LET'S REGISTER YOUR DETAILS!",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Container(height: 25),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: usernameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Username',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.black, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              Container(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Email id', // Username field
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.black, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              Container(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.green),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                ),
                              ),
                              Container(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: confirmPasswordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.green),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: _togglePasswordVisibility,
                                      child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 5),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: MyButton(
                          text: 'Sign Up',
                          onTap: signUserUp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Or Continue with',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'assets/images/search.png',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an Account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
