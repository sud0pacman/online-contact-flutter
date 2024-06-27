part of 'edit_bloc.dart';

class EditState {
  final bool back;

  EditState({required this.back});

  EditState copyWith({bool? back}) {
    return EditState(back: back ?? this.back);
  }
}
