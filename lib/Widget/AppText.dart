import 'package:flutter/material.dart';

class AppText extends Text {

  AppText(String data, {
    color: Colors.black,
    textAlign: TextAlign.center,
    factor: 1.0,
    weight: FontWeight.bold,
    style: FontStyle.normal,
    size: 20.0
  }) : super (
      data,
      textAlign: textAlign,
      textScaleFactor: factor,
      style: TextStyle(
          color: color,
          fontWeight: weight,
          fontSize: size,
          fontStyle: style
      )
  );
}