import 'dart:core';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ===== postman api url used after the base url which is used in the request =====
class EndPoint {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String signUp = dotenv.env['SIGN_UP']!;
  static final String login = dotenv.env['LOGIN']!;
  static final String resendVerification = dotenv.env['RESEND_VERIFICATION']!;
  static final String forgotPassword = dotenv.env['FORGOT_PASSWORD']!;
  static final String myLessons = dotenv.env['MY_LESSONS']!;
  static final String createClass = dotenv.env['CREATE_CLASS']!;
  static final String pendingRequests = dotenv.env['PENDING_REQUESTS']!;
  static final String approveRequest = dotenv.env['APPROVE_REQUEST']!;
  static final String rejectRequest = dotenv.env['REJECT_REQUEST']!;
  static final String allStudentsInClass = dotenv.env['ALL_STUDENTS_IN_CLASS']!;
  static final String createExam = dotenv.env['CREATE_EXAM']!;
  static final String refreshToken = dotenv.env['REFRESH_TOKEN_ENDPOINT']!;
}

// ===== postman api key used in the request =====
class ApiResponseKeys {
  static final String fullName = dotenv.env['fullName']!;
  static final String email = dotenv.env['email']!;
  static final String password = dotenv.env['password']!;
  static final String token = dotenv.env['token']!;
  static final String id = dotenv.env['id']!;
  static final String type = dotenv.env['type']!;
}

// ===== postman body used in the request =====
class BodyRequest {
  static final String fullName = dotenv.env['fullName']!;
  static final String userName = dotenv.env['userName']!;
  static final String email = dotenv.env['email']!;
  static final String password = dotenv.env['password']!;
}
