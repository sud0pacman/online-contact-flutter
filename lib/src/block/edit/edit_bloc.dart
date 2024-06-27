import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_contact_app/src/data/local/contact_data.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(EditState(back: false)) {
    on<EditContactEvent>(_onUpdate);
  }

  Future<void> _onUpdate(EditContactEvent event, Emitter<EditState> emit) async {
    var res = await updateContact(event.contact);
    emit(state.copyWith(back: res));
  }

  Future<bool> updateContact(ContactData contactData) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        final contact = ContactData(
          id: contactData.id,
          name: contactData.name,
          phone: contactData.phone,
          email: contactData.email, // Assuming email is not used here
        );
        await firestore
            .collection('contacts')
            .doc(contact.id)
            .update(contact.toMap());

        return true;
      }
    } catch (error) {
      // Log the error if needed
      // print("Failed to edit contact: $error");
      return false;
    }
    return false; // Return false if user is null
  }

}
