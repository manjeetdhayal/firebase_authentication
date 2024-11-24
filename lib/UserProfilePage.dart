import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/Model/UserProfile.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfile userProfile;

  UserProfilePage({required this.userProfile});

  Future<bool> _fetchPrivacySetting() async {
    String email = userProfile.email;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Privacy').doc(email).get();
    return doc['isPrivate'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchPrivacySetting(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(userProfile.name),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }  else {
          bool isPrivate = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(
              title: Text(userProfile.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isPrivate
                  ? Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "You don't have access to this user's profile.",
                  style: TextStyle(fontSize: 20),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${userProfile.name}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Email: ${userProfile.email}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Age: ${userProfile.age}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Hobby: ${userProfile.hobby}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  userProfile.imageUrl.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      userProfile.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(),
                  SizedBox(height: 10),
                  Text('Likes count: ${userProfile.like}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Dislikes count: ${userProfile.dislike}', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}