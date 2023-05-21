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
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type.toString().split('.').last;

    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type { text, image }
