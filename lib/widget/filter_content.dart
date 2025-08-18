import 'package:flutter/material.dart';

class FilterContent extends StatefulWidget {
  @override
  State<FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  final List<String> interests = [
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

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: interests.map((interest) {
                return CheckboxListTile(
                  title: Text(interest),
                  value: selected.contains(interest),
                  onChanged: (bool? value) {
                    setState(() {
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
            onPressed: () {
              Navigator.pop(context, selected);
            },
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}
