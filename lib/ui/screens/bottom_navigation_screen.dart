import 'package:flutter/material.dart';
import 'package:ads_app/ui/screens/home_screen/home_screen.dart';
import 'package:ads_app/shared_widgets/app_bottom_navigation.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  BottomNavItem currentTab = BottomNavItem.home;


  final Map<BottomNavItem, Widget> screens = {
    BottomNavItem.home: const HomeScreen(),

    BottomNavItem.messages: const Center(
      child: Text("الرسائل", style: TextStyle(fontSize: 30)),
    ),
    BottomNavItem.add: const Center(
      child: Text("الإضافة", style: TextStyle(fontSize: 30)),
    ),
    BottomNavItem.saved: const Center(
      child: Text("المحفوظات", style: TextStyle(fontSize: 30)),
    ),
    BottomNavItem.profile: const Center(
      child: Text("الملف الشخصي", style: TextStyle(fontSize: 30)),
    ),
  };

  void _onNavItemTap(int index) {
    setState(() {
      currentTab = BottomNavItem.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: currentTab.index,
          children:
              BottomNavItem.values.map((item) => screens[item]!).toList(),
        ),

        bottomNavigationBar: AppBottomNavigation(
          currentTab: currentTab,
          onTap: _onNavItemTap,
        ),
      ),
    );
  }
}
