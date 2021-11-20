class NewsItem {
  String title;
  String details;
  int date;
  String author;
  String source;
  List<String> imgUrls;

  NewsItem(
      {this.title,
        this.details,
        this.date,
        this.author,
        this.source,
        this.imgUrls});

  NewsItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    details = json['details'];
    date = json['date'];
    author = json['author'];
    source = json['source'];
    imgUrls = json['imgUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['details'] = this.details;
    data['date'] = this.date;
    data['author'] = this.author;
    data['source'] = this.source;
    data['imgUrls'] = this.imgUrls;
    return data;
  }
}