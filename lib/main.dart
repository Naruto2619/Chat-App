import 'package:chat_app/screens/auth_screen.dart';
import './screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _beige = 0xFFFFB6C1;

    const MaterialColor beige = const MaterialColor(
      _beige,
      const <int, Color>{
        50: const Color(0xFFe0e0e0),
        100: const Color(0xFFb3b3b3),
        200: const Color(0xFF808080),
        300: const Color(0xFF4d4d4d),
        400: const Color(0xFF262626),
        500: const Color(_beige),
        600: const Color(0xFF000000),
        700: const Color(0xFF000000),
        800: const Color(0xFF000000),
        900: const Color(0xFF000000),
      },
    );
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: beige,
        backgroundColor: Colors.pinkAccent,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.deepPurple[400],
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
      themeMode: ThemeMode.dark,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnap) {
          if (userSnap.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
