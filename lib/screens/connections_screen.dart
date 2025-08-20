import 'package:flutter/material.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Friends, Received, Sent
      child: Column(
        children: [
          // AppBar substitute (since parent Scaffold already exists)
          Container(
            color: Colors.white,
            child: Column(
              children: const [
                SizedBox(height: 40), // for status bar padding
                Text(
                  "Connections",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(text: "Friends (2)"),
                    Tab(text: "Received (0)"),
                    Tab(text: "Sent (0)"),
                  ],
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _friendsTab(),
                const Center(child: Text("No received requests")),
                const Center(child: Text("No sent requests")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _friendsTab() {
  return ListView(
    padding: const EdgeInsets.all(12),
    children: [
      _buildConnectionCard(
        name: "Alex Chen",
        university: "MIT",
        message: "Hey! Want to study ML together?",
        tags: ["Python", "Data Science"],
        timeAgo: "2 hours ago",
        avatar: const CircleAvatar(
          backgroundImage: NetworkImage(
            "https://randomuser.me/api/portraits/men/32.jpg",
          ),
        ),
      ),
      const SizedBox(height: 12),
      _buildConnectionCard(
        name: "Sarah Johnson",
        university: "Stanford",
        message: "Thanks for the React Native tips!",
        tags: ["Mobile Development", "React"],
        timeAgo: "1 day ago",
        avatar: const CircleAvatar(child: Text("S")),
      ),
    ],
  );
}

Widget _buildConnectionCard({
  required String name,
  required String university,
  required String message,
  required List<String> tags,
  required String timeAgo,
  required Widget avatar,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              avatar,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(university, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue.shade50,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(timeAgo, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message, size: 18),
            label: const Text("Message"),
          ),
        ],
      ),
    ),
  );
}
