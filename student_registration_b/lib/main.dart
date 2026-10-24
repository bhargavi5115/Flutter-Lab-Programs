
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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

class _RegistrationPageState
    extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  String? department;
  String? gender;
  bool acceptedTerms = false;

  void submitForm() {
    // Validate all text fields.
    bool isValid = _formKey.currentState!.validate();

    // Validate department and gender.
    if (department == null || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select Department and Gender.',
          ),
        ),
      );
      return;
    }

    // Validate Terms & Conditions.
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept Terms & Conditions.',
          ),
        ),
      );
      return;
    }

    // Submit only if every validation succeeds.
    if (isValid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text(
              'Registration Submitted Successfully',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration Portal'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Registration Form',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Student Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter email';
                  }

                  final emailPattern =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }

                  if (!RegExp(r'^[0-9]{10}$')
                      .hasMatch(value.trim())) {
                    return 'Phone number must contain exactly 10 digits';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Department
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Department *',
                  border: OutlineInputBorder(),
                ),
                initialValue: department,
                items: const [
                  DropdownMenuItem(
                    value: 'CSE',
                    child: Text('CSE'),
                  ),
                  DropdownMenuItem(
                    value: 'ECE',
                    child: Text('ECE'),
                  ),
                  DropdownMenuItem(
                    value: 'EEE',
                    child: Text('EEE'),
                  ),
                  DropdownMenuItem(
                    value: 'IT',
                    child: Text('IT'),
                  ),
                  DropdownMenuItem(
                    value: 'Mechanical',
                    child: Text('Mechanical'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    department = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender
              const Text(
                'Gender *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RadioGroup<String>(
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
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
              if (gender == null)
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Please select gender',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Terms and Conditions
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity:
                    ListTileControlAffinity.leading,
                title: const Text(
                  'I accept the Terms & Conditions *',
                ),
                value: acceptedTerms,
                onChanged: (value) {
                  setState(() {
                    acceptedTerms = value ?? false;
                  });
                },
              ),
              if (!acceptedTerms)
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Acceptance is required before submission.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Submit Registration',
                    style: TextStyle(fontSize: 16),
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
