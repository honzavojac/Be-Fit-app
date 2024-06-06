import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? showRegisterPage;
  const LoginPage({
    Key? key,
    this.showRegisterPage,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _redirecting = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> signIn() async {
    // _emailController.text = "test@gmail.com";
    // _passwordController.text = "123456";
    try {
      setState(() {});
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsProvider.color_2,
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
                const SizedBox(height: 40),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_emailController, "Email"),
                const SizedBox(height: 5),
                _buildTextField(_passwordController, "Password", obscureText: true),
                const SizedBox(height: 20),
                _buildSignInButton(),
                const SizedBox(height: 5),
                _buildSignUpOption(),
                const SizedBox(height: 10),
                _buildSignInWithGoogle(),
              ],
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
          border: Border.all(color: Colors.black, width: 4),
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
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.color_2),
            ),
            cursorColor: ColorsProvider.color_2,
            style: TextStyle(color: ColorsProvider.color_2),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: GestureDetector(
        onTap: () async {
          await signIn();
          await dbSupabase.getUser();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              "Sign in",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Not a member? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          if (widget.showRegisterPage != null) // Tady provádíme ověření, zda je showRegisterPage dostupné
            GestureDetector(
              onTap: () {
                widget.showRegisterPage!();
                print("object");
              },
              child: const Text(
                "Register now",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSignInWithGoogle() {
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const Text(
            "or sign in with",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Image(image: AssetImage("assets/google_icon.png")),
              ),
            ),
            onTap: () {
              print("google auth");

              print(dbSupabase.user!.email);
              // AuthService().signInWithGoogle();
            },
          ),
        ],
      ),
    );
  }
}
