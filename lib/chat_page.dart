import 'dart:convert';
import 'package:casper/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        // mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    print("handle image selection!!!");
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    print("ERRPOR!!! ${result}");
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
      // Encode to Base64
      String base64Image = base64Encode(bytes);
      // Send to backend
      final formData = FormData.fromMap({
        'name': 'dio',
        'date': DateTime.now().toIso8601String(),
        'file':
            await MultipartFile.fromFile(result.path, filename: result.name),
      });
      final response = await Dio()
          .post('http://localhost:8000/v1/chats/image', data: formData);

      print('WE ARE HERE!!!!!! $response');
      _addMessage(message);
      final _user3 = types.User(id: '1');
      final textMessage = types.TextMessage(
        author: _user3,
        createdAt: 1, // Use the server-provided timestamp
        id: 1.toString(), // Use the server-generated unique ID
        text: 'okay you can go barefoot and i’ll wear my combat boots',
      );
      print("ADD MESSAGE ${textMessage}");
      _addMessage(textMessage);
    }
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.only(top: 50),
                child: Chat(
                  messages: _messages,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,
                  user: _user,
                  theme: DefaultChatTheme(
                    inputBackgroundColor: Colors.blue.shade800,
                    seenIcon: Text(
                      'read',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        body: jsonEncode({'userId': _user.id, 'text': text, 'isTest': true}),
      );
      print("RESPONSE ${response.body}");
      if (response.statusCode == 200) {
        // Assuming the backend returns the message in the same format you need

        final responseJ = await json.decode(response.body);

        final responseData = responseJ["results"];

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

  Future<void> _sendImageToBackend(File imageFile) async {
    try {
      final uri = Uri.parse('http://localhost:8000/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image', // Adjust the field name according to your API endpoint
          imageFile.path,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<void> _pickAndUploadImage() async {
    final File? imageFile = await _pickImage();
    if (imageFile != null) {
      await _sendImageToBackend(imageFile);
    } else {
      print('No image was selected');
    }
  }
}
