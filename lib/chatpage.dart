import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/components/mytextfield.dart';
import 'package:messanger/services/auth/chat/chatbubbles.dart';
import 'package:messanger/services/auth/chat/chatservices.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveUserID;

  const ChatPage({
    Key? key,
    required this.receiveruserEmail,
    required this.receiveUserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // Only send a message if there's something to send
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiveUserID, _messageController.text);

      // Clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 110, 109, 109),
        title: Text(widget.receiveruserEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(
        _firebaseAuth.currentUser?.uid ??
            '', // Use an empty string if currentUser is null
        widget.receiveUserID,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet.'),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return const SizedBox(); // Handle the case where document data is null
    }

    var alignment = data['senderId'] == _firebaseAuth.currentUser?.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: data['senderId'] == _firebaseAuth.currentUser?.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: data['senderId'] == _firebaseAuth.currentUser?.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail'] ?? 'Unknown Sender'),
            ChatBubble(message: data['message'] ?? 'No Message'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintext: 'Enter message',
            isObsecureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.send,
            size: 18,
          ),
        ),
      ],
    );
  }
}
