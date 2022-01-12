import 'package:crypto_khabar/article/page/article_page.dart';
import 'package:crypto_khabar/dashboard/page/top_news_page.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/profile/page/profile_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

BuildContext globalContext;
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  List<Widget> tabPage = [
    TopNewsPage(),
    ArticlePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    NewsService();
    FirebaseAnalytics.instance.logEvent(name: 'dashboard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTabSelect,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'होम',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'सीखें',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'सेटिंग',
          ),
        ],
      ),
    );
  }

  void onTabSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
