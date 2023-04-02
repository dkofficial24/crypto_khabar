class AppUpdateConfig {
  String title;
  String content;
  String positiveButton;
  String negativeButton;
  String latestVersion;
  String minimumVersion;
  String appUrl;
  bool shouldUpdateShowDialog;

  AppUpdateType appUpdateType;
  int priority;
  int daysForFlexibleUpdate;

  AppUpdateConfig();

  AppUpdateConfig.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    positiveButton = json['positiveButton'];
    negativeButton = json['negativeButton'];
    latestVersion = json['latestVersion'];
    minimumVersion = json['minimumVersion'];
    appUrl = json['appUrl'] ?? '';
    shouldUpdateShowDialog = json['shouldUpdateShowDialog'] ?? false;
    priority = json['priority'] ?? 1;
    daysForFlexibleUpdate = json['daysForFlexibleUpdate'] ?? -1;
    appUpdateType = json['appUpdateType'] == 1
        ? AppUpdateType.FLEXIBLE
        : AppUpdateType.IMMEDIATE;
  }
}

enum AppUpdateType { FLEXIBLE, IMMEDIATE }
