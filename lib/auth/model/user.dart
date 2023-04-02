import 'package:flutter/material.dart';

class User {

  User({@required this.uid,this.name='User',this.joiningDate});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'User';
    uid = json['uid'];
    joiningDate = json['joiningDate'];
  }
  String name='User';
  String uid;
  int joiningDate;

  Map<String, dynamic> toJson() {
    return {'name': name, 'uid': uid, 'joiningDate': joiningDate};
  }
}
