import 'package:flutter/material.dart';
import 'package:firebase_authentication/Model/UserProfile.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfile userProfile;

  UserProfilePage({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
}