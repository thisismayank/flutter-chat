import 'package:flutter/material.dart';
import 'chat_page.dart'; // Ensure this imports your ChatPage correctly

// Define the Chat class
class Chat {
  final String id;
  final String name;
  final String lastMessage;

  Chat({required this.id, required this.name, required this.lastMessage});
}

// OldDashboardScreen widget
class OldDashboardScreen extends StatefulWidget {
  @override
  _OldDashboardScreenState createState() => _OldDashboardScreenState();
}

class _OldDashboardScreenState extends State<OldDashboardScreen> {
  // Example list of chats
  final List<Chat> _chats = [
    Chat(id: '1', name: 'Alice', lastMessage: 'Hey, how are you?'),
    Chat(id: '2', name: 'Bob', lastMessage: 'What\'s up?'),
    // Add more chats as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Dashboard'),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hi, User", // Replace "User" with the actual user name variable
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  // Example static image, replace with user's actual avatar if available
                  backgroundImage:
                      NetworkImage('https://example.com/avatar.jpg'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity, // Use the full width of the device
              height: 180.0, // Fixed height of 180px
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10), // Apply border radius to the container
              ),
              child: ClipRRect(
                // Clip the image with borderRadius
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://thumbs.dreamstime.com/z/dating-app-minimal-infographic-banner-vector-dating-app-minimal-infographic-web-banner-vector-smartphone-mobile-dating-love-165379841.jpg",
                  fit: BoxFit
                      .contain, // Make the image fit without cropping, maintaining aspect ratio
                  width: double.infinity, // Match the container's width
                  height: 180.0, // Match the container's height
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Recent Chats",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
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
            ),
          ),
        ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the ChatPage to start a new chat
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ChatPage()), // Make sure this is correctly implemented
            );
          },
          child: Icon(Icons.chat),
          tooltip: 'New Chat',
        ));
    // ]))
  }
}
