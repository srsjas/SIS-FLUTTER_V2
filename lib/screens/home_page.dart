import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/student.dart';
import 'student_details_page.dart';
import 'add_student_page.dart';
import 'edit_student_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  final DatabaseHelper database =
      DatabaseHelper.instance;

  List<Student> students = [];
  List<Student> filteredStudents = [];

  String searchQuery = '';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  // Load students from SQLite
  Future<void> loadStudents() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result =
          await database.getStudents();

      if (!mounted) return;

      setState(() {
        students = result;
        filteredStudents = result;
        isLoading = false;
      });

      if (searchQuery.isNotEmpty) {
        searchStudents(searchQuery);
      }
    } catch (e) {
      debugPrint(
        'Database error: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Unable to load students.';
      });
    }
  }

  // Search students
  void searchStudents(String query) {
    final lowerQuery =
        query.toLowerCase();

    setState(() {
      searchQuery = query;

      filteredStudents =
          students.where((student) {
        return student.name
                .toLowerCase()
                .contains(lowerQuery) ||
            student.course
                .toLowerCase()
                .contains(lowerQuery);
      }).toList();
    });
  }

  // Add student
  Future<void> addStudent() async {
    final newStudent =
        await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddStudentPage(),
      ),
    );

    if (newStudent != null) {
      await loadStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Student added successfully.',
          ),
        ),
      );
    }
  }

  // Edit student
  Future<void> editStudent(
    Student student,
  ) async {
    final updatedStudent =
        await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditStudentPage(
          student: student,
        ),
      ),
    );

    if (updatedStudent != null) {
      await loadStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Student updated successfully.',
          ),
        ),
      );
    }
  }

  // Delete student
  Future<void> deleteStudent(
    Student student,
  ) async {
    if (student.id == null) {
      return;
    }

    try {
      await database.deleteStudent(
        student.id!,
      );

      await loadStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Student deleted.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to delete student.',
          ),
        ),
      );
    }
  }

  // Delete confirmation
  Future<void> confirmDelete(
    Student student,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Student',
          ),
          content: Text(
            'Are you sure you want to delete ${student.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteStudent(student);
    }
  }

  // Open student details
  void openStudentDetails(
    Student student,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentDetailsPage(
          student: student,
        ),
      ),
    );
  }

  // Loading UI
  Widget buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Error UI
  Widget buildErrorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
            ),

            const SizedBox(height: 16),

            Text(
              errorMessage ??
                  'Unable to load students.',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: loadStudents,
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty UI
 // Empty UI
Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.people_outline,
          size: 70,
        ),

        const SizedBox(height: 16),

        const Text(
          'No students found.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: addStudent,
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Student',
          ),
        ),
      ],
    ),
  );
}

  // Student list
 // Student list with pull-to-refresh
Widget buildStudentList() {
  if (filteredStudents.isEmpty) {
    return const Center(
      child: Text(
        'No students match your search.',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: loadStudents,
    child: ListView.builder(
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${student.course} • Year ${student.yearLevel}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editStudent(student);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    confirmDelete(student);
                  },
                ),
              ],
            ),
            onTap: () {
              openStudentDetails(student);
            },
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Information System',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Search
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              onChanged:
                  searchStudents,
              decoration:
                  InputDecoration(
                labelText:
                    'Search Student',
                hintText:
                    'Search by name or course',
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                suffixIcon:
                    searchQuery
                            .isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchStudents(
                                '',
                              );
                            },
                            icon:
                                const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
                border:
                    const OutlineInputBorder(),
              ),
            ),
          ),

          // Student count
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                'Total Students: ${students.length}',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: isLoading
                ? buildLoadingState()
                : errorMessage != null
                    ? buildErrorState()
                    : students.isEmpty
                        ? buildEmptyState()
                        : buildStudentList(),
          ),
        ],
      ),

      // Add Student
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addStudent,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Student',
        ),
      ),
    );
  }
}