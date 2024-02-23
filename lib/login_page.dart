import 'package:flutter/material.dart';
import 'otp_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendEmail() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/v1/users/email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': _emailController.text}),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OTPScreen(email: _emailController.text),
      ));
    } else {
      // Handle error or notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    focusColor: Colors.blue.shade600,
                    fillColor: Colors.blue.shade600,
                    labelText: 'Email',
                    iconColor: Colors.white,
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue.shade600),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _sendEmail(),
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
