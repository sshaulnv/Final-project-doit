import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';

const kColorBlueText = Color(0xFF005691);
const kColorBackground = Color(0x88171717);
const kColorRoundButton = Color(0xFF1976D2);

const kTextFieldInputDecoration = InputDecoration(
  labelText: '',
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(
      color: kColorBlueText,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(
      color: kColorBlueText,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: 2,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: 2,
    ),
  ),
  errorStyle: TextStyle(color: Colors.redAccent),
  labelStyle: TextStyle(
    color: kColorBlueText,
  ),
  hintText: '',
  hintStyle: TextStyle(
    color: kColorBlueText,
  ),
);
const kTextStyleHeader = TextStyle(
  fontSize: 32,
  color: kBottomNavigatorTextBackgroundColor,
  fontFamily: 'LilitaOne',
  letterSpacing: 1,
);
const kTextStyleTextFiled = TextStyle(
  color: kColorBlueText,
  fontSize: 18,
  // fontWeight: FontWeight.w900,
  fontFamily: 'Doppio_One',
  letterSpacing: 0.5,
);

const kMapCameraZoom = 15.0;

const kMaximumPrice = 300;
