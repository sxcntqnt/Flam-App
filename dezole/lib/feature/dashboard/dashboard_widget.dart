import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/core/providers/navigation_provider.dart';
import 'package:dezole/feature/chat/chat_widget.dart';
import 'package:dezole/feature/dashboard/homeScreen/home_page_widget.dart';
import 'package:dezole/feature/dashboard/profile/profile_widget.dart';
import 'package:dezole/feature/feed/feed_widget.dart';

class DashboardWidget extends ConsumerWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePageWidget(),
          FeedWidget(),
          ChatWidget(),
          CalendarWidget(),
          ProfileWidget(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: CustomTheme.lightColor,
          boxShadow: [
            BoxShadow(
              color: CustomTheme.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          unselectedFontSize: 12,
          unselectedItemColor: CustomTheme.darkColor.withValues(alpha: 0.7),
          showUnselectedLabels: true,
          selectedFontSize: 13,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          currentIndex: selectedIndex,
          onTap: (index) {
            final tab = BottomNavTab.values[index];
            ref.read(bottomNavProvider.notifier).setTab(tab);
          },
          selectedItemColor: CustomTheme.appColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed_outlined),
              activeIcon: Icon(Icons.dynamic_feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: CustomTheme.lightColor,
        foregroundColor: CustomTheme.darkColor,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Calendar', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
