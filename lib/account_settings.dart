import 'package:app_dev/my_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late User _currentUser;
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    final userData = userDoc.data() as Map<String, dynamic>;
    final mobileNumber = userData['mobileNumber'] as String?;
    _mobileController.text = mobileNumber ?? '';

    // Fetch and set user's name
    _userName = userData['name'] as String?;
    setState(() {}); // Update the state to reflect the changes
  }

  Future<void> _saveMobileNumber() async {
    if (_formKey.currentState!.validate()) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .get();

      final userData = snapshot.data() as Map<String, dynamic>;
      final mobileNumber = userData['mobileNumber'] as String?;

      if (mobileNumber != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser.uid)
            .set(
          {
            'mobileNumber': _mobileController.text,
          },
          SetOptions(merge: true),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mobile number updated successfully')),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser.uid)
            .set(
          {
            'name': _currentUser.displayName ?? '',
            'email': _currentUser.email ?? '',
            'mobileNumber': _mobileController.text,
          },
          SetOptions(merge: true),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mobile number added Successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'User Name: ${_userName ?? "Not available"}',
                    style: TextStyle(fontSize: 18,),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'Email: ${_currentUser.email ?? "Not available"}',
                    style: TextStyle(fontSize: 18,),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number :',
                      hintText: 'Enter your mobile number',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (value.length < 10) {
                        return 'Mobile number must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: MyButton(
                  onTap: _saveMobileNumber,
                  text: 'SAVE',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({Key? key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 90),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

