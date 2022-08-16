import 'package:crypto_khabar/article/page/article_page.dart';
import 'package:crypto_khabar/dashboard/page/top_news_page.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/market/page/market_tab_screen.dart';
import 'package:crypto_khabar/profile/page/profile_page.dart';
import 'package:crypto_khabar/app_update/service/app_update_helper.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    MarketTabScreen(),
    ProfilePage(),
  ];

  @override
  void initState() {
    NewsService();
    FirebaseAnalytics.instance.logEvent(name: 'dashboard');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppUpdateHelper().checkLatestUpdate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTabSelect,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: StringConst.homeTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: StringConst.learnTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: StringConst.marketTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: StringConst.settingTab,
          ),
        ],
      ),
    );
  }

  void onTabSelect(int index) {
    setState(() {
      _selectedIndex = index;
      String tabName = "";
      if (_selectedIndex == 0) {
        tabName = "tab_home";
      } else if (_selectedIndex == 1) {
        tabName = "tab_learn";
      } else if (_selectedIndex == 2) {
        tabName = "tab_market";
      } else if (_selectedIndex == 3) {
        tabName = "tab_setting";
      }
      FirebaseAnalytics.instance.logEvent(name: tabName);
    });
    uploadTabAnalytics(index);
  }

  void uploadTabAnalytics(int index) {
    String tabName = "";
    if (index == 0) {
      tabName = "tab_home";
    } else if (index == 1) {
      tabName = "tab_learn";
    } else if (index == 2) {
      tabName = "tab_market";
    } else if (index == 3) {
      tabName = "tab_setting";
    }
    FirebaseAnalytics.instance.logEvent(name: tabName);
  }
}
