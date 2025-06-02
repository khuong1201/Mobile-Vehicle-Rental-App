import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_screen.dart';
import 'history_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/images/homePage/home.svg', 'label': 'Home'},
    {'icon': 'assets/images/homePage/history.svg', 'label': 'History'},
    {'icon': 'assets/images/homePage/favorite.svg', 'label': 'Favorite'},
    {'icon': 'assets/images/homePage/profile.svg', 'label': 'Profile'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      HistoryScreen(),
      FavoriteScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double navBarHeight = 70;
    final int itemCount = _navItems.length;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding:EdgeInsets.symmetric(horizontal: 16 ),
        height: navBarHeight,
        color: const Color(0xffD1E4F6),
        child: Row(
          children: List.generate(itemCount, (index) {
            final selected = _selectedIndex == index;
            final item = _navItems[index];
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: selected ? const Color(0xff1976D2) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item['icon']!,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          selected ? const Color(0xff1976D2) : const Color(0xff212121),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label']!,
                        style: TextStyle(
                          color: selected ? const Color(0xff1976D2) : const Color(0xff212121),
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}