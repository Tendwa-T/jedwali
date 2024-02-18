// ignore_for_file: non_constant_identifier_names

class Classes {
  final String course_code;
  final String course_title;
  final String time;
  final String day;
  final String location;
  var id;

  Classes({
    required this.course_code,
    required this.course_title,
    required this.time,
    required this.day,
    required this.location,
    required this.id,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'course_code': String course_code,
        'course_title': String course_title,
        'time': String time,
        'day': String day,
        'location': String location,
        '_id': var id,
      } =>
        Classes(
          course_code: course_code,
          course_title: course_title,
          time: time,
          day: day,
          location: location,
          id: id,
        ),
      _ => throw const FormatException("Failed to load classes"),
    };
  }
}
