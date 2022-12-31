import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_location/main.dart';
import 'package:image_location/screens/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (getStorage.read('id') != null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: getStorage.read('email'),
              password: getStorage.read('password'))
          .then((value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Login'),
          TextField(
            controller: emailController,
          ),
          TextField(
            controller: passwordController,
          ),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((value) {
                getStorage.write(
                    'id', FirebaseAuth.instance.currentUser!.uid.toString());
                getStorage.write('firstName', value['firstName']);
                getStorage.write('secondName', value['secondName']);
                getStorage.write('email', emailController.text);
                getStorage.write('password', passwordController.text);
                getStorage.write('age', value['age']);
                getStorage.write('image', '');
                getStorage.write('age', value['username']);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
