// import 'package:flutter/material.dart';

// import 'package:kaloricke_tabulky_02/login_supabase/login_page.dart';
// import 'package:kaloricke_tabulky_02/supabase/login_supabase/register_page.dart';

// import '../../login_supabase/reset_password_get_token.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   bool showLoginPage = true;
//   bool showResetPasswordPage = true;

//   void toggleScreens() {
//     setState(() {
//       showLoginPage = !showLoginPage;
//     });
//   }

//   void toggleScreensResetPassword() {
//     setState(() {
//       showResetPasswordPage = !showResetPasswordPage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage) {
//       if (!showResetPasswordPage) {
//         print("showResetPasswordPage");
//         return ResetPasswordGetToken(
//             // showResetPasswordPage: toggleScreensResetPassword,
//             );
//       } else {
//         return LoginPage(
//           showRegisterPage: toggleScreens,
//           showResetPasswordPage: toggleScreensResetPassword,
//         );
//       }
//     } else {
//       return RegisterPage(showLoginPage: toggleScreens);
//     }
//   }
// }
