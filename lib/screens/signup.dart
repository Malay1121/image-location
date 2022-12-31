import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_location/main.dart';
import 'package:image_location/screens/homepage.dart';
import 'package:image_location/screens/login.dart';

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
              getStorage.write('email', emailController.text);
              getStorage.write('password', passwordController.text);
              getStorage.write('age', ageController.text);
              getStorage.write('image', '');

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(getStorage.read('id'))
                  .set({
                'firstName': firstNameController.text,
                'secondName': secondNameController.text,
                'age': ageController.text,
                'image': '',
                'preferences': {'all': 100}
              }).then((value) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage())));
            },
            child: Text('Signup'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
