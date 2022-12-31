import 'dart:convert';

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
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await generateFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var doc in getStorage.read('feed') == null
                    ? ['BANzp3KsOVCqCsGcQBKC']
                    : getStorage.read('feed'))
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(doc.id)
                        .get(),
                    builder: ((context, snapshot1) {
                      return Column(
                        children: [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/image-location-1e578.appspot.com/o/${snapshot1.data!.id + snapshot1.data!["creator"]}.png?alt=media',
                          ),
                          Text(snapshot1.data == null
                              ? 'wait'
                              : snapshot1.data!['creator']),
                        ],
                      );
                    }),
                  ),
              ],
            ),
          ),
          // FutureBuilder(
          //     future: FirebaseFirestore.instances
          //         .collection('users')
          //         .doc(getStorage.read('id'))
          //         .collection('feed')
          //         .doc('feed')
          //         .get(),
          //     builder: (BuildContext context, snapshot) {
          //       if (snapshot.hasError) {
          //         return Text("Something went wrong");
          //       }

          //       if (snapshot.hasData && !snapshot.data!.exists) {
          //         return Text(getStorage.read('id'));
          //       }
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         Map<String, dynamic> data =
          //             snapshot.data!.data() as Map<String, dynamic>;
          //         return Text(data.toString());
          //       }
          //       return Text("loading");
          //     }),
        ],
      ),
    );
  }

  Future<void> generateFeed() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getStorage.read('id'))
        .get()
        .then((value) {
      var keys = value.data()!['preferences'];
      for (var key in keys.keys.toList()) {
        FirebaseFirestore.instance
            .collection('posts')
            .where('categories', arrayContains: key.toString())
            .get()
            .then((value) {
          getStorage.write('feed', value.docs);
        });
      }
    });
  }
}
