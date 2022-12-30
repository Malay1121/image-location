import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_location/main.dart';
import 'package:image_location/screens/homepage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Login'),
          TextField(
            controller: firstNameController,
          ),
          TextField(
            controller: secondNameController,
          ),
          TextField(
            controller: emailController,
          ),
          TextField(
            controller: ageController,
          ),
          TextField(
            controller: passwordController,
          ),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
              getStorage.write(
                  'id', FirebaseAuth.instance.currentUser!.uid.toString());
              getStorage.write('firstName', firstNameController.text);
              getStorage.write('secondName', secondNameController.text);
              getStorage.write('age', ageController.text);
              getStorage.write('image', '');

              await FirebaseFirestore.instance.collection('users').add({
                'firstName': firstNameController.text,
                'secondName': secondNameController.text,
                'age': ageController.text,
                'image': '',
              }).then((value) => HomePage());
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
