import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SensorDetails extends StatefulWidget {
  const SensorDetails({Key? key});

  @override
  State<SensorDetails> createState() => _SensorDetailsState();
}

class _SensorDetailsState extends State<SensorDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  var sensorValue = 0;

  var arrNames = [
    'Soil Moisture',
    'Temperature',
    'Electrical conductivity',
    'Nitrogen(N)',
    'Phosphorus(P)',
    'Potassium(k)',
    'Ph',
    'Rain sensor',
    'Ultra Sonic'.tr
  ];

  var arrIcons = [
    Icons.opacity_outlined,
    Icons.thermostat,
    Icons.electrical_services_outlined,
    Icons.grass,
    Icons.biotech,
    Icons.eco,
    Icons.water,
    Icons.wb_sunny_outlined,
    Icons.waves
  ];

  var arrUsage = [
    50, 30, 2.5, 0.3, 20, 250, 6.5, 600, 20
  ];

  DateTime selectedDate = DateTime.now();

  String _getUnitSymbol(int index) {
    switch (index) {
      case 0: // Soil Moisture
        return '%';
      case 1: // Temperature
        return '°C';
      case 2: // Electrical conductivity
        return 'ds/m';
      case 3: // Nitrogen(N)
        return '%';
      case 4: // Phosphorus(P)
        return 'mg';
      case 5: // Potassium(k)
        return 'mg';
      case 6: // Ph
        return '';
      case 7: // Rain sensor
        return '';
      case 8: // Ultra Sonic
        return 'cm';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(_animationController);

    FirebaseDatabase.instance
        .ref()
        .child('-Nw8NQ1U_Eb-jcensfWC') // Update with your database reference
        .onValue
        .listen((event) {
      var data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          // Assuming 'rainSensorValue' corresponds to 'Rain' in your database structure
          sensorValue = data['Rain'] == "not Raining" ? 0 : 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'See the old Records'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(arrIcons[index]),
                    title: Text(arrNames[index]),
                    trailing: Text(
                      '${arrUsage[index]}${_getUnitSymbol(index)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _animationController.reset();
                      _animationController.animateTo(
                        arrUsage[index].toDouble(),
                        curve: Curves.easeInOut,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(arrNames[index]),
                          content: SizedBox(
                            width: 200,
                            height: 200,
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      minimum: 0,
                                      maximum: 100,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                          startValue: 0,
                                          endValue: 100,
                                          color: Colors.green,
                                        ),
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(value: _animation.value),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: arrNames.length,
              separatorBuilder: (context, index) {
                return Divider(height: 5, thickness: 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
