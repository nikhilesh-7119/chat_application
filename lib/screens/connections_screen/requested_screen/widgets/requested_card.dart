import 'package:flutter/material.dart';

Widget requested_card({
  final String? name,
  final String? university,
  final Widget? avatar,
  final List<String>? skills,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          avatar!,
          const SizedBox(width: 12),

          // Name, University, Skills
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Status (Row)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text('pending', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // University
                Text(
                  university!,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),

                // Skills as Chips
                Wrap(
                  spacing: 6,
                  runSpacing: -6,
                  children: skills!
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: Colors.grey.shade100,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
