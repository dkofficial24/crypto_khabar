import 'package:flutter/material.dart';

class User {
  String name="User";
  String uid;
  int joiningDate;

  User({@required this.uid,this.name="User",this.joiningDate});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "User";
    uid = json['uid'];
    joiningDate = json['joiningDate'];
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "uid": uid, "joiningDate": joiningDate};
  }
}
