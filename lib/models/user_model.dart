class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? bio;
  String? joinedAt;
  String? lastOnlineStatus;
  String? status;
  String? role;
  List<String>? interests;
  List<String>? friends;
  List<String>? requested;
  List<String>? requests;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.bio,
    this.joinedAt,
    this.lastOnlineStatus,
    this.status,
    this.role,
    this.interests ,
    this.friends,
    this.requested,
    this.requests,
  }){
    this.interests=interests ?? [];
    this.friends=friends ?? [];
    this.requested=requested ?? [];
    this.requests=requests ?? [];
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profileImage'];
    bio=json['bio'];
    joinedAt=json['joinedAt'];
    lastOnlineStatus=json['lastOnlineStatus'];
    status=json['status'];
    role=json['role'];
    interests=List<String>.from(json['interests'] ?? []);
    friends=List<String>.from(json['friends'] ?? []);
    requested=List<String>.from(json['requested'] ?? []);
    requests=List<String>.from(json['requests'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['profileImage'] = profileImage;
    _data['bio'] = bio;
    _data['joinedAt'] = joinedAt;
    _data['lastOnlineStatus'] = lastOnlineStatus;
    _data['status'] = status;
    _data['role'] = role;
    _data['interests']=interests;
    _data['friends']=friends;
    _data['requested']=requested;
    _data['requests']=requests;

    return _data;
  }
}
