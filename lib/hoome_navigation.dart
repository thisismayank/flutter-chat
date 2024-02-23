import 'package:casper/dashboard_screen.dart';
import 'package:casper/profile_page.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart'; // Adjust the import path as needed
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class HomeNavigationScreen extends StatefulWidget {
  @override
  _HomeNavigationScreenState createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int _selectedIndex = 0; // To keep track of the active tab

  // List of widgets for each tab
  final List<Widget> _widgetOptions = [
    DashboardScreen(), // Your dashboard content widget
    const ChatPage(), // Your chat page widget
    ProfileScreen(), // Your profile screen widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const <CurvedNavigationBarItem>[
          CurvedNavigationBarItem(
            child: Icon(Icons.home),
            label: '',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat),
            label: '',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: _onItemTapped,
        color: Colors.blue.shade800,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 246, 247, 248),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        letIndexChange: (index) => true,
      ),
    );
  }
}
