part of 'edit_bloc.dart';

abstract class EditEvent {}

class EditContactEvent extends EditEvent {
  final ContactData contact;

  EditContactEvent({required this.contact});
}
