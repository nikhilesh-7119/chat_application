import 'package:chat_application/cards/profile_card.dart';
import 'package:chat_application/screens/chats_page.dart';
import 'package:chat_application/screens/connections_screen.dart';
import 'package:chat_application/screens/discover_page.dart';
import 'package:chat_application/screens/post_page.dart';
import 'package:chat_application/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final students = [
    {
      "name": "Alex Chen",
      "year": "MIT • 3rd Year",
      "location": "Boston, MA",
      "desc": "Looking for study partners in ML and data science",
      "tags": ["Python", "Data Science", "Machine Learning"],
      "image": "https://i.pravatar.cc/150?img=3",
    },
    {
      "name": "Sarah Johnson",
      "year": "Stanford • 2nd Year",
      "location": "Palo Alto, CA",
      "desc": "Mobile app developer seeking coding buddies",
      "tags": ["Java", "Mobile Development", "React Native"],
      "image": "https://i.pravatar.cc/150?img=5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DiscoverPage(students: students),
      const ConnectionsScreen(),
      const PostPage(),
      const ChatsPage(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
