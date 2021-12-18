class NewsItem {
  String id;
  String title;
  String details;
  int date;
  String author;
  String source;
  String imgUrl;
  List<String> imgUrls;
  String category;
  String sourceLink;

  NewsItem(
      {
        this.id,
        this.title,
        this.details,
        this.date,
        this.author,
        this.source,
        this.imgUrl,
        this.imgUrls,
        this.category,
        this.sourceLink
      });

  NewsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    details = json['details'];
    date = json['date'];
    author = json['author'];
    source = json['source'];
    imgUrl = json['imgUrl'];
    category = json['category'];
    sourceLink = json['sourceLink'];
    imgUrls = json['imgUrls']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['details'] = this.details;
    data['date'] = this.date;
    data['author'] = this.author;
    data['source'] = this.source;
    data['imgUrl'] = this.imgUrl;
    data['imgUrls'] = this.imgUrls;
    data['category'] = this.category;
    data['sourceLink'] = this.sourceLink;
    return data;
  }
}