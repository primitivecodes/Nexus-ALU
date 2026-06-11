import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_feed_screen.dart';
import 'my_events_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'post_opportunity_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tab = 0;

  final _screens = const [
    HomeFeedScreen(),
    MyEventsScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  void _onTabChanged(int idx) => setState(() => _tab = idx);

  Future<void> _openPostScreen() async {
    final posted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const PostOpportunityScreen()),
    );
    if (posted == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: _openPostScreen,
              backgroundColor: AppColors.accent,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              elevation: 4,
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: _onTabChanged,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline_rounded),
              activeIcon: Icon(Icons.bookmark_rounded),
              label: 'My Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
