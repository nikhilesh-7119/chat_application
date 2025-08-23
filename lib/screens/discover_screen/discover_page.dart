import 'package:chat_application/screens/discover_screen/widgets/profile_card.dart';
import 'package:chat_application/controllers/discover_controller.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  late final DiscoverController discoverController;
  late final ScrollController _scroll;

  // Keep this State alive when used inside tabbed/persistent navigation
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Create or retrieve the controller exactly once.
    // If you initialize DiscoverController elsewhere (e.g., after OTP), you can just Get.find().
    discoverController = Get.isRegistered<DiscoverController>()
        ? Get.find<DiscoverController>()
        : Get.put(DiscoverController(), permanent: true);

    // Scroll controller to detect near-bottom for pagination.
    _scroll = ScrollController();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        discoverController.loadMore();
      }
    });
  }

  @override
  void dispose() {
    // Do NOT delete the DiscoverController here; we only dispose the ScrollController.
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // important for AutomaticKeepAliveClientMixin
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
              // Optional: open filters
            },
            icon: Icon(Icons.filter_list, size: filterFontSize),
            label: Text("Filters", style: TextStyle(fontSize: filterFontSize)),
          ),
          SizedBox(width: horizontalPadding * 0.7),
        ],
      ),
      body: Obx(() {
        final users = discoverController.discoverUsers;
        final isLoading = discoverController.isLoading.value;
        final isLoadingMore = discoverController.isLoadingMore.value;

        // Initial loading state (only show spinner if list is empty)
        if (isLoading && users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty state after loading
        if (!isLoading && users.isEmpty) {
          return Center(
            child: Text(
              "No users found",
              style: TextStyle(fontSize: appBarTitleFontSize),
            ),
          );
        }

        // Pull-to-refresh: user scrolls to top and swipes down to refetch from page 1
        return RefreshIndicator(
          onRefresh: () async {
            // Reset cursor and reload first page
            await discoverController.refreshDiscover();
          },
          child: ListView.builder(
            controller: _scroll,
            physics:
                const AlwaysScrollableScrollPhysics(), // ensures pull-to-refresh works even if list is short
            padding: EdgeInsets.all(horizontalPadding),
            itemCount: users.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Bottom loader row during pagination
              if (index >= users.length) {
                return Padding(
                  padding: EdgeInsets.only(bottom: verticalPadding * 1.2),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final user = users[index];

              return Padding(
                padding: EdgeInsets.only(bottom: verticalPadding * 1.2),
                child: ProfileCard(
                  // If your ProfileCard supports a full model:
                  userModel: user,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}




// import 'package:chat_application/cards/profile_card.dart';
// import 'package:chat_application/controllers/discover_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DiscoverPage extends StatelessWidget {
//   const DiscoverPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final horizontalPadding = screenWidth * 0.04;
//     final verticalPadding = screenHeight * 0.016;
//     final appBarTitleFontSize = screenWidth * 0.054;
//     final filterFontSize = screenWidth * 0.045;

//     final DiscoverController discoverController =Get.put(DiscoverController());

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Discover Students",
//           style: TextStyle(
//             fontSize: appBarTitleFontSize,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           TextButton.icon(
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.black,
//               backgroundColor: Colors.grey.shade200,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: EdgeInsets.symmetric(
//                 vertical: verticalPadding * 0.7,
//                 horizontal: horizontalPadding,
//               ),
//             ),
//             onPressed: () async {
//               // Implement your filter logic here if needed
//             },
//             icon: Icon(Icons.filter_list, size: filterFontSize),
//             label: Text("Filters", style: TextStyle(fontSize: filterFontSize)),
//           ),
//           SizedBox(width: horizontalPadding * 0.7),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text(
//                 "No users found",
//                 style: TextStyle(fontSize: appBarTitleFontSize),
//               ),
//             );
//           }
//           final List<DocumentSnapshot> docs = snapshot.data!.docs;

//           return ListView.builder(
//             padding: EdgeInsets.all(horizontalPadding),
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data()! as Map<String, dynamic>;

//               return Padding(
//                 padding: EdgeInsets.only(bottom: verticalPadding * 1.2),
//                 child: ProfileCard(
//                   userModel: ,
//                   // Optionally pass responsiveness params to ProfileCard here
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
