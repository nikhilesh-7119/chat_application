import 'package:chat_application/cards/profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.016;
    final appBarTitleFontSize = screenWidth * 0.054;
    final filterFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover Students",
          style: TextStyle(
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding * 0.7,
                horizontal: horizontalPadding,
              ),
            ),
            onPressed: () async {
              // Implement your filter logic here if needed
            },
            icon: Icon(Icons.filter_list, size: filterFontSize),
            label: Text("Filters", style: TextStyle(fontSize: filterFontSize)),
          ),
          SizedBox(width: horizontalPadding * 0.7),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No users found",
                style: TextStyle(fontSize: appBarTitleFontSize),
              ),
            );
          }
          final List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(horizontalPadding),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data()! as Map<String, dynamic>;

              return Padding(
                padding: EdgeInsets.only(bottom: verticalPadding * 1.2),
                child: ProfileCard(
                  name: data['name'] ?? 'Unnamed',
                  image: data['image'] ?? '',
                  year: data['year'] ?? '',
                  location: data['location'] ?? '',
                  desc: data['desc'] ?? '',
                  // Optionally pass responsiveness params to ProfileCard here
                ),
              );
            },
          );
        },
      ),
    );
  }
}
