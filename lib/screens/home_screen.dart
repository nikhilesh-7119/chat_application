import 'package:chat_application/cards/profile_card.dart';
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
    {
      "name": "Mike Rodriguez",
      "year": "UC Berkeley • 4th Year",
      "location": "Berkeley, CA",
      "desc": "Full-stack developer preparing for tech interviews",
      "tags": ["JavaScript", "Full Stack", "Node.js"],
      "image": "https://i.pravatar.cc/150?img=7",
    },
    {
      "name": "Emily Davis",
      "year": "CMU • 3rd Year",
      "location": "Pittsburgh, PA",
      "desc": "",
      "tags": [],
      "image": "https://i.pravatar.cc/150?img=8",
    },
  ];

  List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    // Filter students if filters are applied
    // final filteredStudents = _selectedFilters.isEmpty
    //     ? students
    //     : students
    //         .where((student) => student['tags']
    //             .any((tag) => _selectedFilters.contains(tag)))
    //         .toList();

    final List<Widget> pages = [
      // Discover Page
      ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ProfileCard(
            name: '${student['name']}',
            image: '${student['image']}',
            year: '${student['year']}',
            location: '${student['location']}',
            desc: '${student['desc']}',
          );
        },
      ),
      const Center(child: Text("Friends Page")),
      const Center(child: Text("Post Page")),
      const Center(child: Text("Chats Page")),
      const Center(child: Text("Profile Page")),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Discover Students",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedIndex == 0)
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final result = await _showFilterDialog(context);
                if (result != null) {
                  setState(() {
                    _selectedFilters = result;
                  });
                }
              },
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text("Filters"),
            ),
          const SizedBox(width: 12),
        ],
      ),
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

  /// Right-side sliding filter dialog
  Future<List<String>?> _showFilterDialog(BuildContext context) {
    final allInterests = [
      "Python",
      "Java",
      "JavaScript",
      "C++",
      "React",
      "Node.js",
      "Data Science",
      "Machine Learning",
      "AI",
      "Mobile Development",
      "Full Stack",
      "Backend",
      "Frontend",
      "DevOps",
      "Cloud Computing",
    ];

    List<String> selected = List.from(_selectedFilters);

    return showGeneralDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Filter by Interests",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView(
                            children: allInterests.map((interest) {
                              return CheckboxListTile(
                                title: Text(interest),
                                value: selected.contains(interest),
                                onChanged: (bool? value) {
                                  setStateDialog(() {
                                    if (value == true) {
                                      selected.add(interest);
                                    } else {
                                      selected.remove(interest);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, selected),
                          child: const Text("Apply Filters"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), // slide from right
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
