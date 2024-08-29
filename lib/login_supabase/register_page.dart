import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? showLoginPage;
  const RegisterPage({
    Key? key,
    this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();

    super.dispose();
  }

  bool passwordConfirmed() {
    // _nameController.text = "test";
    // _emailController.text = "test@gmail.com";
    // _passwordController.text = "123456";
    // _confirmpasswordController.text = "123456";
    if (_passwordController.text.trim() == _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future SignUp() async {
    if (passwordConfirmed()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      //vytvoření uživatele
      final response = await supabase.auth.signUp(email: _emailController.text.trim(), password: _passwordController.text.trim()).catchError(
        (error, stackTrace) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("sing-up failed ${error}"),
              );
            },
          );
        },
      );
      //vložení záznamu do tabulky users
      // await supabase.from("users").insert({'name': '${_nameController.text.trim()}', 'email': '${_emailController.text.trim()}'});
      // vložení defaultních hodnot do intake_categories
      // Získání ID nově registrovaného uživatele
      // Zkontrolujte, zda registrace proběhla úspěšně
      // Zkontrolujte, zda registrace proběhla úspěšně

      //odstranění minulých obrazovek z paměti
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashPage()),
        (Route<dynamic> route) => false,
      );
      print("hotovo");
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("The passwords do not match"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsProvider.getColor2(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/gym.png',
                  height: 250,
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  // color: ColorsProvider.getColor8(context),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: ColorsProvider.getColor8(context),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: ColorsProvider.getColor8(context), width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.getColor2(context)),
                        ),
                        cursorColor: ColorsProvider.getColor2(context),
                        style: TextStyle(color: ColorsProvider.getColor2(context)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: ColorsProvider.getColor8(context), width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.getColor2(context)),
                        ),
                        cursorColor: ColorsProvider.getColor2(context),
                        style: TextStyle(color: ColorsProvider.getColor2(context)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: ColorsProvider.getColor8(context), width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.getColor2(context)),
                        ),
                        cursorColor: ColorsProvider.getColor2(context),
                        style: TextStyle(color: ColorsProvider.getColor2(context)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: GestureDetector(
                    onTap: SignUp,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorsProvider.getColor8(context), width: 3),
                        color: ColorsProvider.color_9,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: ColorsProvider.getColor8(context), fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: ColorsProvider.getColor8(context)),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: ColorsProvider.getColor8(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
