import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? textColor;

  const CustomAppbar({
    super.key,
    required this.title,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          decoration: BoxDecoration(
            color: Color(0xffD1E4F6),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(4),
          child: Icon(Icons.arrow_back, color: Color(0xff1976D2)),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Color(0xff212121),
          fontSize: 28,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Color(0xffFCFCFC),
      elevation: 0,
      centerTitle: true,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
