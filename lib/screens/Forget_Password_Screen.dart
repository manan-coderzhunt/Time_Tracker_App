import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_tracker_app/controller/auth_controller.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: Get.width-940,
          height: Get.height-150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () => Get.back(result: SigninScreen()),
                        child: Icon(Icons.navigate_before)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Image.network(
                  'http://coderzhunt.com/wp-content/uploads/2022/08/logo.png',
                  scale: 3,
                ),
                SizedBox(height: 80),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Email'),
                ),
                SizedBox(height: 40),
                SizedBox(height: 40),
                Obx(() {
                  return _authController.isLoading.value
                      ? CircularProgressIndicator()
                      : Column(
                    children: [
                      Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFFD9E48),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () => _authController.ForgetPassword(
                              _emailController.text,
                            ),
                            child: Text(
                              'Send email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 20),
                Obx(() {
                  return _authController.errorMessage.isNotEmpty
                      ? Text(
                    _authController.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                  )
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
