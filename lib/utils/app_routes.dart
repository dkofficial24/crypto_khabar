
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/dashboard/page/news_details_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String Dashboard = "dashboard_page";
  static const String NewsDetailsPage = "NewsDetailsPage";
}

Map<String, WidgetBuilder> routes = {
  AppRoutes.Dashboard: (context) => DashboardPage(),
  AppRoutes.NewsDetailsPage: (context) => NewsDetailsPage(),
};
