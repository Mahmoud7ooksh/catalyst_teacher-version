import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/auth/data/models/update_password_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, bool>> login(Map<String, dynamic> loginData);
  Future<Either<Failure, void>> signUp(Map<String, dynamic> signUpData);
  Future<Either<Failure, UpdatePasswordResponseModel>> forgotPassword(
    Map<String, dynamic> forgotPasswordData,
  );
  Future<Either<Failure, UpdatePasswordResponseModel>> resendVerificationEmail(
    Map<String, dynamic> resendData,
  );
}
