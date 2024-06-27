part of 'contacts_bloc.dart';

abstract class ContactEvent {}

class LoadContactsEvent extends ContactEvent {}

class AddContactEvent extends ContactEvent {}

class LogOutEvent extends ContactEvent {}

class DeleteAccountEvent extends ContactEvent {}

class DeleteContactEvent extends ContactEvent {
  final ContactData contact;

  DeleteContactEvent(this.contact);
}
