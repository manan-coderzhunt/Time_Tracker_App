import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://urbgrylxipemenaobqjd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVyYmdyeWx4aXBlbWVuYW9icWpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk4MTM0MjksImV4cCI6MjAzNTM4OTQyOX0.ikPcEKszf4j1hiIWwMJbPg5TCnUBq6KtqW5GQiqfb3Y',
  );
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
        home: SigninScreen());
  }
}
