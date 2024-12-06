import 'package:flutter/material.dart';
import 'package:lyricwave/player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PlayerScreen(),
    );
  }
}

/// In this project we create simple music player app
/// static music player app
/// PROJECT SETUP => DONE
/// FIRST => Ui Create => START
