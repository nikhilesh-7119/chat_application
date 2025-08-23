import 'package:chat_application/screens/connections_screen/friend_screen/widgets/buildConnectionCard.dart';
import 'package:chat_application/screens/connections_screen/friend_screen/friends_tab.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/screens/connections_screen/requested_screen/requested_tab.dart';
import 'package:chat_application/screens/connections_screen/requests_screen/request_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});

  final FriendConntroller friendController = Get.put(FriendConntroller());

  @override
  Widget build(BuildContext context) {
    // Responsive factors
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double topPadding = screenHeight * 0.045; // for status bar
    final double headerFontSize =
        screenWidth * 0.06; // around 20 on standard mobile
    final double tabFontSize = screenWidth * 0.041; // Tab text font size
    final double tabBarHeight = screenHeight * 0.06;

    return DefaultTabController(
      length: 3, // Friends, Received, Sent
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: topPadding),
                Text(
                  "Connections",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: headerFontSize,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: tabBarHeight,
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    labelStyle: TextStyle(
                      fontSize: tabFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: tabFontSize),
                    tabs: [
                      Tab(
                        text: "Friends (${friendController.friendList.length})",
                      ),
                      Tab(
                        text:
                            "Received (${friendController.requestsList.length})",
                      ),
                      Tab(
                        text: "Sent (${friendController.requestedList.length})",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                friendsTab(context, friendController),
                requestsTab(context, friendController),
                requestedTab(context, friendController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
