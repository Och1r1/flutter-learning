import 'package:airbnb_clone/models/user_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';

class Conversation {
  String? id;
  Contact? otherContact;
  List<Message>? messages;
  Message? lastMessage;

  Conversation() {
    messages = [];
  }

  addConversationToFirestore(Contact otherContact) async {
    List<String> userNames = [
      AppConstants.currentUser.getFullName(),
      otherContact.getFullName(),
    ];

    List<String> userIDs = [
      AppConstants.currentUser.id!,
      otherContact.id!,
    ];

    Map<String,dynamic> initialConversationData = {
      'lastMessageDateTime': DateTime.now(),
      'lastMessageText': "",
      'userNames':userNames,
      'userIDs': userIDs,
    };
    DocumentReference reference = await FirebaseFirestore.instance.collection('conversations').add(initialConversationData);
    id = reference.id;
  }

  addMessageToFirestore(String messageText) async {
    Map<String, dynamic> messageData = {
      'dateTime': DateTime.now(),
      'senderID': AppConstants.currentUser.id,
      'text': messageText
    };
    await FirebaseFirestore.instance.collection('conversations/$id/messages').add(messageData);

    Map<String,dynamic> conversationData = {
      'lastMessageDateTime': DateTime.now(),
      'lastMessageText': messageText
    };
    await FirebaseFirestore.instance.doc('conversations/$id').update(conversationData);
  }
}



class Message {
  Contact? sender;
  String? text;
  DateTime? dateTime;

  Message();
}