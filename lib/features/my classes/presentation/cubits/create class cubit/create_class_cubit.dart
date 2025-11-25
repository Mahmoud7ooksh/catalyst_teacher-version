import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_state.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:catalyst/core/errors/exceptions.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  CreateClassCubit(this._createClassRepo) : super(CreateClassInitial());
  final MyClassesRepoImpl _createClassRepo;

  final TextEditingController subjectController = TextEditingController();

  Future<void> createClass() async {
    emit(CreateClassLoading());
    Either<Failure, CreateClassResponse> result = await _createClassRepo
        .createClass(
          CreateClassRequest(subject: subjectController.text).toJson(),
        );

    result.fold(
      (failure) => emit(CreateClassError(message: failure.errMessage)),
      (data) {
        emit(CreateClassSuccess(response: data));
      },
    );
  }
}
