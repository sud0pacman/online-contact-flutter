import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_contact_app/src/data/local/contact_data.dart';
import 'package:online_contact_app/src/theme/LightColors.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  bool showPassword = false;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  void addDoc(ContactData contact) async {
    await FirebaseFirestore.instance.collection('contacts').doc(contact.id).set(contact.toMap());

    Fluttertoast.showToast(
      msg: "Added successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context, true);

    // FirebaseFirestore.instance.collection('users').add({'name':'dfs'});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Image.asset(
                "assets/images/add_contact.png",
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            myTextField(_controller1, "Name"),
            const SizedBox(
              height: 16,
            ),
            myTextField(_controller2, "Phone", inputType: TextInputType.phone),
            const SizedBox(
              height: 56,
            ),
            addBtn()
          ],
        ),
      ),
    );
  }

  Widget addBtn() {
    return InkWell(
      onTap: () async{
        if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty)
          {
            final User? user = _auth.currentUser;
            print('User status: $user');
            if (user != null) {
              final contactId = _firestore.collection('users').doc(user.uid).collection('contacts').doc().id;
              final contact = ContactData(
                id: contactId,
                name: _controller1.text,
                phone: _controller2.text,
                email: '',
              );
              try {
                print('Contact info: ${contact.toMap()}');
                addDoc(contact);
              } catch (error) {
                print('Error adding contact: $error');
                Fluttertoast.showToast(
                  msg: "Failed to add contact: $error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            } else {
              print('User not logged in');
              Fluttertoast.showToast(
                msg: "User not logged in",
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
          "Add",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget myTextField(TextEditingController controller, String hint,
      {TextInputType inputType = TextInputType.name}) {
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
        keyboardType: inputType,
        controller: controller,
        maxLength: 30,
        decoration: InputDecoration(
          hintText: hint,
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
              controller.clear();
            },
          ),
          counterText: '', // This hides the character counter
        ),
      ),
    );
  }
}
