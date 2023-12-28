import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/model/mesage.dart';

class ChatServices extends ChangeNotifier {
  // Get instance of auth and Firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send Messages
  Future<void> sendMessage(String receiverId, String message) async {
    // Get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Mesage newMessage = Mesage(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // Sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join(
        "_"); // Combine the ids into a single string to use as a chatroomID

    // Add the new message to the database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get Messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // Construct chat room id from user ids (Sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
