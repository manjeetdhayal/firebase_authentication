import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Database {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Database({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  //uid will be email id
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  //fetch all user profiles
  Future<List<DocumentSnapshot>> getAllUsers() async {
    try {
      QuerySnapshot users = await _firestore.collection('users').get();
      return users.docs;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<String> getUserName(String uid) async {
    try {
      DocumentSnapshot user = await getUser(uid);
      return user.get('name');
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  //method to updateLike
  void updateLike(String uid, bool isLiked) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isLiked': isLiked,
      });
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  //get logged in user email
  Future<String> getUserEmail() async {
    try {
      return _auth.currentUser!.email!;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}