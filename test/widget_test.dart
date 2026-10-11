import 'package:flutter_test/flutter_test.dart';
import 'package:student_information_system/models/student.dart';

void main() {
  test('Student toMap / fromMap round trip', () {
    const student = Student(
      id: 1,
      name: 'Juan Dela Cruz',
      course: 'BSIT',
      yearLevel: 2,
      email: 'juan@example.com',
    );

    final copy = Student.fromMap(student.toMap());

    expect(copy.id, 1);
    expect(copy.name, 'Juan Dela Cruz');
    expect(copy.course, 'BSIT');
    expect(copy.yearLevel, 2);
    expect(copy.email, 'juan@example.com');
  });
}