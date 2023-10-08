import 'package:flutter/material.dart';
import 'package:notification_course/screens/home_screen.dart';
import 'package:notification_course/screens/media_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _activeIndex = 0;
  _tapOnbottomNav(int selectedIndex) {
    setState(() {
      _activeIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const HomeScreen();
    switch (_activeIndex) {
      case 0:
        activeScreen = const HomeScreen();
        break;
      case 1:
        activeScreen = const MediaScreen();
        break;
      default:
        activeScreen = const HomeScreen();
    }

    return Scaffold(
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int currentIndex) {
          _tapOnbottomNav(currentIndex);
        },
        currentIndex: _activeIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'HOME',
            activeIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.music_note),
            label: 'MUSIC',
            activeIcon: Icon(
              Icons.music_note,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
