import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/local/contact_data.dart';

part 'contact_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;

  ContactsBloc() : super(ContactsState(contacts: [], back: false)) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<DeleteContactEvent>(_onDeleteContacts);
    on<LogOutEvent>(_onLogOut);
    on<DeleteAccountEvent>(_deleteAccount);
  }

  void _deleteAccount(DeleteAccountEvent event, Emitter<ContactsState> emit) async {
    await _firestore.collection('users').doc(user!.uid).delete();
    await user!.delete();
    await _auth.signOut();
    emit(state.copyWith(back: true));
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<ContactsState> emit) async {
    await _auth.signOut();
    emit(state.copyWith(back: true));
  }

  Future<void> _onLoadContacts(
      LoadContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(contacts: await getContacts()));
  }

  Future<void> _onDeleteContacts(
      DeleteContactEvent event, Emitter<ContactsState> emit) async {
    print("bloc o'chirish kerak ${event.contact.id}");
    await _firestore.collection('contacts').doc(event.contact.id).delete();
    emit(state.copyWith(contacts: await getContacts()));
  }

  getContacts() async {
    user = _auth.currentUser;
    if (user != null) {
      print(" *************************  user null emas");
      var snapshot = await _firestore.collection('contacts').get();

      for (var contact in snapshot.docs
          .map((doc) => ContactData.fromMap(doc.data()))
          .toList()) {
        print("my name ------------------------------ ${contact.name}");
      }

      return snapshot.docs
          .map((doc) => ContactData.fromMap(doc.data()))
          .toList();
    } else {
      print(" *******************************  user null");
      return [];
    }
  }
}
