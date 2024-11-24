import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Firebase/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final Database _database = Database();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isPrivate = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySetting();
  }

  Future<void> _loadPrivacySetting() async {
    String email = _auth.currentUser!.email!;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Privacy').doc(email).get();
    setState(() {
      isPrivate = doc['isPrivate'] ?? false;
    });
  }

  Future<void> _updatePrivacySetting(bool value) async {
    String email = _auth.currentUser!.email!;
    await FirebaseFirestore.instance.collection('Privacy').doc(email).set({'isPrivate': value});
    setState(() {
      isPrivate = value;
    });
  }

  Future<void> _saveUsername() async {
    if (_usernameController.text.isNotEmpty) {
      try {
        String email = _auth.currentUser!.email!;
        await _database.updateUserProfile(email, {'name': _usernameController.text});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username updated successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update username: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your username')));
    }
  }

  Future<void> _saveAge() async {
    if (_ageController.text.isNotEmpty) {
      try {
        String email = _auth.currentUser!.email!;
        await _database.updateUserProfile(email, {'age': _ageController.text});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Age updated successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update age: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your age')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                  ),
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.green,),
                    onPressed: _saveUsername,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.green,),
                    onPressed: _saveAge,
                  ),
                ],
              ),
              SwitchListTile(
                title: Text('Private Account'),
                value: isPrivate,
                onChanged: (bool value) {
                  _updatePrivacySetting(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}