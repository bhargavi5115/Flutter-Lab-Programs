import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Registration Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? department;
  String gender = 'Male';
  bool acceptedTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void registerStudent() {
    if (_formKey.currentState!.validate()) {
      if (department == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a department'),
          ),
        );
        return;
      }

      if (!acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please accept Terms & Conditions',
            ),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful'),
          content: Text(
            'Name: ${nameController.text}\n'
            'Email: ${emailController.text}\n'
            'Phone: ${phoneController.text}\n'
            'Department: $department\n'
            'Gender: $gender',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration Portal'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      'Student Registration Form',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Student Name
                  const Text('Student Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Email
                  const Text('Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Phone Number
                  const Text('Phone Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: 'Enter 10-digit phone number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^[0-9]{10}$')
                              .hasMatch(value.trim())) {
                        return 'Enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Department
                  const Text('Department'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: department,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                      hintText: 'Select department',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CSE',
                        child: Text(
                          'Computer Science Engineering',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'ECE',
                        child: Text(
                          'Electronics and Communication',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'EEE',
                        child: Text(
                          'Electrical and Electronics',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'IT',
                        child: Text(
                          'Information Technology',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'MECH',
                        child: Text('Mechanical Engineering'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        department = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  // Gender
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RadioGroup<String>(
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('Male'),
                          value: 'Male',
                        ),
                        RadioListTile<String>(
                          title: Text('Female'),
                          value: 'Female',
                        ),
                        RadioListTile<String>(
                          title: Text('Other'),
                          value: 'Other',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Terms and Conditions
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity:
                        ListTileControlAffinity.leading,
                    title: const Text(
                      'I accept the Terms & Conditions',
                    ),
                    value: acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        acceptedTerms = value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registerStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
