import 'package:flutter/material.dart';

import '../../app/theme.dart';

class SquereIconButton extends StatelessWidget {
  final icon;
  final Text text;
  Color color;
  final VoidCallback? onPressed;

  SquereIconButton(
      {required this.icon,
      required this.text,
      this.color = kBottomNavigatorBackgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 10),
          text,
        ],
      ),
    );
  }
}
