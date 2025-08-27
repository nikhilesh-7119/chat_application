import 'package:chat_application/screens/chat_page/chat_list.dart';
import 'package:chat_application/screens/discover_screen/discover_page.dart';
import 'package:chat_application/screens/connections_screen/Connections_screen.dart.dart';
import 'package:chat_application/screens/current_profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // UserController userController = Get.put(UserController());
  // FriendConntroller friendConntroller = Get.put(FriendConntroller());
  int _selectedIndex = 0;

  List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    // friendConntroller.addInRequestedList('EMIKtrKv56ae7C3QFvatCApzXEB2');

    // Filter students if filters are applied
    // final filteredStudents = _selectedFilters.isEmpty
    //     ? students
    //     : students
    //         .where((student) => student['tags']
    //             .any((tag) => _selectedFilters.contains(tag)))
    //         .toList();

    final List<Widget> pages = [
      DiscoverPage(),
      ConnectionsScreen(),
      const Center(child: Text("Post Page")),
      ChatList(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() => _selectedIndex = index);
          //for testing purpose only
          // await friendConntroller.addFri('EMIKtrKv56ae7C3QFvatCApzXEB2');
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
