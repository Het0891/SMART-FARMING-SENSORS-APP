import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _allowNotification = true;
  bool _allowSound = true;
  bool _allowVibration = true;

  @override
  void initState() {
    super.initState();
    fetchNotificationSettings();
  }

  Future<void> fetchNotificationSettings() async {
    try {
      String userId = _auth.currentUser!.uid;
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        setState(() {
          _allowNotification = snapshot['allowNotifications'] ?? false;
          _allowSound = snapshot['allowSound'] ?? false;
          _allowVibration = snapshot['allowVibration'] ?? false;
        });
      }
    } catch (e) {
      print('Error fetching notification settings: $e');
    }
  }

  Future<void> updateNotificationSettings() async {
    try {
      String userId = _auth.currentUser!.uid;
      Map<String, dynamic> data = {
      'allowNotifications': _allowNotification,
      'allowSound': _allowNotification ? _allowSound : false,
      'allowVibration': _allowNotification ? _allowVibration : false,
      };

      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating notification settings: $e');
    }
  }

  void handleNotificationSubscription(bool allowNotification) {
    try {
      if (allowNotification) {
        FirebaseMessaging.instance.subscribeToTopic('general_updates');
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic('general_updates');
      }
    } catch (e) {
      print('Error subscribing/unsubscribing from topic: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'.tr),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Allow Notification'),
              value: _allowNotification,
              onChanged: (value) {
              setState(() {
                _allowNotification = value;
                handleNotificationSubscription(value);
              });
              },
          ),
          SwitchListTile(
            title: Text('Allow Sound'),
            value: _allowSound,
            onChanged: (value) {
              setState(() {
                _allowSound = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Allow Vibration'),
            value: _allowVibration,
            onChanged: (value) {
              setState(() {
                _allowVibration = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
