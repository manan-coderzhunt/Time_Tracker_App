import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final resetTokenC = TextEditingController();
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  bool _passwordVisible = true;
  bool? isLoading;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: resetTokenC,
                decoration: const InputDecoration(
                  hintText: 'Reset Token',
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Reset Token!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'Format Email!'
                    : null,
              ),
              TextFormField(
                controller: passwordC,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: _passwordVisible
                        ? Icon(Icons.remove_red_eye_outlined,
                        color: Colors.grey)
                        : Icon(Icons.remove_red_eye_outlined,
                  color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Paasword Is Less Than 6 Characters!';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Center(child: CircularProgressIndicator()),
                    );
                    try {
                      final recovery = await _supabaseClient.auth.verifyOTP(
                        email: emailC.text,
                        token: resetTokenC.text,
                        type: OtpType.recovery,
                      );
                      print(recovery);
                      await _supabaseClient.auth.updateUser(
                        UserAttributes(password: passwordC.text),
                      );
                      isLoading = false;
                      Navigator.of(context, rootNavigator: true).pop();
                      Get.snackbar('Success', 'Reset Email Sent Successfully');
                    } catch (e) {
                    }
                  } else {
                  }
                }, child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}