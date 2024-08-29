import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/login_supabase/login_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/new_password_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/register_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/reset_password_get_token.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  bool showResetPasswordPage = false;
  bool showNewPasswordPage = false;
  String? email;
  setEmail(String email) {
    this.email = email;
  }

  void deleteEmail() {
    email = null;
  }

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void toggleScreensGetToken() {
    setState(() {
      showResetPasswordPage = !showResetPasswordPage;
    });
  }

  void toggleScreensResetPassword() {
    setState(() {
      showNewPasswordPage = !showNewPasswordPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      if (showResetPasswordPage) {
        if (showNewPasswordPage) {
          print("showNewPasswordPage");
          return ResetPassword(
            email: email,
            showResetPasswordGetToken: toggleScreensResetPassword,
          );
        } else {
          print("showResetPasswordPage");
          deleteEmail();
          return ResetPasswordGetToken(
            setEmail: setEmail,
            showResetPasswordGetToken: toggleScreensGetToken,
            showNewPasswordPage: toggleScreensResetPassword,
          );
        }
      } else {
        return LoginPage(
          showRegisterPage: toggleScreens,
          showResetPasswordPage: toggleScreensGetToken,
        );
      }
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
