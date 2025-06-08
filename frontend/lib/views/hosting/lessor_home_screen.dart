import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';

class LessorHomeScreen extends StatefulWidget {
  const LessorHomeScreen({super.key});
  @override
  State<LessorHomeScreen> createState() => _LessorHomeScreen();
}

class _LessorHomeScreen extends State<LessorHomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/images/homePage/home.svg', 'label': 'all'},
    {'icon': 'assets/images/homePage/history.svg', 'label': 'History'},
    {'icon': 'assets/images/homePage/favorite.svg', 'label': 'Favorite'},
    {'icon': 'assets/images/homePage/profile.svg', 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(  
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration:BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.only(
                    bottomLeft:Radius.circular(8),
                    bottomRight:Radius.circular(8)
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: CustomAppbar(title: 'List Your Vehicle'),
                ),
              ),
             

              // Toggle vehicle type
              Container(
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
