import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini/Splash.dart';
import 'package:mini/dashscreen.dart';
import 'Signup.dart';
import 'Login.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions( apiKey: "AIzaSyBA7QmnQ4cMOM8hlhQZhhruuiykpT0Ch1I",
          authDomain: "mini-25d5e.firebaseapp.com",
          projectId: "mini-25d5e",
          storageBucket: "mini-25d5e.appspot.com",
          messagingSenderId: "1012625417080",
          appId: "1:1012625417080:web:450b60999902963d36de8d",)
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Signup',
      routes: {
        'Splash': (context) => const MySplash(),
        'Signup': (context) => const MySignup(),
        'Login': (context) => const AuthenticateButton(),
        'Dashscreen': (context) => const Dashscreen(),
      },
  ));

}
