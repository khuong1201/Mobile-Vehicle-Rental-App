import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? textColor;
  final Color? backgroundColor;
  final double height;

  const CustomAppbar({
    super.key,
    required this.title,
    this.textColor,
    this.backgroundColor,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Color(0xffFCFCFC),
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(top: 24),
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
      title: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? Color(0xff212121),
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevation: 0,
      centerTitle: true,
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(height);
}
