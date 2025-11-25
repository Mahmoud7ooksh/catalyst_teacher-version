import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';

abstract class GetMyClassesCubitState {}

final class GetMyClassesCubitInitial extends GetMyClassesCubitState {}

final class GetMyClassesCubitLoading extends GetMyClassesCubitState {}

final class GetMyClassesCubitSuccess extends GetMyClassesCubitState {
  final List<Lesson> response;
  GetMyClassesCubitSuccess({required this.response});
}

final class GetMyClassesCubitError extends GetMyClassesCubitState {
  final String message;
  GetMyClassesCubitError({required this.message});
}
