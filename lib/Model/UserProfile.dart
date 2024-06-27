import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String name;
  final String email;
  final String age;
  final String hobby;
  final String imageUrl;
  final int like;
  final int dislike;
  bool isLiked = false;

  UserProfile({required this.name, required this.email, required this.age, required this.hobby, required this.isLiked, this.imageUrl = 'https://picsum.photos/seed/picsum/200/300', this.like = 0, this.dislike = 0});
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      age: data['age'] as String? ?? '',
      hobby: data['hobby'] as String? ?? '',
      isLiked: data['isLiked'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String? ?? 'https://picsum.photos/seed/picsum/200/300',
      like: data['like'] as int? ?? 0,
      dislike: data['dislike'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'hobby': hobby,
      'email': email,
      'imageUrl': imageUrl,
      'like': like,
      'dislike': dislike,
      'isLiked': isLiked,
    };
  }
}