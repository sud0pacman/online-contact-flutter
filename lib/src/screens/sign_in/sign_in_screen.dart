import 'package:flutter/material.dart';
import 'package:online_contact_app/src/screens/contacts/contacts_screen.dart';
import 'package:online_contact_app/src/screens/sign_up/sign_up_screen.dart';
import 'package:online_contact_app/src/theme/LightColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100,),
          Image.asset(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
            "assets/images/sign_in.png"
          ),
          const SizedBox(height: 56,),
          myTextField(),
          const SizedBox(height: 16,),
          myPasswordTextField(),
          const SizedBox(height: 56,),
          logInButton(context),
          const SizedBox(height: 16,),
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
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  (Route<dynamic> route) => false,
            );
      },
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "Don't have an account yet?",
            style: TextStyle(
              color: Lightcolors.greyText,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: " Sign Up here",
                style: TextStyle(
                  color: Lightcolors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )
              )
            ]
          )
        ),
      ),
    );
  }

  Widget logInButton(
    BuildContext context
  ) {
    return InkWell(
      onTap: () async{
        if(_controller.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _controller.text,
              password: _passwordController.text,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ContactsScreen()),
                  (Route<dynamic> route) => false,
            );
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Login failed: $e",
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
        margin: EdgeInsets.symmetric(horizontal: 24,),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Lightcolors.redButton,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          "Log In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
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
          hintStyle: TextStyle(
            color: Lightcolors.tintColor
          ),
          filled: true,
          fillColor: Colors.white,
          border:  OutlineInputBorder(
            borderSide: BorderSide(color: Lightcolors.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Lightcolors.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder:  OutlineInputBorder(
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


  Widget myPasswordTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        maxLength: 30,
        obscureText: _obscureText,
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
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          counterText: '', // This hides the character counter
        ),
      ),
    );
  }
}