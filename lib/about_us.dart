import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/du.jpg', // Replace 'your_logo.png' with your actual logo asset path
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'DYULABS',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'DyuLabs is inventing innovative technologies to reduce consumption of electricity by efficient control of the electical equipments.\n\n'
                      'With our cutting-edge technologies, we aim to empower businesses and individuals by providing them with the product to increase productivity and efficiency. Our products are designed to be user-friendly.\n\n'
                      'Whether you\'re looking to save energy or need a reliable way to control your electrical appliance without internet, we have the products that can help.\n\n'
                      'We have created:\n'
                      '- Effective and energy saving light communication system to bring safe lighthing environment for warehouse industry, basement parkings etc. Product\n'
                      '- Innovative and cost effective way of controlling water pumps without having recurring cost on SIM recharge and wifi connectivity requirement\n\n'
                      'Our aim to innovate for user experince and step towards "Net Zero" target.\n\n'
                      '----------------------------------x----------------------------------'.tr,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
