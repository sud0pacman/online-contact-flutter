import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_contact_app/src/data/local/contact_data.dart';
import 'package:online_contact_app/src/theme/LightColors.dart';

class EditContactScreen extends StatefulWidget {
  final ContactData contactData;
  final int index;

  const EditContactScreen({super.key, required this.contactData, required this.index, });

  @override
  // ignore: no_logic_in_create_state
  State<EditContactScreen> createState() => _EditContactScreenState(contactData);
}

class _EditContactScreenState extends State<EditContactScreen> {
  final ContactData contactData;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool showPassword = false;

  _EditContactScreenState(this.contactData,);

  @override
  void initState() {
    _controller1.text = contactData.name;
    _controller2.text = contactData.phone;
    super.initState();
  }


  Future<void> _updateContact() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final contact = ContactData(
          id: contactData.id,
          name: _controller1.text,
          phone: _controller2.text,
          email: '', // Assuming email is not used here
        );
        await _firestore
            .collection('contacts')
            .doc(contact.id)
            .update(contact.toMap());
        Fluttertoast.showToast(
          msg: "Edited successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to edit contact: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(automaticallyImplyLeading: false,),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 70,),

            Center(
              child: Image.asset(
                "assets/images/edit.png",
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
            ),

            const SizedBox(height: 56,),

            myTextField(
              _controller1,
              "Name"
            ),

            const SizedBox(height: 16,),

            myTextField(
              _controller2,
              "Phone",
              inputType: TextInputType.phone
            ),

            const SizedBox(height: 56,),
            editBtn()
          ],
        ),
      ),
    );
  }

  Widget editBtn() {
    return InkWell(
      onTap: () => {
        if(_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
          _updateContact()
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
          "Update",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget myTextField(
    TextEditingController controller,
    String hint,
    {TextInputType inputType = TextInputType.name}
  ) {
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
              controller.clear();
            },
          ),
          counterText: '', // This hides the character counter
        ),
      ),
    );
  }
}