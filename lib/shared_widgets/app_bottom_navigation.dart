import 'package:flutter/material.dart';

enum BottomNavItem {
  home,
  messages,
  add,
  saved,
  profile;

  IconData get icon {
    switch (this) {
      case BottomNavItem.home:
        return Icons.home_outlined;
      case BottomNavItem.messages:
        return Icons.chat_outlined;
      case BottomNavItem.add:
        return Icons.add_circle_outline;
      case BottomNavItem.saved:
        return Icons.bookmark_outline;
      case BottomNavItem.profile:
        return Icons.person_outline;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case BottomNavItem.home:
        return Icons.home;
      case BottomNavItem.messages:
        return Icons.chat;
      case BottomNavItem.add:
        return Icons.add_circle;
      case BottomNavItem.saved:
        return Icons.bookmark;
      case BottomNavItem.profile:
        return Icons.person;
    }
  }

  String get title {
    switch (this) {
      case BottomNavItem.home:
        return "الرئيسية";
      case BottomNavItem.messages:
        return "الرسائل";
      case BottomNavItem.add:
        return "الإضافة";
      case BottomNavItem.saved:
        return "المحفوظات";
      case BottomNavItem.profile:
        return "الملف الشخصي";
    }
  }
}

class AppBottomNavigation extends StatelessWidget {
  final BottomNavItem currentTab;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff1E2A5A),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        onTap(index);
      },
      items: BottomNavItem.values.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(
            item == currentTab ? item.activeIcon : item.icon,
            size: item == BottomNavItem.add ? 40 : 24,
          ),
          label: item.title,
        );
      }).toList(),
    );
  }
}
