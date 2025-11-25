import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';

class CreateClassState {}

class CreateClassInitial extends CreateClassState {}

class CreateClassLoading extends CreateClassState {}

class CreateClassSuccess extends CreateClassState {
  final CreateClassResponse response;

  CreateClassSuccess({required this.response});
}

class CreateClassError extends CreateClassState {
  final String message;

  CreateClassError({required this.message});
}
