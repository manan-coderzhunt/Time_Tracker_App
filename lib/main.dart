import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_tracker_app/screens/HomePage.dart';



void main()  {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: NewStopWatch());
  }
}
