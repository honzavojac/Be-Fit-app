import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/login_supabase/new_password_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordGetToken extends StatefulWidget {
  final VoidCallback? showResetPasswordGetToken;
  final VoidCallback? showNewPasswordPage;

  final Function(String)? setEmail;

  ResetPasswordGetToken({
    this.showResetPasswordGetToken,
    this.showNewPasswordPage,
    this.setEmail,
    super.key,
  });

  @override
  State<ResetPasswordGetToken> createState() => _ResetPasswordGetTokenState();
}

class _ResetPasswordGetTokenState extends State<ResetPasswordGetToken> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    print("reset");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsProvider.getColor2(context),
      appBar: AppBar(
        backgroundColor: ColorsProvider.getColor2(context),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    "Reset your password",
                    style: TextStyle(
                      fontSize: 40,
                      color: ColorsProvider.getColor8(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // color: ColorsProvider.getColor8(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      children: [
                        Text(
                          "Enter your email ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorsProvider.getColor8(context),
                          ),
                        ),
                      ],
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
                  height: 20,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (widget.setEmail != null) {
                              print("set email");
                              widget.setEmail!(_emailController.text.trim());
                            }
                            await supabase.auth.resetPasswordForEmail(
                              '${_emailController.text.trim()}',
                            );
                            widget.showNewPasswordPage!();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ResetPassword(
                            //       email: _emailController.text.trim(),
                            //     ),
                            //   ),
                            // );
                            print("object");
                          } on Exception catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorsProvider.getColor8(context), width: 3),
                            color: ColorsProvider.color_9,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: ColorsProvider.getColor8(context),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.showResetPasswordGetToken!();

                        print("object");
                      },
                      child: Text(
                        "Back to login page",
                        style: TextStyle(
                          color: ColorsProvider.getColor8(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
