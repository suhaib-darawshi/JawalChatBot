import 'dart:convert';

import 'UserModel.dart';

class Message {
  String? id;
  String? text;
  bool? isSender;
  String? file;
  bool? gpt;
  User? user;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSeen;
  String? notes;
   dynamic index;

  Message({
    this.id,
    this.text,
    this.isSender,
    this.file,
    this.gpt,
    this.user,
    required this.createdAt,
    required this.updatedAt,
     this.isSeen=false,
    this.notes,
    this.index
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'text': text,
      'isSender': isSender,
      'file': file,
      'gpt': gpt,
      'user': user?.toMap(),
      'isSeen': isSeen,
      'notes': notes,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'],
      text: map['text'],
      isSender: map['isSender'],
      file: map['file'],
      gpt: map['gpt'],
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      createdAt:map['createdAt']!=null? DateTime.parse(map['createdAt']):DateTime.now(),
      updatedAt: map['updatedAt']!=null? DateTime.parse(map['updatedAt']):DateTime.now(),
      isSeen: map['isSeen'] ?? false,
      notes: map['notes'],
      index: map['index']
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));
}
