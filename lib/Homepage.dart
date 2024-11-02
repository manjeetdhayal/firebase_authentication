import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication/Model/UserProfile.dart';
import 'package:firebase_authentication/Firebase/Database.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<UserProfile> userProfiles = [];
  final likes = [];
  final Map<String, int> likesContainer = {};
  final dislikes = [];

  //get all user profiles except the logged-in user
  void _getAllUsers() async {
    List<UserProfile> users = [];
    List<UserProfile> allUsers = [];
    try {
      List<DocumentSnapshot> docs = await Database().getAllUsers();
      allUsers = docs.map((doc) => UserProfile.fromDocument(doc)).toList();
      String loggedInUserEmail = await Database().getUserEmail();
      for (UserProfile user in allUsers) {
        if (user.email != loggedInUserEmail) {
          users.add(user);
          print(user);
        }
      }
    } catch (e) {
      print('Error getting users: $e');
    }
    setState(() {
      userProfiles.clear();
      userProfiles.addAll(users);
    });
  }

  //on page load call getAllUsers()
  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  //Insert it in populate firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hey, ${widget.userName}'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Database().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userProfiles.length,
        itemBuilder: (context, index) {
          UserProfile userProfile = userProfiles[index];
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(userProfile.name, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String result) {
                        if (result == 'View Profile') {
                          Navigator.pushNamed(context, '/userProfile', arguments: userProfile);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'View Profile',
                          child: Text('View Profile'),
                        ),
                      ],
                    ),
                  ),
                  (userProfiles[index].imageUrl != '') ? Image.network(
                    userProfile.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ) : Container(
                    width: double.infinity,
                    height: 250,
                    child: Center(child: Text(userProfiles[index].name[0])),
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.thumb_up, color: userProfile.isLiked ? Colors.green : Colors.grey),
                            onPressed: () async {
                              setState(() {
                                userProfile.isLiked = !userProfile.isLiked;
                              });
                              await Database().updateLikes(userProfile.email, await Database().getUserEmail());
                              _getAllUsers(); // Refresh the list of users
                            },
                          ),
                          Text('${userProfile.like}', style: TextStyle(fontSize: 18.0)),

                          IconButton(
                            icon: Icon(Icons.thumb_down, color: userProfile.isLiked ? Colors.grey : Colors.red),
                            onPressed: () async {
                              print(userProfile.email);
                              setState(() {
                                userProfile.isLiked = !userProfile.isLiked;
                                userProfile.isLiked = false; // Reset like if the user dislikes the profile
                              });
                              await Database().updateDislikes(userProfile.email, await Database().getUserEmail());
                              _getAllUsers(); // Refresh the list of users
                            },
                          ),
                          Text('${userProfile.dislike}', style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}