import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassword extends StatefulWidget {
  final String? email;
  final VoidCallback showResetPasswordGetToken;

  const ResetPassword({
    required this.email,
    required this.showResetPasswordGetToken,
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final resetTokenC = TextEditingController();
  bool? isLoading;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsProvider.getColor2(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/gym_google2.png',
                    height: 250,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Enter the code we sent to your email",
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorsProvider.getColor8(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildTextField(_tokenController, "Code"),
                  const SizedBox(height: 5),
                  _buildTextField(_newPasswordController, "New password", obscureText: true),
                  const SizedBox(height: 20),
                  _buildSignInButton("Save password"),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.showResetPasswordGetToken();
                      print("object");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Back to previous page",
                          style: TextStyle(
                            color: ColorsProvider.getColor8(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Padding(
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
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.getColor2(context)),
            ),
            cursorColor: ColorsProvider.getColor2(context),
            style: TextStyle(color: ColorsProvider.getColor2(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: GestureDetector(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            isLoading = true;
            showGeneralDialog(
              context: context,
              pageBuilder: (context, animation, secondaryAnimation) => Center(child: CircularProgressIndicator()),
            );
            try {
              final recovery = await supabase.auth.verifyOTP(
                email: widget.email,
                token: _tokenController.text.trim(),
                type: OtpType.recovery,
              );
              print(recovery);
              await supabase.auth.updateUser(
                UserAttributes(password: _newPasswordController.text.trim()),
              );
              isLoading = false;
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushReplacementNamed(context, '/account');
            } catch (e) {}
          } else {}
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
              "$text",
              style: TextStyle(
                color: ColorsProvider.getColor8(context),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
