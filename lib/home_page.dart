import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/chatpage.dart';
import 'package:messanger/services/auth/authservices.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign user out
  void signOut(BuildContext context) {
    // Get auth services
    final authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 110, 109, 109),
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () => signOut(context), // Pass context here
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  // Build a list of users except the logged-in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>(
                (doc) => _buildUserListItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  // Build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // Display all users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          // Pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserEmail: data['email'],
                receiveUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      // Return an empty container for the current user
      return Container();
    }
  }
}
