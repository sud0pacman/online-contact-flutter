part of 'contacts_bloc.dart';

class ContactsState {
  final List<ContactData> contacts;
  final bool back;

  ContactsState({required this.contacts, required this.back});

  ContactsState copyWith({List<ContactData>? contacts, bool? back}) 
    => ContactsState(
      contacts: contacts ?? this.contacts, 
      back: back ?? this.back
    );

}
