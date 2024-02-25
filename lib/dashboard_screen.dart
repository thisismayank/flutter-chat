import 'package:casper/data/user_data.dart';
import 'package:casper/emoticon_face.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'chat_page.dart'; // Ensure this imports your ChatPage correctly

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
                        "How do you feel?",
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
                            onTap: () {
                              print('Emoticon Tapped!');
                            },
                          ),
                          SizedBox(
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
                            emoticonFace: "😄",
                            onTap: () {
                              print('Emoticon Tapped!');
                            },
                          ),
                          SizedBox(
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
                            emoticonFace: "😄",
                            onTap: () {
                              print('Emoticon Tapped!');
                            },
                          ),
                          SizedBox(
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
                            emoticonFace: "😄",
                            onTap: () {
                              print('Emoticon Tapped!');
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Happy",
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
