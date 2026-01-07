import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/auth/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/auth/data/models/update_password_model.dart';
import 'package:catalyst/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepoImplementation implements AuthRepo {
  final RemoteDataSourceImplementation remoteDataSourceImplementation;
  AuthRepoImplementation({required this.remoteDataSourceImplementation});

  // =================== login ===================
  @override
  Future<Either<Failure, bool>> login(Map<String, dynamic> loginData) async {
    try {
      final isConfirmed = await remoteDataSourceImplementation.login(loginData);
      return Right(isConfirmed);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  // =================== signUp ===================
  @override
  Future<Either<Failure, void>> signUp(Map<String, dynamic> signUpData) async {
    try {
      await remoteDataSourceImplementation.signUp(signUpData);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  // =================== forgotPassword => (send email with reset link) ===================
  @override
  Future<Either<Failure, UpdatePasswordResponseModel>> forgotPassword(
    Map<String, dynamic> forgotPasswordData,
  ) async {
    try {
      final response = await remoteDataSourceImplementation.forgotPassword(
        forgotPasswordData,
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  // =================== resendVerificationEmail ===================
  @override
  Future<Either<Failure, UpdatePasswordResponseModel>> resendVerificationEmail(
    Map<String, dynamic> resendData,
  ) async {
    try {
      final response = await remoteDataSourceImplementation
          .resendVerificationEmail(resendData);
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
