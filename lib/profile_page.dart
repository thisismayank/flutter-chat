import 'package:casper/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Example user data - replace with actual data from your user model
  final _formKey = GlobalKey<FormState>();
  bool _isEdited = false;
  String name = "User Name"; // Initial name, replace with actual data
  String email = "user@example.com"; // Initial email, replace with actual data

  void _updateIsEdited() {
    if (!_isEdited) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initially populate data from the user provider if available
    var user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      name = user.name;
      email = user.email;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respond to changes in the user provider
    var user = Provider.of<UserProvider>(context).user;
    if (user != null && (user.email != email || user.name != name)) {
      setState(() {
        email = user.email;
        name = user.name;
      });
    }
  }

  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd, MMM yyyy').format(now);
    return Scaffold(
        backgroundColor: Colors.blue[800],
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${user?.firstName}!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.blue[200]),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50, // Example size, adjust as needed
                          backgroundColor:
                              Colors.blue[800], // Adjust as per design
                          child: Text(
                            name[
                                0], // Display the first letter of the name as placeholder
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: name,
                                decoration: InputDecoration(
                                  focusColor: Colors.blue.shade600,
                                  fillColor: Colors.blue.shade600,
                                  hintText: 'Name...',
                                  labelText: "Name",
                                  iconColor: Colors.white,
                                  prefixIcon: const Icon(Icons.pin),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade600),
                                  ),
                                ),
                                onChanged: (value) {
                                  _updateIsEdited();
                                  name = value;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: email,
                                decoration: InputDecoration(
                                  focusColor: Colors.blue.shade600,
                                  fillColor: Colors.blue.shade600,
                                  hintText: 'Email',
                                  labelText: "Email",
                                  iconColor: Colors.white,
                                  prefixIcon: const Icon(Icons.pin),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade600),
                                  ),
                                ),
                                onChanged: (value) {
                                  _updateIsEdited();
                                  email = value;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _isEdited
                              ? () {
                                  // Add logic to handle profile update
                                  print(
                                      "Profile Updated"); // Placeholder action
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: _isEdited
                                  ? Colors.blue[800]
                                  : Colors
                                      .grey, // Button color changes based on _isEdited
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ])));
  }
}
