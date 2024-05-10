import 'dart:ui';
import 'package:app_dev/Pages/sensor_detail.dart';
import 'package:app_dev/Pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);
  static const route = '/homepage'; // Define a static route

  final user = FirebaseAuth.instance.currentUser!;

  //sign out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  bool toggleValue = false;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  int _selectedIndex = 0;
  late DateTime lastButtonToggleTime; // New field to store the last toggle time

  @override
  void initState() {
    super.initState();
  }

  void toggleButton(bool newValue) {
    setState(() {
      toggleValue = newValue;
      lastButtonToggleTime = DateTime.now(); // Update the last toggle time
    });
    _database.child('switch').set(newValue ? 'ON' : 'OFF');
    _database.child('lastToggleTime').set(lastButtonToggleTime.toIso8601String());

    if (newValue) {
      // Fetch data when the button is toggled ON
      _database.child('sensor').onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? sensorData = snapshot.value as Map<dynamic, dynamic>?; // Explicit casting
        if (sensorData != null) {
          // Handle sensor data here...
          print('Sensor data: $sensorData');
        } else {
          print('Sensor data is null or not in the expected format.');
        }
      }, onError: (error) {
        print('Error fetching sensor data: $error');
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // list of page titles
  final List<String> _pageTitles = ['Home','Sensors Details','Settings'.tr];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex].tr,
            style: TextStyle(fontWeight: FontWeight.bold)
        ), //Set appbar title dynamically
        backgroundColor: Colors.white10,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Sensor Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          _buildHomePage(),
          SensorDetails(),
          SettingsPage(),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    //welcome home text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Farmer analyzing data on eco farming.jpg',
                            height: 100,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 40),
                          //smart sensor + grid
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: Text('Sensor Button'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  toggleButton(true);
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3)
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      'ON'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  toggleButton(false);
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      'OFF'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'The button is ${toggleValue ? 'ON' : 'OFF'}'.tr,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
