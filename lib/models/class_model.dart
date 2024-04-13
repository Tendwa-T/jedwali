// ignore_for_file: non_constant_identifier_names

class Classes {
  late String courseCode;
  late String courseTitle;
  late String studentID;
  late String time;
  late String day;
  late String location;
  late String? id;

  Classes({
    required this.courseCode,
    required this.courseTitle,
    required this.time,
    required this.day,
    required this.location,
    required this.studentID,
    this.id,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'course_code': String courseCode,
        'course_title': String courseTitle,
        'time': String time,
        'day': String day,
        'location': String location,
        'student_id': String studentID,
        '_id': var id,
      } =>
        Classes(
          courseCode: courseCode,
          courseTitle: courseTitle,
          time: time,
          day: day,
          location: location,
          studentID: studentID,
          id: id,
        ),
      _ => throw const FormatException("Failed to load classes"),
    };
  }

  Map<String, dynamic> toJson() => {
        'course_code': courseCode,
        'course_title': courseTitle,
        'time': time,
        'day': day,
        'location': location,
        'student_id': studentID,
        '_id': id,
      };
}
