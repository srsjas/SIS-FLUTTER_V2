import 'package:flutter/material.dart';

import 'database/db_factory.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Must run before any database call.
  await initDatabaseFactory();

  runApp(const StudentInformationSystem());
}

class StudentInformationSystem extends StatelessWidget {
  const StudentInformationSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}