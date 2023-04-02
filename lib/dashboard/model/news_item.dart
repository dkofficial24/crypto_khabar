class NewsItem {

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
        this.sourceLink,
        this.vdoUrl,
        this.showNotification = true,
      });

  NewsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? '';
    details = json['details'] ?? '';
    date = json['date'] ?? 0;
    author = json['author'] ?? '';
    source = json['source'] ?? '';
    imgUrl = json['imgUrl'] ?? '';
    category = json['category'];
    sourceLink = json['sourceLink'] ?? '';
    vdoUrl = json['vdoUrl'] ?? '';
    showNotification = json['showNotification'] ?? true;
   // imgUrls = json['imgUrls']?.cast<String>();
  }
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
  String vdoUrl;
  bool showNotification;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['details'] = details;
    data['date'] = date;
    data['author'] = author;
    data['source'] = source;
    data['imgUrl'] = imgUrl;
   // data['imgUrls'] = this.imgUrls;
    data['category'] = category;
    data['vdoUrl'] = vdoUrl;
    data['sourceLink'] = sourceLink;
    data['showNotification'] = showNotification;
    return data;
  }
}