import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/student.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({
    super.key,
  });

  @override
  State<AddStudentPage> createState() =>
      _AddStudentPageState();
}

class _AddStudentPageState
    extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final DatabaseHelper database =
      DatabaseHelper.instance;

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController courseController =
      TextEditingController();

  final TextEditingController yearController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  bool isSaving = false;

  // Save student
  Future<void> saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final student = Student(
        name: nameController.text.trim(),
        course: courseController.text.trim(),
        yearLevel: int.parse(
          yearController.text.trim(),
        ),
        email: emailController.text.trim(),
      );

      await database.insertStudent(student);

      if (!mounted) return;

      Navigator.pop(
        context,
        student,
      );
    } catch (e) {
      if (!mounted) return;

           debugPrint('Failed to save student: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save student: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    yearController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Student',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'Enter student name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter student name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Course
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  hintText: 'Example: BSIT',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter course';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Year Level
              TextFormField(
                controller: yearController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  hintText: 'Example: 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final year = int.tryParse(
                    value ?? '',
                  );

                  if (year == null) {
                    return 'Enter a valid year level';
                  }

                  if (year < 1 || year > 4) {
                    return 'Year level must be 1-4';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'student@example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter email';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isSaving ? null : saveStudent,
                  child: isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              CircularProgressIndicator(),
                        )
                      : const Text(
                          'Save Student',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}