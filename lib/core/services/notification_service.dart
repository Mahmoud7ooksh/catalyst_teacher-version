import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static FirebaseMessaging? _firebaseMessaging;

  static Future<String?> init() async {
    if (Platform.isLinux) {
      log('NotificationService: Skipping initialization on Linux');
      return null;
    }

    _firebaseMessaging ??= FirebaseMessaging.instance;

    // Request permission for iOS/Web
    NotificationSettings settings = await _firebaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // Get the token
    String? token = await _firebaseMessaging!.getToken();
    log('FCM Token: $token');
    return token;
  }
}
