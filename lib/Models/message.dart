class Message {
  String? msg;
  String? read;
  String? told;
  Type? type;
  String? sent;
  String? fromId;

  Message({this.msg, this.read, this.told, this.type, this.sent, this.fromId});

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['told'] = this.told;
    data['type'] = this.type;
    data['sent'] = this.sent;
    data['fromId'] = this.fromId;
    return data;
  }
}

enum Type { text, image }
