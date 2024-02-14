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
      appBar: AppBar(
        title: Text('Chat Dashboard'),
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            onTap: () {
              // Navigate to the chat screen for this chat
              // This is where you'd pass the chat ID or details to the chat screen
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        ChatPage()), // Make sure this is correctly implemented
              );
            },
          );
        },
      ),
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
      ),
    );
  }
}
