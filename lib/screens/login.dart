import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
            // onTap: () {
            //   FirebaseFirestore.instance.collection('users').add({
            //     'firstName': firstNameController.text,
            //     'secondName': secondNameController.text,
            //     'age': ageController.text,
            //     'image': '',
            //   }).then((value) => HomePage());
            // },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
