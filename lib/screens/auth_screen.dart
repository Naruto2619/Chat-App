import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isloading = false;
  final _auth = FirebaseAuth.instance;
  void _submitform(
    String email,
    String password,
    String username,
    File image,
    bool islogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        isloading = true;
      });
      if (islogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': username, 'email': email, 'imageurl': url});
      }
    } on PlatformException catch (error) {
      setState(() {
        isloading = false;
      });

      var message = 'An Error occured please Check your credentials';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitform, isloading),
    );
  }
}
