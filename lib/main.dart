import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_tracker_app/controller/auth_controller.dart';
import 'package:time_tracker_app/controller/controller.dart';
import 'package:time_tracker_app/screens/HomePage.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';
import 'package:time_tracker_app/screens/signUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
  final userData = GetStorage();
  final AuthController _authController = Get.put(AuthController());
  final NewStopWatchController _newStopWatchController = Get.put(NewStopWatchController());

  @override
  void initState() {
    super.initState();
    userData.writeIfNull('isLogged', false);

    Future.delayed(Duration.zero, () async {
      checkIfLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = GetStorage();
    if (userData.read('isLogged') == true) {
      final email = userData.read('email');
      if (email != null) {
        _newStopWatchController.setUserEmail(email);
      }
    }
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SigninScreen());
  }

  void checkIfLoggedIn() {
    if (userData.read('isLogged') == true) {
      Get.offAll(() => NewStopWatch());
    } else {
      Get.offAll(() => SigninScreen());
    }
  }
}