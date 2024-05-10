import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({Key? key}) : super(key: key);

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackTypeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Feedback'.tr),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_feedbackTypeController, 'Feedback Type'),
            _buildTextField(_messageController, 'Message', maxLines: null),
            const SizedBox(height: 20),
            MyButton(
              onTap: _submitFeedback,
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {int? maxLines}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        maxLines: maxLines,
      ),
    );
  }

  void _submitFeedback() {
    // Check if any field is empty
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _feedbackTypeController.text.isEmpty ||
        _messageController.text.isEmpty) {
      // Show an error dialog if any field is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Fill all the fields.'),
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
      return; // Stop executing the method if any field is empty
    }

    // Proceed to submit feedback if all fields are filled
    final Map<String, dynamic> feedbackData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'feedbackType': _feedbackTypeController.text,
      'message': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    _firestore.collection('feedback').add(feedbackData);

    // Clear text controllers
    _nameController.clear();
    _emailController.clear();
    _feedbackTypeController.clear();
    _messageController.clear();

    // Show a success dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback Submitted'),
          content: const Text('Thank you for your feedback!'),
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
  }
}

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({Key? key, required this.onTap, required this.text}) : super(key: key);

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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
