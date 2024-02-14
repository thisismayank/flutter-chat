import 'package:casper/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailScreen extends StatefulWidget {
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
      body: '{"email": "${_emailController.text}"}',
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OTPScreen(email: _emailController.text),
      ));
    } else {
      // Handle error or notify user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
