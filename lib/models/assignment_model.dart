class Assignment {
  final String title;
  final String courseCode;
  final String studentID;
  final String dueDate;
  final bool submitted;
  final String? note;
  final String? id;

  Assignment({
    required this.title,
    required this.courseCode,
    required this.studentID,
    required this.dueDate,
    required this.submitted,
    this.note,
    this.id,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "_id": var id,
        "title": String title,
        "course_code": String courseCode,
        "student_id": String studentID,
        "dueDate": var dueDate,
        "submitted": bool submitted,
        "note": String? note,
      } =>
        Assignment(
          id: id,
          title: title,
          courseCode: courseCode,
          studentID: studentID,
          dueDate: dueDate,
          submitted: submitted,
          note: note,
        ),
      _ => throw const FormatException(
          "Failed to Load Classes",
        )
    };
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "course_code": courseCode,
        "student_id": studentID,
        "dueDate": dueDate,
        "submitted": submitted,
        "note": note,
      };
}
