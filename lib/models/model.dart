class ChatUser {
  String? image;
  String? name;
  String? about;
  String? createdAt;
  String? id;
  String? lastActive;
  bool? isOnline;
  String? pushToken;
  String? email;

  ChatUser(
      {this.image,
      this.name,
      this.about,
      this.createdAt,
      this.id,
      this.lastActive,
      this.isOnline,
      this.pushToken,
      this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name']?? '';
    about = json['about']?? '';
    createdAt = json['created_at']?? '';
    id = json['id']?? '';
    lastActive = json['last_active']?? '';
    isOnline = json['is_online']?? '';
    pushToken = json['push_token']?? '';
    email = json['email']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}
