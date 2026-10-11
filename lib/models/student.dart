class Student {
  final int? id;
  final String name;
  final String course;
  final int yearLevel;
  final String email;

  const Student({
    this.id,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.email,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'year_level': yearLevel,
      'email': email,
    };
  }

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      course: map['course'] as String,
      yearLevel: map['year_level'] as int,
      email: map['email'] as String,
    );
  }
}