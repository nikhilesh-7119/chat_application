import 'package:flutter/material.dart';

Widget buildConnectionCard({
  required String? name,
  required String? university,
  required String? message,
  required List<String>? tags,
  required String? timeAgo,
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
                    name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(university!, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message!),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: tags!
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue.shade50,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(timeAgo!, style: const TextStyle(color: Colors.grey)),
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