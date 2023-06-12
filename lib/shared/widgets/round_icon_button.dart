import 'package:flutter/material.dart';

import '../../app/theme.dart';

class RoundIconButton extends StatelessWidget {
  final icon;
  final Text text;
  Color color;
  final VoidCallback? onPressed;

  RoundIconButton(
      {required this.icon,
      required this.text,
      this.color = kRoundButtonBackgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 8),
          text,
        ],
      ),
    );
  }
}
