import 'package:flutter/material.dart';
import 'package:to_do_app/auth/auth_service.dart';
import 'package:to_do_app/components/my_button.dart';
import 'package:to_do_app/components/my_textfield.dart';
import 'package:to_do_app/constants/color.dart';


class LoginPage extends StatelessWidget {
  //email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // login method
  void login(BuildContext context) async {
    //auth sevice
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pwController.text);
    }

    // catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  } //bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            const Icon(
              Icons.account_circle,
              size: 80,
              color: tdBlack,
            ),

            const SizedBox(height: 50),

            //welcome back message
            const Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: tdBlack,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            //email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            //pw textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 25),

            //login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 25),

            //register now\
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Not a member?",
                  style:
                      TextStyle(color: tdBlack)),
              GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    "Register now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tdBlue),
                  )),
            ])
          ],
        ),
      ),
    );
  }
}
