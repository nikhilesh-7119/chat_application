class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? timeStamp;
  String? readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;

  ChatModel({
    this.id,
    this.message,
    this.senderName,
    this.senderId,
    this.receiverId,
    this.timeStamp,
    this.readStatus,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    this.reactions,
    this.replies,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      senderName: json['senderName'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timeStamp: json['timeStamp'],
      readStatus: json['readStatus'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      documentUrl: json['documentUrl'],
      reactions: List<String>.from(json['reactions'] ?? []),
      replies: List<dynamic>.from(json['replies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    _data['id'] = id;
    _data['message'] = message;
    _data['senderName'] = senderName;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    _data['timeStamp'] = timeStamp;
    _data['readStatus'] = readStatus;
    _data['imageUrl'] = imageUrl;
    _data['videoUrl'] = videoUrl;
    _data['audioUrl'] = audioUrl;
    _data['documentUrl'] = documentUrl;
    _data['reactions'] = reactions;
    _data['replies'] = replies;

    if (reactions != null) {
      _data['reactions'] = reactions;
    }
    if (replies != null) {
      _data['replies'] = replies;
    }
    return _data;
  }
}
