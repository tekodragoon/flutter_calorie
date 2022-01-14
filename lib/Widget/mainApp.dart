import 'package:flutter/material.dart';
import 'package:flutter_calorie/Widget/Home.dart';
import 'package:flutter_calorie/Widget/ThemeChanger.dart';

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      initialTheme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      materialAppBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: Home(title: 'Calorie Calculator',),
        );
      },
    );
  }
}