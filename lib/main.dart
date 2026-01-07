import 'dart:io';

import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:catalyst/firebase_options.dart';
import 'package:catalyst/core/services/notification_service.dart';

void main() async {
  // ensure flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // init hive
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(ExamInfoAdapter());
  Hive.registerAdapter(QuestionTypeAdapter());
  Hive.registerAdapter(QuestionAdapter());

  // open boxes
  await Hive.openBox<ExamInfo>(Constant.examInfoKey);
  await Hive.openBox<Question>(Constant.questionsKey);

  // load env
  await dotenv.load(fileName: ".env");

  // init cache
  CacheHelper.init();

  // init service locator
  setupServiceLocator();

  // init firebase
  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // init notification service
  if (!Platform.isLinux) {
    await NotificationService.init();
  }

  // run app
  runApp(const CatalystTeacher());
}

class CatalystTeacher extends StatelessWidget {
  const CatalystTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routs.router,
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      ),
    );
  }
}
