import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  static const String _databaseName = 'student_information.db';

  static const int _databaseVersion = 1;

  static const String _tableName = 'students';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB(_databaseName);

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, filePath);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        course TEXT NOT NULL,
        year_level INTEGER NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // Get all students
  Future<List<Student>> getStudents() async {
    final db = await database;

    final result = await db.query(_tableName, orderBy: 'id DESC');

    return result
        .map((map) => Student.fromMap(Map<String, Object?>.from(map)))
        .toList();
  }

  // Insert student
  Future<int> insertStudent(Student student) async {
    final db = await database;

    final data = {
      'name': student.name,
      'course': student.course,
      'year_level': student.yearLevel,
      'email': student.email,
    };

    return await db.insert(_tableName, data);
  }

  // Update student
  Future<int> updateStudent(Student student) async {
    if (student.id == null) {
      throw Exception('Student ID is missing.');
    }

    final db = await database;

    final data = {
      'name': student.name,
      'course': student.course,
      'year_level': student.yearLevel,
      'email': student.email,
    };

    return await db.update(
      _tableName,
      data,
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Delete student
  Future<int> deleteStudent(int id) async {
    final db = await database;

    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;

    await db.close();

    _database = null;
  }
}