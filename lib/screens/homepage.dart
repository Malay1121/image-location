import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_location/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(getStorage.read('id'))
                  .get(),
              builder: (BuildContext context, snapshot) {
                return Text(snapshot.data.toString());
              }),
        ],
      ),
    );
  }
}
