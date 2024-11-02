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
  Future<void> updateLike(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('UserEngagement').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> likes = (userData['likes'] as List<dynamic>).map((item) => item.toString()).toList() ?? [];
    await _firestore.collection('users').doc(uid).update({
      'like': likes.length,
    });
  }

  Future<void> updateDislike(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('UserEngagement').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> dislikes = (userData['dislikes'] as List<dynamic>).map((item) => item.toString()).toList() ?? [];
    await _firestore.collection('users').doc(uid).update({
      'dislike': dislikes.length,
    });
  }

  void updateLikedByMe(String uid, bool isLiked) async {
    await _firestore.collection('users').doc(uid).update({
      'isLiked': isLiked,
    });
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

  Future<void> updateUserProfile(String email, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(email).update(updatedData);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
  Future<void> updateLikes(String uid, String likerUid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('UserEngagement').doc(uid).get();
      if (!doc.exists) {
        // If the document does not exist, create a new one
        await _firestore.collection('UserEngagement').doc(uid).set({
          'likes': [],
          'dislikes': [],
        });
      }
      await _firestore.collection('UserEngagement').doc(uid).update({
        'likes': FieldValue.arrayUnion([likerUid]),
        'dislikes': FieldValue.arrayRemove([likerUid]), // Remove from dislikes if the user likes the profile
      });

      await updateLike(uid);
      await updateDislike(uid);
      updateLikedByMe(uid, true);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Method to update dislikes
  Future<void> updateDislikes(String uid, String dislikerUid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('UserEngagement').doc(uid).get();
      if (!doc.exists) {
        // If the document does not exist, create a new one
        await _firestore.collection('UserEngagement').doc(uid).set({
          'likes': [],
          'dislikes': [],
        });
      }
      await _firestore.collection('UserEngagement').doc(uid).update({
        'dislikes': FieldValue.arrayUnion([dislikerUid]),
        'likes': FieldValue.arrayRemove([dislikerUid]), // Remove from likes if the user dislikes the profile
      });
      await updateLike(uid);
      await updateDislike(uid);
      updateLikedByMe(uid, false);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Method to get likes and dislikes
  Future<DocumentSnapshot?> getUserEngagement(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('UserEngagement').doc(uid).get();
      if (!doc.exists) {
        return null;
      }
      return doc;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  signOut() {
    _auth.signOut();
  }
}