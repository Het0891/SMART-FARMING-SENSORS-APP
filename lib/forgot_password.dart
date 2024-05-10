import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<Forgotpassword> {

  final emailText = TextEditingController();
  @override
  void dispose() {
    emailText.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailText.text.trim());
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        });
  } on FirebaseAuthException catch(e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
    }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(
     title: Text('Forgot Password?'),
      backgroundColor: Colors.blue,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter Your Email and we will send you a password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: TextField(
              controller: emailText,
              decoration: InputDecoration(
                hintText: 'Email Id',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                ),
                prefixIcon: Icon(Icons.email_outlined),

              ),
            ),
          ),
          SizedBox(height: 15),

          MaterialButton(onPressed: passwordReset,
          child: Text('Reset Password'),
          color: Colors.blue,
          )
        ],
      ),
    );
  }
}
