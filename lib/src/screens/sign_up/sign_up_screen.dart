import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_contact_app/src/data/local/constant.dart';
import 'package:online_contact_app/src/data/model/my_pref.dart';
import 'package:online_contact_app/src/screens/contacts/contacts_screen.dart';
import 'package:online_contact_app/src/screens/sign_in/sign_in_screen.dart';
import 'package:online_contact_app/src/theme/LightColors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _togglePasswordVisibility1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          Image.asset(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              "assets/images/sign_up.png"),
          const SizedBox(
            height: 56,
          ),
          myTextField(),
          const SizedBox(
            height: 16,
          ),
          myPasswordTextField(
              _passwordController1, _obscureText1, _togglePasswordVisibility1),
          const SizedBox(
            height: 16,
          ),
          myPasswordTextField(
              _passwordController2, _obscureText2, _togglePasswordVisibility2),
          const SizedBox(
            height: 56,
          ),
          signUpButton(context),
          const SizedBox(
            height: 16,
          ),
          haventAccount()
        ],
      ),
    );
  }

  Widget haventAccount() {
    return InkWell(
      onTap: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Center(
        child: Text.rich(TextSpan(
            text: "Do you have an account?",
            style: TextStyle(
              color: Lightcolors.greyText,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                  text: " Log in",
                  style: TextStyle(
                      color: Lightcolors.greyText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold))
            ])),
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    final SharedPreferencesHelper _pref = SharedPreferencesHelper();
    return InkWell(
      onTap: () async {
        if (_passwordController1.text != _passwordController2.text) {
          Fluttertoast.showToast(
            msg: "Passwords do not match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        } else {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _controller.text,
              password: _passwordController1.text,
            );

            _pref.setBool(Constants.isVerified, true);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ContactsScreen()),
              (Route<dynamic> route) => false,
            );
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Registration failed: $e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      },
      child: Container(
        height: 56,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Lightcolors.redButton,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget myPasswordTextField(TextEditingController pswdController,
      bool obscureText, VoidCallback togglePasswordVisibility) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: pswdController,
        maxLength: 30,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: "Password",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E8E93)),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E8E93)),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E8E93)),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: togglePasswordVisibility,
          ),
          counterText: '', // This hides the character counter
        ),
      ),
    );
  }

  Widget myTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black26,
          //   offset: Offset(0, 3),
          //   blurRadius: 5,
          // ),
        ],
      ),
      child: TextField(
        controller: _controller,
        maxLength: 30,
        decoration: InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(color: Lightcolors.tintColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Lightcolors.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Lightcolors.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Lightcolors.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _controller.clear();
            },
          ),
          counterText: '', // This hides the character counter
        ),
      ),
    );
  }
}
