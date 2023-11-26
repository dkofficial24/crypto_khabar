class User {
  User({
    required this.uid,
    this.name = 'User',
    required this.joiningDate,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        uid = json['uid'] as String,
        joiningDate = json['joiningDate'] as int;

  String name = 'User';
  String uid;
  int joiningDate;

  Map<String, dynamic> toJson() {
    return {'name': name, 'uid': uid, 'joiningDate': joiningDate};
  }
}
