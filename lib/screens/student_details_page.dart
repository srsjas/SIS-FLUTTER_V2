import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentDetailsPage
    extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Student ID: ${student.id}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Name: ${student.name}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Course: ${student.course}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Year Level: ${student.yearLevel}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Email: ${student.email}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}