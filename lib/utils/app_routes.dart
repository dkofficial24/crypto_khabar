
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/dashboard/page/news_details_page.dart';
import 'package:crypto_khabar/dashboard/page/top_news_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String Dashboard = "dashboard_page";
  static const String NewsDetailsPage = "NewsDetailsPage";
  static const String TopNewsPage = "TopNewsPage";
}

Map<String, WidgetBuilder> routes = {
  AppRoutes.Dashboard: (context) => DashboardPage(),
  AppRoutes.NewsDetailsPage: (context) => NewsDetailsPage(),
  AppRoutes.TopNewsPage: (context) => TopNewsPage(),
};
