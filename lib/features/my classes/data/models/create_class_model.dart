// lib/features/my_classes/data/models/create_class_model.dart

class CreateClassRequest {
  final String subject;
  final List<LessonSchedule> lessonSchedules;

  CreateClassRequest({required this.subject, required this.lessonSchedules});

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'lessonSchedules': lessonSchedules.map((s) => s.toJson()).toList(),
    };
  }

  factory CreateClassRequest.fromJson(Map<String, dynamic> json) {
    return CreateClassRequest(
      subject: json['subject'] ?? '',
      lessonSchedules:
          (json['lessonSchedules'] as List?)
              ?.map((s) => LessonSchedule.fromJson(s))
              .toList() ??
          [],
    );
  }
}

// New class for individual lesson schedule
class LessonSchedule {
  final String day; // "Monday", "Friday", etc.
  final int duration; // in minutes
  final String startTime; // "10:00:00"

  LessonSchedule({
    required this.day,
    required this.duration,
    required this.startTime,
  });

  Map<String, dynamic> toJson() {
    return {'day': day, 'duration': duration, 'startTime': startTime};
  }

  factory LessonSchedule.fromJson(Map<String, dynamic> json) {
    return LessonSchedule(
      day: json['day'] ?? '',
      duration: json['duration'] ?? 60,
      startTime: json['startTime'] ?? '00:00:00',
    );
  }
}

class CreateClassResponse {
  final int id;
  final String subject;
  final Teacher teacher;

  CreateClassResponse({
    required this.id,
    required this.subject,
    required this.teacher,
  });

  factory CreateClassResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] ?? json;
    return CreateClassResponse(
      id: payload['id'] ?? 0,
      subject: payload['subject'] ?? '',
      teacher: Teacher.fromJson(
        payload['teacher'] is Map ? payload['teacher'] : {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'subject': subject, 'teacher': teacher.toJson()};
  }
}

class Teacher {
  final int id;
  final String? fullName;
  final String? email;
  final String? password;
  // ... (omitting fields for brevity in ReplacementContent if allowed, but I'll provide full block)
  final String? resetPasswordToken;
  final String? resetPasswordTokenExpiry;
  final String? createdAt;
  final String? updatedAt;
  final String? role;

  Teacher({
    required this.id,
    this.fullName,
    this.email,
    this.password,
    this.resetPasswordToken,
    this.resetPasswordTokenExpiry,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? json['full_name'] ?? json['name'],
      email: json['email'],
      password: json['password'],
      resetPasswordToken:
          json['reset_password_token'] ?? json['resetPasswordToken'],
      resetPasswordTokenExpiry:
          json['reset_password_token_expiry'] ??
          json['resetPasswordTokenExpiry'],
      createdAt: json['created_at'] ?? json['createdAt'],
      updatedAt: json['updated_at'] ?? json['updatedAt'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'reset_password_token': resetPasswordToken,
      'reset_password_token_expiry': resetPasswordTokenExpiry,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role': role,
    };
  }
}

class Schedule {
  final List<DayOfWeek> days;
  final String startTime; // "08:30"
  final int durationMinutes;

  Schedule({
    required this.days,
    required this.startTime,
    required this.durationMinutes,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<DayOfWeek> days = [];
    final rawDays = json['days'] ?? json['day'] ?? [];
    if (rawDays is List) {
      days = rawDays.map<DayOfWeek>((d) {
        final str = d.toString().toLowerCase();
        switch (str) {
          case 'saturday':
          case 'sat':
            return DayOfWeek.saturday;
          case 'sunday':
          case 'sun':
            return DayOfWeek.sunday;
          case 'monday':
          case 'mon':
            return DayOfWeek.monday;
          case 'tuesday':
          case 'tue':
            return DayOfWeek.tuesday;
          case 'wednesday':
          case 'wed':
            return DayOfWeek.wednesday;
          case 'thursday':
          case 'thu':
            return DayOfWeek.thursday;
          case 'friday':
          case 'fri':
            return DayOfWeek.friday;
          default:
            // fallback: try parse int index (0..6)
            if (d is int && d >= 0 && d <= 6) {
              return DayOfWeek.values[d];
            }
            return DayOfWeek.saturday;
        }
      }).toList();
    }

    return Schedule(
      days: days,
      startTime: json['start_time'] ?? json['startTime'] ?? '00:00',
      durationMinutes:
          (json['duration_minutes'] ?? json['durationMinutes'] ?? 60) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days.map((d) => d.toString().split('.').last).toList(),
      'start_time': startTime,
      'duration_minutes': durationMinutes,
    };
  }
}

enum DayOfWeek {
  saturday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}
