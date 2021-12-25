
import 'package:crypto_khabar/article/page/article_detail_page.dart';
import 'package:crypto_khabar/article/page/article_page.dart';
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/dashboard/page/news_details_page.dart';
import 'package:crypto_khabar/dashboard/page/saved_news_page.dart';
import 'package:crypto_khabar/dashboard/page/top_news_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String Dashboard = "dashboard_page";
  static const String NewsDetailsPage = "NewsDetailsPage";
  static const String TopNewsPage = "TopNewsPage";
  static const String SavedNewsPage = "SavedNewsPage";
  static const String ArticlePage = "ArticlePage";
  static const String ArticleDetailPage = "ArticleDetailPage";
}

Map<String, WidgetBuilder> routes = {
  AppRoutes.Dashboard: (context) => DashboardPage(),
  AppRoutes.NewsDetailsPage: (context) => NewsDetailsPage(),
  AppRoutes.TopNewsPage: (context) => TopNewsPage(),
  AppRoutes.SavedNewsPage: (context) => SavedNewsPage(),
  AppRoutes.ArticlePage: (context) => ArticlePage(),
  AppRoutes.ArticleDetailPage: (context) => ArticleDetailPage(),
};
