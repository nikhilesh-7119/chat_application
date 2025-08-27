import 'package:chat_application/models/chat_model.dart';
import 'package:chat_application/models/user_model.dart';

class ChatRoomModel {
  String? id;
  UserModel? sender;
  UserModel? receiver;
  List<ChatModel>? messages;
  int? unReadMessNo;
  String? lastMessage;
  String? lastMessageTimeStamp;
  String? timeStamp;

  ChatRoomModel({
    this.id,
    this.sender,
    this.receiver,
    this.lastMessage,
    this.lastMessageTimeStamp,
    this.messages,
    this.timeStamp,
    this.unReadMessNo,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      id = json['id'];
    }
    if (json['sender'] is Map) {
      sender = json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender']);
    }
    if (json['receiver'] is Map) {
      receiver = json['receiver'] == null
          ? null
          : UserModel.fromJson(json['receiver']);
    }
    if (json['messages'] is List) {
      messages = json['messages'] ?? [];
    }
    if (json['unReadMessNo'] is int) {
      unReadMessNo = json['unReadMessNo'];
    }
    if (json['lastMessage'] is String) {
      lastMessage = json['lastMessage'];
    }
    if (json['lastMessageTimeStamp'] is String) {
      lastMessageTimeStamp = json['lastMessageTimeStamp'];
    }
    if (json['timeStamp'] is String) {
      timeStamp = json['timeStamp'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['id'] = id;
    _data['lastMessage'] = lastMessage;
    _data['lastMessageTimeStamp'] = lastMessageTimeStamp;
    if (receiver != null) {
      _data['receiver'] = receiver?.toJson();
    }
    if (sender != null) {
      _data['sender'] = sender?.toJson();
    }
    _data['timeStamp'] = timeStamp;
    _data['unReadMessNo'] = unReadMessNo;
    if (messages != null) {
      _data['messages'] = messages;
    }
    return _data;
  }
}
