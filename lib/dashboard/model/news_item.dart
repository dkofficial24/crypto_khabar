class NewsItem {
  NewsItem({
    required this.id,
    this.title = '',
    this.details = '',
    this.date = 0,
    this.author = '',
    this.source = '',
    this.imgUrl = '',
    this.imgUrls = const [],
    required this.category,
    this.sourceLink = '',
    this.vdoUrl = '',
    this.showNotification = true,
  });

  NewsItem.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String? ?? '',
        details = json['details'] as String? ?? '',
        date = json['date'] as int? ?? 0,
        author = json['author'] as String? ?? '',
        source = json['source'] as String? ?? '',
        imgUrl = json['imgUrl'] as String? ?? '',
        imgUrls = (json['imgUrls'] as List?)?.cast<String>() ?? [],
        category = json['category'] as String,
        sourceLink = json['sourceLink'] as String? ?? '',
        vdoUrl = json['vdoUrl'] as String? ?? '',
        showNotification = json['showNotification'] as bool? ?? true;

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
    return {
      'id': id,
      'title': title,
      'details': details,
      'date': date,
      'author': author,
      'source': source,
      'imgUrl': imgUrl,
      'imgUrls': imgUrls,
      'category': category,
      'vdoUrl': vdoUrl,
      'sourceLink': sourceLink,
      'showNotification': showNotification,
    };
  }
}
