import 'package:casper/data/user_data.dart';
import 'package:casper/emoticon_face.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'chat_page.dart'; // Ensure this imports your ChatPage correctly
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dart:convert';

// Define the Chat class
class Chat {
  final String id;
  final String name;
  final String lastMessage;

  Chat({required this.id, required this.name, required this.lastMessage});
}

// DashboardScreen widget
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  String _highlightedTone = '';
  Future<void> getTone(BuildContext context) async {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null || user.authToken.isEmpty) {
      print('User is null or authToken is missing');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/v1/users/tone'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${user.authToken}', // Use the auth token
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var responseData = json.decode(response.body);
        print("TONE $responseData");
        if (responseData['success'] == true &&
            responseData['results'] != null) {
          String tone = responseData['results']['tone'];
          // Update the state to reflect the fetched tone
          setState(() {
            _highlightedTone =
                tone; // Assume _highlightedTone is a state variable
          });
        }
      } else {
        print('Failed to fetch tone. Status code: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error fetching tone: $e');
    }
  }

  Future<void> _recordTone(BuildContext context, String tone) async {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    // Ensure you have a valid user and authToken
    if (user == null || user.authToken.isEmpty) {
      print('User is null or authToken is missing');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/v1/users/tone'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${user.authToken}', // Add the auth token here
        },
        body: jsonEncode({'tone': tone}),
      );

      // Check if the response body is not empty and is valid JSON
      if (response.body.isNotEmpty) {
        var userDataDecoded = json.decode(response.body);

        if (response.statusCode == 200) {
          var userData = userDataDecoded["results"];
          print('userData $userData');
          // Process your userData as needed
        } else {
          // Handle non-200 responses
          print('Request failed with status: ${response.statusCode}.');
        }
      } else {
        print('Response body is empty.');
      }
    } catch (e) {
      // Handle JSON decode errors or other exceptions
      print('Error parsing response: $e');
    }
  }

  // Provider.of<UserProvider>(context, listen: false).setUser(user);

  // Navigator.of(context).pushAndRemoveUntil(
  //   MaterialPageRoute(builder: (context) => HomeNavigationScreen()),
  //   (Route<dynamic> route) => false,
  // );
  // Example list of chats
  final List<Chat> _chats = [
    Chat(id: '1', name: 'Alice', lastMessage: 'Hey, how are you?'),
    Chat(id: '2', name: 'Bob', lastMessage: 'What\'s up?'),
    Chat(id: '3', name: 'John', lastMessage: 'Hey, how you doin?'),
    Chat(id: '4', name: 'Jake', lastMessage: 'How\'s it going?'),
    Chat(id: '5', name: 'Emma', lastMessage: 'How was your day?'),
    // Add more chats as needed
  ];

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      print("HELLOOOO");
      getTone(context);

      // side effects code here.
      //subscription to a stream, opening a WebSocket connection, or performing HTTP requests
    }, []);
    var user = Provider.of<UserProvider>(context).user;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd, MMM yyyy').format(now);
    return Scaffold(
        backgroundColor: Colors.blue[800],
        body: SafeArea(
            child: Column(
          children: [
            // greetings row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${user?.firstName}!",
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
                  const SizedBox(
                    height: 20,
                  ),

                  // Search bar++
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusColor: Colors.blue.shade600,
                          fillColor: Colors.blue.shade600,
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color to a lighter white
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          iconColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Used when TextFormField is enabled
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none, // No border
                          ),
                          focusedBorder: OutlineInputBorder(
                            // Used when TextFormField is focused
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none, // No border
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // how do you feel
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mood today?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white)
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          EmoticonFace(
                              emoticonFace: "😄",
                              onTap: () => _recordTone(context, "Happy"),
                              isHighlighted: _highlightedTone == "hero"),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Happy",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(
                              emoticonFace: "🧐",
                              onTap: () =>
                                  _recordTone(context, 'Philosophical'),
                              isHighlighted:
                                  _highlightedTone == "Philosophical"),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Philosophical",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(
                              emoticonFace: "😉",
                              onTap: () => _recordTone(context, "Flirty"),
                              isHighlighted: _highlightedTone == "Flirty"),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Flirty",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(
                              emoticonFace: "😏",
                              onTap: () => _recordTone(context, "Naughty"),
                              isHighlighted: _highlightedTone == "Naughty"),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Naghty",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // CHATS HEADING+++

            // CHATS +++
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(25),
                child: ListView.builder(
                  itemCount:
                      _chats.length + 1, // +1 to accommodate the header row
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Return the header for the first item
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Previous Chats",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.more_horiz),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    }
                    // Adjust index by 1 because the first item is the header
                    final chat = _chats[index - 1];
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: 8), // Add some space between items
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.orange,
                            child: Icon(Icons.favorite, color: Colors.white),
                          ),
                        ),
                        title: Text(
                          chat.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(Icons.more_horiz),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        )));
  }
}
