import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_tracker_app/controller/auth_controller.dart';
import 'package:time_tracker_app/screens/Forget_Password_Screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';

class SignUpScreen extends StatelessWidget {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: Get.width-940,
          height: Get.height-160,
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
                SizedBox(height: 30,),
                Image.network(
                  'http://coderzhunt.com/wp-content/uploads/2022/08/logo.png',
                  scale: 3,
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'UserName'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Email'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Get.to(() => SigninScreen());
                      },
                      child: Row(children: [
                        Text('Already Have An Account!',
                          style: TextStyle(

                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),),
                        SizedBox(width: 5),
                        Text('Sign In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),),
                      ],)
                    ),
                  ],
                ),
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
                            onTap: () => _authController.SignUp(_emailController.text,
                                _passwordController.text,
                            _userNameController.text),
                            child: Text(
                              'SIGN UP',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
