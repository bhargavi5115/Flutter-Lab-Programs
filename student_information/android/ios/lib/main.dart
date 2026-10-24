import 'package:flutter/material.dart';
import 'student_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information',
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student Information'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),

        backgroundColor: Colors.indigo.shade50,

        body: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(height: 20),

              // First Student
              StudentCard(
                name: 'Rupa',
                branch: 'Computer Science Engineering',
                cgpa: 9.65,
                icon: Icons.person,
              ),

              // Second Student
              StudentCard(
                name: 'Priya',
                branch: 'Electronics and Communication',
                cgpa: 8.90,
                icon: Icons.school,
              ),

              // Third Student
              StudentCard(
                name: 'Rahul',
                branch: 'Information Technology',
                cgpa: 8.50,
                icon: Icons.account_circle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

