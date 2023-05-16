class ChatUser {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? pushToken;
  String? email;

  ChatUser(
      {this.image,
      this.about,
      this.name,
      this.createdAt,
      this.isOnline,
      this.id,
      this.lastActive,
      this.pushToken,
      this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['isOnline'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['isOnline'] = this.isOnline;
    data['id'] = this.id;
    data['last_active'] = this.lastActive;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}
