import 'package:casper/emoticon_face.dart';
import 'package:flutter/material.dart';
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
    // Add more chats as needed
  ];

  @override
  Widget build(BuildContext context) {
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Hi, User!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "24 Feb, 2024",
                            style: TextStyle(color: Colors.blue[200]),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        decoration: InputDecoration(
                          focusColor: Colors.blue.shade600,
                          fillColor: Colors.blue.shade600,
                          hintText: 'Search...',
                          iconColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue.shade600),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          EmoticonFace(emoticonFace: "😄"),
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
                          EmoticonFace(emoticonFace: "😄"),
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
                          EmoticonFace(emoticonFace: "😄"),
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
                          EmoticonFace(emoticonFace: "😄"),
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
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Column(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Previous Chats",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Icon(Icons.more_horiz),
                      ]),
                  Column(
                    children: _chats
                        .map((chat) => ListTile(
                              title: Text(chat.name),
                              subtitle: Text(chat.lastMessage),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage()));
                              },
                            ))
                        .toList(),
                  )
                ]),
              ),
            ))
          ],
        )));
  }
}
