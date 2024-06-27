import 'package:flutter/material.dart';
import 'package:online_contact_app/src/data/local/constant.dart';
import 'package:online_contact_app/src/data/model/my_pref.dart';
import 'package:online_contact_app/src/screens/contacts/contacts_screen.dart';
import 'package:online_contact_app/src/screens/sign_in/sign_in_screen.dart';
import 'package:online_contact_app/src/screens/sign_up/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPreferencesHelper _pref = SharedPreferencesHelper();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          // _pref.clear();
          var bool = _pref.getBool(Constants.isVerified);
          return bool == null
              ? const SignUpScreen()
              : bool
                  ? const HomeScreen()
                  : const SignInScreen();
        }),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Image.asset(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.cover,
              "assets/images/splash.png"
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}