import 'package:chat_application/cards/profile_card.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  const DiscoverPage({super.key, required this.students});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    List<String> _selectedFilters = [];
    int _selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Students"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              // final result = await _
              // if (result != null) {
              //   setState(() {
              //     _selectedFilters = result;
              //   });
              // }
            },
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text("Filters"),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          final student = widget.students[index];
          return ProfileCard(
            name: '${student['name']}',
            image: '${student['image']}',
            year: '${student['year']}',
            location: '${student['location']}',
            desc: '${student['desc']}',
          );
        },
      ),
    );
  }
}
