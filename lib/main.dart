import 'package:firebase_authentication/Model/UserProfile.dart';
import 'package:firebase_authentication/SettingsPage.dart';
import 'package:firebase_authentication/UserProfilePage.dart';
import 'package:firebase_authentication/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/settings': (context) => SettingsPage(),
        '/userProfile': (context) {
          final UserProfile userProfile = ModalRoute.of(context)!.settings.arguments as UserProfile;
          return UserProfilePage(userProfile: userProfile);
        },
      },
    );
  }
}
