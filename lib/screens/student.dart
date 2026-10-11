// class Student {
//   /// null until the database assigns one (AUTOINCREMENT).
//   final int? id;
//   final String name;
//   final String course;
//   final int yearLevel;
//   final String email;

//   const Student({
//     this.id,
//     required this.name,
//     required this.course,
//     required this.yearLevel,
//     required this.email,
//   });

//   /// Object -> database row. Note the column is year_level (snake_case).
//   Map<String, dynamic> toMap() {
//     return {
//       if (id != null) 'id': id,
//       'name': name,
//       'course': course,
//       'year_level': yearLevel,
//       'email': email,
//     };
//   }

//   /// Database row -> object.
//   factory Student.fromMap(Map<String, dynamic> map) {
//     return Student(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       course: map['course'] as String,
//       yearLevel: map['year_level'] as int,
//       email: map['email'] as String,
//     );
//   }
// }
