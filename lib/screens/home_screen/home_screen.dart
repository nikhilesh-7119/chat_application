import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(height: 25),
          //custom app bar for this app
          Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 212, 210, 210),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              //this row for space between the custom app bar items
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //for title and home icon
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.home, size: 32),
                        SizedBox(width: 10),
                        Text(
                          'Chat Application',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  //for popup menu bar and more button
                  Container(
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          menuPadding: EdgeInsets.all(0),
                          color: const Color.fromARGB(255, 243, 241, 241),
                          elevation: 5,
                          icon: const Icon(Icons.more_vert, size: 32),
                          onSelected: (value) {
                            if (value == 'settings') {
                              // Handle settings tap
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Settings clicked'),
                                ),
                              );
                            } else if (value == 'logout') {
                              // Handle logout tap
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logout clicked')),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuDivider(height: 1, thickness: 2),
                            const PopupMenuItem(
                              value: 'settings',
                              child: Row(
                                children: [
                                  Icon(Icons.settings),
                                  SizedBox(width: 5),
                                  Text(
                                    'Settings',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(height: 1, thickness: 2),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 5),
                                  Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(height: 1, thickness: 2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            // padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 212, 210, 210),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings clicked')),
                      );
                    },
                    icon: Column(
                      children: [
                        Icon(Icons.search,size: 32,color: Colors.black,),
                        SizedBox(width: 5),
                        Text('Search', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                        Text('Profile', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings clicked')),
                      );
                    },
                    icon: Column(
                      children: [
                        Icon(Icons.person,size: 32,color: Colors.black,),
                        SizedBox(width: 5),
                        Text('Talk to', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                        Text('Friend', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings clicked')),
                      );
                    },
                    icon: Column(
                      children: [
                        Icon(Icons.group,size: 32,color: Colors.black,),
                        SizedBox(width: 5),
                        Text('Search', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                        Text('Groups', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
