import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication/Model/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/Firebase/Database.dart';
class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<UserProfile> userProfiles = [];

  //get all user profiles exvept the loggedin user
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

  //on page load call getAllusers()
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
        title: Text(widget.userName),
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
                        // child: Text('Age: ${userProfile.age}', style: TextStyle(fontSize: 18.0)),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.thumb_up, color: userProfile.isLiked ? Colors.green : Colors.grey),
                            onPressed: () {
                              setState(() {
                                userProfile.isLiked = !userProfile.isLiked;
                              });
                              Database().updateLike(userProfile.email, userProfile.isLiked);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_down, color: userProfile.isLiked ? Colors.grey : Colors.red),
                            onPressed: () {
                              print(userProfile.email);
                              setState(() {
                                userProfile.isLiked = !userProfile.isLiked;
                                userProfile.isLiked = false; // Reset like if the user dislikes the profile
                              });
                              Database().updateLike(userProfile.email, userProfile.isLiked);
                            },
                          ),
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
