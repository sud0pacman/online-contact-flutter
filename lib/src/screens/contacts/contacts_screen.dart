import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_contact_app/src/data/local/constant.dart';
import 'package:online_contact_app/src/data/local/contact_data.dart';
import 'package:online_contact_app/src/data/model/my_pref.dart';
import 'package:online_contact_app/src/screens/add_contact/add_contact_screen.dart';
import 'package:online_contact_app/src/screens/edit_contact/edit_contact.dart';
import 'package:online_contact_app/src/screens/sign_in/sign_in_screen.dart';
import 'package:online_contact_app/src/screens/sign_up/sign_up_screen.dart';
import 'package:online_contact_app/src/theme/LightColors.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;
  List<ContactData> contacts = [];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadContacts();
  }

  void _loadContacts() async {
    if (user != null) {
      var snapshot = await _firestore.collection('contacts').get();
      print(snapshot);
      contacts =
          snapshot.docs.map((doc) => ContactData.fromMap(doc.data())).toList();
      setState(() {});
    }
  }

  void _deleteContact(int index) async {
    if (user != null) {
      print(contacts[index].id);
      var contactId = contacts[index].id;
      await _firestore.collection('contacts').doc(contactId).delete();
      _loadContacts();
    }
  }

  void _logoutContact() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _deleteAccount() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).delete();
      await user!.delete();
      _logoutContact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: myTitle(context),
        ),
        floatingActionButton: myActionButton(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (int i = 0; i < contacts.length; i++)
                contactItem(context, contacts[i], i)
            ],
          ),
        ),
      ),
    );
  }

  Widget myActionButton() {
    return InkWell(
      onTap: () async {
        final newContact = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddContactScreen()),
        );

        if (newContact != null) {
          setState(() {
            _loadContacts();
          });
        }
      },
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              blurRadius: 8,
            ),
          ],
        ),
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Lightcolors.redButton,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/images/ic_plus.png"),
        ),
      ),
    );
  }

  Widget contactItem(
    BuildContext context,
    ContactData contact,
    int index,
  ) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                height: 45,
                width: 45,
                "assets/images/avatar1.png",
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      color: Lightcolors.blackText,
                      fontSize: 14,
                      fontFamily: "NunitoBold",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      color: Lightcolors.greyText,
                      fontSize: 14,
                      fontFamily: "NunitoBold",
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return popUpItem(context, contact, index);
                    },
                  );
                },
                child: Icon(
                  Icons.more_horiz,
                  size: 36,
                  color: Lightcolors.greyIcon,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: .1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Lightcolors.greyDivide,
          ),
        ],
      ),
    );
  }

  Widget popUpItem(BuildContext context, ContactData contact, int index) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              Navigator.pop(context); // Close the modal bottom sheet
              final updatedContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditContactScreen(contactData: contact, index: index),
                ),
              );

              if (updatedContact != null) {
                setState(() {
                  _loadContacts();
                });
              }
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Lightcolors.blackText,
                  fontSize: 14,
                  fontFamily: "NunitoBold",
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context); // Close the modal bottom sheet
              _showDeleteDialog(context, contact, index);
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Lightcolors.blackText,
                  fontSize: 14,
                  fontFamily: "NunitoBold",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogOutDialog(
    BuildContext context,
  ) {
    final _pref = SharedPreferencesHelper();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/logout.png",
                  height: 24,
                  width: 24,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                      color: Lightcolors.greyText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "NunitoBold"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close the modal bottom sheet
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Lightcolors.redButton,
                    size: 24,
                  ),
                )
              ],
            ),
            content: Text(
              "Do you want unregister or logout?",
              style: TextStyle(
                  color: Lightcolors.greyText,
                  fontSize: 14,
                  fontFamily: "NunitoBold"),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      _deleteAccount();
                      _pref.setString(Constants.isVerified, "0");

                      // MyPref.clear();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Lightcolors.redButton, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "Unregister",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "NunitoSemiBold",
                            color: Lightcolors.redButton),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _logoutContact();
                      _pref.setString(Constants.isVerified, "1");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: Lightcolors.redButton,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "NunitoSemiBold",
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  void _showDeleteDialog(
      BuildContext context, ContactData contactData, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text("Delete Contact"),
            ],
          ),
          content: Text(
            "Do you want to delete ${contactData.name}?",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: "NunitoBold",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  contacts.removeAt(index); // Delete the contact
                  _deleteContact(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget myTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "My Contacts",
          style: TextStyle(
            color: Lightcolors.greyText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: () {
            _showLogOutDialog(context);
          },
          child: Image.asset(
            height: 32,
            width: 32,
            "assets/images/logout.png",
          ),
        ),
      ],
    );
  }
}
