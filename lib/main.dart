import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/screens/homepage.dart';
import 'package:noteapp222_firebase/views/screens/auth/login.dart';
import 'package:noteapp222_firebase/views/screens/auth/signup.dart';
import 'package:noteapp222_firebase/views/screens/auth/startpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!
                  .emailVerified) //تعني المستخدم مسجل الدخول وموكد حساب بتاعه
          ? const Homepage()
          : const Login(),
      //home: const StartPage(), //Homepage(), //const StartPage(),
      routes: {
        "startpage": (context) => const StartPage(),
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (congext) => const Homepage(),

        // "addcategories": (context) => AddCategorise(),
        // "filter": (context) => FilterFireStore(),
        // "imagepicker": (context) => ImagePickerS(),
      },
    );
  }
}




//flutter  build apk --release
//noteapp222_firebase
//https://github.com/ammaralkhatib?tab=repositories     مشاريع عمار الخطيب 




//LinkedIn : linkedin.com/in/wajih-hawari-a432a123b
//https://wa.me/+963985976743 : WhatsApp