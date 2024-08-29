import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;

    final session = supabase.auth.currentSession;

    if (session != null) {
      var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
      UserSupabase? userSupabase = await dbSupabase.getUser();

      // Check if userSupabase is not null and if the dateOfBirth and country are not null or empty
      if (userSupabase == null) {
        print("initdata");
        Navigator.of(context).pushReplacementNamed('/initData', arguments: [session.user.email]);
      } else {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsProvider.getColor2(context),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/gym.png',
                  height: 300,
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 70,
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.getColor8(context)),
                  ),
                ),
                // LoadingAnimationWidget.staggeredDotsWave(
                //   color: ColorsProvider.getColor8(context),
                //   size: 100,
                // ),
                SizedBox(
                  height: 110,
                ),
                // Text(
                //   "Loading data",
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.getColor8(context)),
                // ),
              ],
            ),
          ],
        ));
  }
}
