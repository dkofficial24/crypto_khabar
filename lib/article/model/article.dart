class Article {

  Article({
    this.id,
    this.title,
    this.detail,
    this.source,
    this.tags,
    this.imgUrl,
    this.vdoUrl,
    this.date,
    this.category,
  });

  Article.fromJson(Map<String,dynamic> map){
    id = map['id'];
    title = map['title'];
    detail = map['detail'];
    source = map['source'];
    tags = map['tags'];
    imgUrl = map['imgUrl'];
    vdoUrl = map['vdoUrl'];
    date = map['date'];
    category = map['category'];
  }
  String id;
  String title;
  String detail;
  String source;
  String tags;
  String imgUrl;
  String vdoUrl;
  int date;
  String category;

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['detail'] = detail;
    map['source'] = source;
    map['tags'] = tags;
    map['imgUrl'] = imgUrl;
    map['vdoUrl'] = vdoUrl;
    map['date'] = date;
    map['category'] = category;
    return map;
  }

}
