class PostModel {
  String? authorName;
  String? id;
  String? title;
  String? category;
  String? description;
  String? authorId;
  String? createdAt;
  int? responsesCount;

  PostModel({
    this.authorName,
    this.id,
    this.title,
    this.category,
    this.description,
    this.authorId,
    this.createdAt,
    this.responsesCount,
  }) {
    this.responsesCount = responsesCount ?? 0;
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    authorName = json['authorName'];
    id = json['id'];
    title = json['title'];
    category = json['category'];
    description = json['description'];
    authorId = json['authorId'];
    createdAt = json['createdAt'];
    final rc = json['responsesCount'];
    if (rc is int) {
      responsesCount = rc;
    } else if (rc is String) {
      responsesCount = int.tryParse(rc) ?? 0;
    } else {
      responsesCount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['authorName'] = authorName;
    _data['id'] = id;
    _data['title'] = title;
    _data['category'] = category;
    _data['description'] = description;
    _data['authorId'] = authorId;
    _data['createdAt'] = createdAt; // set to server time string when creating
    _data['responsesCount'] = responsesCount; // numeric counter
    return _data;
  }
}
