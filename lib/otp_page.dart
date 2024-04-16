import 'package:casper/data/user_data.dart';
import 'package:casper/hoome_navigation.dart';
import 'package:casper/models/user_model.dart';
import 'package:flutter/material.dart';
import 'old_d1.dart'; // Ensure this file exists
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

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
      body: jsonEncode({
        'email': email,
        'verificationCode': _otpController.text,
        "deviceToken": "1"
      }),
    );

    if (response.statusCode == 200) {
      var userDataDecoded = json.decode(response.body);

      var userData = userDataDecoded["results"];
      print('userData $userData');
      var user = User(
        userId: userData["_id"],
        name: '${userData["firstName"]} ${userData["lastName"]}',
        firstName: userData["firstName"],
        lastName: userData["lastName"],
        email: userData["email"],
        token: userData["token"],
        authToken: '${userData["_id"]},${userData["token"]}',
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeNavigationScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle error or notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    focusColor: Colors.blue.shade600,
                    fillColor: Colors.blue.shade600,
                    hintText: 'Search...',
                    labelText: 'OTP',
                    iconColor: Colors.white,
                    prefixIcon: const Icon(Icons.pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue.shade600),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _verifyOTP(context),
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
