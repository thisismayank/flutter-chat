import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the chat page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Example to generate unique ID
      text: message.text,
    );

    print("TEXT MESSAGE ${textMessage}");
    _addMessage(textMessage);

    // Send message to your backend
    await _sendMessageToBackend(message.text);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _sendMessageToBackend(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/v1/chats'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': _user.id,
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the backend returns the message in the same format you need
        final responseJ = json.decode(response.body);
        final responseData = responseJ['response'];
        print('CHAT ${responseData}');
        final _user2 = types.User(id: responseData['author']);
        // Create a TextMessage from the response
        final textMessage = types.TextMessage(
          author: _user2,
          createdAt:
              responseData['createdAt'], // Use the server-provided timestamp
          id: responseData['id']
              .toString(), // Use the server-generated unique ID
          text: responseData['text'],
        );
        print("ADD MESSAGE ${textMessage}");
        _addMessage(textMessage);
        if (response.statusCode != 200) {
          // Handle server error or invalid response
          print('Failed to send message to the backend');
        }
      }
    } catch (e) {
      // Handle network error
      print('Error sending message: $e');
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/chats'));

      if (response.statusCode == 200) {
        List<dynamic> messageList = json.decode(response.body);

        List<types.Message> messages = messageList.map((messageJson) {
          final bool isCurrentUser = messageJson['userId'] == _user.id;

          // Creating a new message object
          return types.TextMessage(
            author: isCurrentUser
                ? _user
                : types.User(
                    id: messageJson[
                        'userId']), // Differentiate between the current user and others
            createdAt: int.parse(messageJson['createdAt']),
            id: messageJson['id'].toString(),
            text: messageJson['text'],
            // You can adjust the status based on your application needs
            status: types.Status.sent,
          );
        }).toList();

        setState(() {
          _messages = messages;
        });
      } else {
        // Handle request error
        print('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching messages: $e');
    }
  }
}
