import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:time_tracker_app/controller/controller.dart';
import 'package:time_tracker_app/screens/HomePage.dart';
import 'package:time_tracker_app/screens/SignIn_screen.dart';


class AuthController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final box = GetStorage();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final NewStopWatchController _newStopWatchController = Get.put(NewStopWatchController());

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        Get.snackbar('Success', 'Sign-in successful');
        box.write('isLogged', true);
        box.write('email', email);
        Get.offAll(NewStopWatch());
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

  Future<void> SignUp(String username, String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response.session != null) {
        Get.snackbar('Success', 'Sign-in successful');
        box.write('isLogged', true);
        box.write('email', email);
        Get.offAll(NewStopWatch());
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


Future<void> ForgetPassword(String email) async {
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

  Future<void> updatePassword(String password) async {
    isLoading.value = true;
    try {
      await _supabaseClient.auth.updateUser(UserAttributes(password: password));
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOutUser() async {
    isLoading.value = true;
    try {
      await _supabaseClient.auth.signOut();
      box.write('isLogged', false);
      box.remove('email');
      Get.offAll(SigninScreen());
      Get.snackbar('Success', 'Successfully signed out');
      _newStopWatchController.timeEntries.clear(); // Clear local time entries
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
