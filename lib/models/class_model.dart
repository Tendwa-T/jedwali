// ignore_for_file: non_constant_identifier_names

class Classes {
  late String course_code;
  late String course_title;
  late String time;
  late String day;
  late String location;
  late String? id;

  Classes({
    required this.course_code,
    required this.course_title,
    required this.time,
    required this.day,
    required this.location,
    this.id,
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

  Map<String, dynamic> toJson() => {
        'course_code': course_code,
        'course_title': course_title,
        'time': time,
        'day': day,
        'location': location,
        '_id': id,
      };
}
