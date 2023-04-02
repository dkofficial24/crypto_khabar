class Article {
  String id;
  String title;
  String detail;
  String source;
  String tags;
  String imgUrl;
  String vdoUrl;
  int date;
  String category;

  Article({
    this.id,
    this.title,
    this.detail,
    this.source,
    this.tags,
    this.imgUrl,
    this.vdoUrl,
    this.date,
    this.category
  });

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {};
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

}
