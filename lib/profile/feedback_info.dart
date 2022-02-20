import 'package:flutter/material.dart';

class FeedbackInfo{
  String name;
  String email;
  String review;
  double rating;

  FeedbackInfo({this.name="User",@required this.email,@required this.review,this.rating=-1});

  FeedbackInfo.fromJson(Map<String,dynamic> map){
    name = map['name'] ?? "User";
    email = map['email'];
    review = map['review'] ?? "";
    rating = map['rating'] ?? -1;
  }

  Map<String,dynamic> toJson(){
    return {"name":name,"email":email,"review":review,"rating":rating};
  }

}