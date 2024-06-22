import 'dart:convert';

class MessageModel {
   final int id;
  final int sender_id;
  final int receiver_id;
  final String message_text;
  final DateTime send_date;
  MessageModel({
    required this.id,
    required this.sender_id,
    required this.receiver_id,
    required this.message_text,
    required this.send_date,
  });



  MessageModel copyWith({
    int? id,
    int? sender_id,
    int? receiver_id,
    String? message_text,
    DateTime? send_date,
  }) {
    return MessageModel(
      id: id?? this.id,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      message_text: message_text ?? this.message_text,
      send_date: send_date ?? this.send_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'message_text': message_text,
      'send_date':  send_date.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      sender_id: map['sender_id'] as int,
      receiver_id: map['receiver_id'] as int,
      message_text: map['message_text'] as String,
      send_date:  DateTime.parse(map['send_date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, sender_id: $sender_id, receiver_id: $receiver_id, message_text: $message_text, send_date: $send_date)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.sender_id == sender_id &&
      other.receiver_id == receiver_id &&
      other.message_text == message_text &&
      other.send_date == send_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      sender_id.hashCode ^
      receiver_id.hashCode ^
      message_text.hashCode ^
      send_date.hashCode;
  }
}