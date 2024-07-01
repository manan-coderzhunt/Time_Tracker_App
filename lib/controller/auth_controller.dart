import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:time_tracker_app/screens/Forget_Password_Screen.dart';
import 'package:time_tracker_app/screens/HomePage.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';
import 'package:time_tracker_app/screens/updatePassword.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // void signUp(String email, String password) async {
  //   isLoading.value = true;
  //   try {
  //     final response = await _supabaseClient.auth.signUp(
  //       email: email,
  //       password: password,
  //     );
  //     if (response.user != null) {
  //       Get.snackbar('Success', 'Sign-up successful');
  //     } else {
  //       errorMessage.value = 'Sign-up failed';
  //       Get.snackbar('Error', errorMessage.value);
  //     }
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Get.snackbar('Error', errorMessage.value);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        Get.snackbar('Success', 'Sign-in successful');
        Get.to(NewStopWatch());
      } else {
        errorMessage.value = 'Sign-in failed';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


void ForgetPassword(String email) async {
  isLoading.value = true;
  try {
    final response = await _supabaseClient.auth.resetPasswordForEmail(email);
      Get.snackbar('Success', 'Reset Email Sent Successfully');
  } catch (e) {
    errorMessage.value = e.toString();
    Get.snackbar('Error', errorMessage.value);
  } finally {
    isLoading.value = false;
  }
}

void Updatepassword(String password) async {
  isLoading.value = true;
  try {
    final response = await _supabaseClient.auth.updateUser(UserAttributes(password: password),emailRedirectTo: AutofillHints.email);
  }
  catch(e) {
    errorMessage.value = e.toString();
    Get.snackbar('Error', errorMessage.value);
  } finally {
    isLoading.value = false;
  }
}

void SignoutUser() async {
  isLoading.value = true;
  try {
    final response = await _supabaseClient.auth.signInWithOAuth(OAuthProvider as OAuthProvider, );
    Get.back(result: SigninScreen);
    Get.snackbar('Success', 'Successfully Signed Out');
  }
  catch(e) {
    errorMessage.value = e.toString();
    Get.snackbar('Error', errorMessage.value);
  } finally {
    isLoading.value = false;
  }
}
}