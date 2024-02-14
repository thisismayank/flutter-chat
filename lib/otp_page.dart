import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_screen.dart'; // Make sure you create this file

class OTPScreen extends StatelessWidget {
  final String email;
  final TextEditingController _otpController = TextEditingController();

  OTPScreen({Key? key, required this.email}) : super(key: key);

  Future<void> _verifyOTP(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/v1/users/email/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: '{"email": "$email", "otp": "${_otpController.text}"}',
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle error or notify user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: () => _verifyOTP(context),
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
