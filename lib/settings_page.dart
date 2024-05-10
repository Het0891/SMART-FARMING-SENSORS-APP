import 'dart:io';
import 'package:app_dev/Pages/about_us.dart';
import 'package:app_dev/Pages/language_page.dart';
import 'package:app_dev/account_settings.dart';
import 'package:app_dev/feedback_form.dart';
import 'package:app_dev/notification_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ImageProvider<Object> _profilePhoto;

  @override
  void initState() {
    super.initState();
    _profilePhoto = AssetImage('assets/default_profile_photo.jpg');
  }

  void _selectImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = FileImage(File(pickedFile.path));
      });
    }
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _profilePhoto,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => _showFullImage(context),
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePhoto,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        '${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
                        style: GoogleFonts.actor(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_a_photo_outlined),
                      onPressed: _selectImage,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  Get.to(() => NotificationSettings());
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('Notification'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.notifications_active, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountSettingsPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('Accounts'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.notifications_active, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  Get.to(() => LanguagePage());
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('Languages'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.language_outlined, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  Get.to(() => AboutUsPage());
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('About Us'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.info_rounded, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackForm(),
                    ),
                  );
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('Feedback'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.feedback_outlined, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text('Logout'.tr),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.logout_outlined, color: Colors.white),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'.tr),
          content: Text('Are You sure you want to Logout?'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout'.tr),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out Successfully'.tr),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error logging out: $e'.tr);
    }
  }
}
