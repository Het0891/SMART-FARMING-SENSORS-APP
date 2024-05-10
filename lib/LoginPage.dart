import 'package:app_dev/auth_service.dart';
import 'package:app_dev/forgot_password.dart';
import 'package:app_dev/Pages/homepage.dart';
import 'package:app_dev/my_button.dart';
import 'package:app_dev/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  final Function()? onTap;
   LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> signInWithGoogle() async {
    final User? user = await AuthService().signInWithGoogle();
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Logged in with Google successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  void signUserIn() async{
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      //pop the loading circle
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Logged in successfully'),
              actions: <Widget>[
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                    child: Text('OK'),
                ),
              ],
            );
          }
      );
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  // error message to user
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
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/images/crop.jpg"
                      )
                  ),
              ),
          ),
            Center(
              child: Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                    color: Colors.white10.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Column(
                      children: [
                        Text("LOGIN", style: TextStyle(color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Welcome Back User!",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 25.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // EMAIL ID
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Email Id',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined),
              
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              Container(height: 20,),
              
                              //PASSWORD
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Password',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide(
                                            color: Colors.green
                                        ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: _togglePasswordVisibility,
                                      child: Icon(_obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 5,),
              
                        //FORGOT PASSWORD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Forgotpassword(),
              
                                  ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
              
                        //LOGIN BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                              return Homepage();
                            },
                            ),
                            );
                          },
                          child: MyButton(
                            text: 'Sign In',
                            onTap: signUserIn,
                          ),
                        ),
                        const SizedBox(height: 50),
              
                        //or continue with other login option
              
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Expanded(child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25),
                                child: Text('Or Continue with',
                                  style: TextStyle(color: Colors.black),),
                              ),
                              Expanded(child: Divider(
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
                                onTap: signInWithGoogle,
                                  imagePath: 'assets/images/search.png'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
              
                        //register now?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Not a Member?',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 6),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text('Register Now',
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
