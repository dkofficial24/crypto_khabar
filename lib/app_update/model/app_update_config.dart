class AppUpdateConfig {
  String title;
  String content;
  String positiveButton;
  String negativeButton;
  String latestVersion;
  String minimumVersion;
  String appUrl;
  bool shouldUpdateShowDialog;

  AppUpdateConfig.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    positiveButton = json['positiveButton'];
    negativeButton = json['negativeButton'];
    latestVersion = json['latestVersion'];
    minimumVersion = json['minimumVersion'];
    appUrl = json['appUrl'] ?? '';
    shouldUpdateShowDialog = json['shouldUpdateShowDialog'] ?? false;
  }
}
