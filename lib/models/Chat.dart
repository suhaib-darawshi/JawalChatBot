import 'dart:convert';

import 'Message.dart';

class Chat {
  String? id;
  String? title;
  List<Message> messages;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  Chat({
    this.id,
    this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
     this.isFavorite=false,
  });
  

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'messages': messages.map((x) => x.toMap()).toList(),
      'isFavorite': isFavorite,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['_id'],
      title: map['title'],
      messages:map['messages']!=null? List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))):[],
      createdAt:map['createdAt']!=null? DateTime.parse(map['createdAt']):DateTime.now(),
      updatedAt: map['updatedAt']!=null? DateTime.parse(map['updatedAt']):DateTime.now(),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));
}
