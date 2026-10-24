
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String branch;
  final double cgpa;
  final IconData icon;

  const StudentCard({
    super.key,
    required this.name,
    required this.branch,
    required this.cgpa,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        // Student Icon
        leading: Icon(
          icon,
          size: 45,
          color: Colors.indigo,
        ),

        // Student Name
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),

        // Student Details
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Branch: $branch\nCGPA: ${cgpa.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
