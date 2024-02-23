import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Example user data - replace with actual data from your user model
  final String name = "User Name";
  final String email = "user@example.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Name: $name"),
            Text("Email: $email"),
          ],
        ),
      ),
    );
  }
}
