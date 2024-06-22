import 'dart:convert';

import 'package:spicetoon_app/models/Chat.dart';

class User {
  String? id;
  String? username;
  String? phone;
  String? password;
  String? role;
  DateTime createdAt;
  DateTime updatedAt;
  List<Chat>?chats;
  User({
    this.id,
    this.username,
    this.phone,
    this.password,
    this.role,
    required this.createdAt,
    required this.updatedAt,
    this.chats
  });
  
  

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      username: map['username'],
      phone: map['phone'],
      password: map['password'],
      role: map['role'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      chats: map['chats']!=null?List<Chat>.from(map['chats'].map((x) => Chat.fromMap(x))):[]
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
