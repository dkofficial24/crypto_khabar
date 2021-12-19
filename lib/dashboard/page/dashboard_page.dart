import 'package:crypto_khabar/dashboard/page/top_news_page.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/learn/page/learn_page.dart';
import 'package:crypto_khabar/profile/page/profile_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  List<Widget> tabPage = [
    TopNewsPage(),
    LearnPage(),
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
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTabSelect,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
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
