
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Water Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const WaterTrackerPage(),
    );
  }
}

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() =>
      _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  final TextEditingController waterController =
      TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  static const int dailyGoal = 2000;

  List<int> waterEntries = [];
  bool isLoading = true;

  int get totalConsumed =>
      waterEntries.fold(0, (sum, amount) => sum + amount);

  int get remainingWater =>
      (dailyGoal - totalConsumed).clamp(0, dailyGoal);

  double get completionPercentage =>
      (totalConsumed / dailyGoal * 100).clamp(0, 100);

  double get progressValue =>
      (totalConsumed / dailyGoal).clamp(0.0, 1.0);

  String get todayDate {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  @override
  void initState() {
    super.initState();
    loadWaterData();
  }

  // Load today's water entries from local storage.
  Future<void> loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString('water_date');
    final savedEntries = prefs.getString('water_entries');

    List<int> loadedEntries = [];

    if (savedDate == todayDate && savedEntries != null) {
      try {
        loadedEntries =
            (jsonDecode(savedEntries) as List)
                .map((item) => item as int)
                .toList();
      } catch (_) {
        loadedEntries = [];
      }
    }

    if (savedDate != todayDate) {
      await prefs.setString('water_date', todayDate);
      await prefs.setString('water_entries', jsonEncode([]));
    }

    if (!mounted) return;

    setState(() {
      waterEntries = loadedEntries;
      isLoading = false;
    });
  }

  // Save today's entries on the device.
  Future<void> saveWaterData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('water_date', todayDate);
    await prefs.setString(
      'water_entries',
      jsonEncode(waterEntries),
    );
  }

  // Validate and add water intake.
  Future<void> addWater() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final amount = int.parse(waterController.text.trim());

    setState(() {
      waterEntries.add(amount);
      waterController.clear();
    });

    await saveWaterData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$amount mL of water added!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Ask for confirmation before resetting.
  Future<void> confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Water Intake?'),
          content: const Text(
            'Are you sure you want to clear all '
            'water entries recorded today?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;

    setState(() {
      waterEntries.clear();
    });

    await saveWaterData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Water intake has been reset.'),
      ),
    );
  }

  @override
  void dispose() {
    waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Water Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: isLoading ? null : confirmReset,
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset daily intake',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stay Hydrated!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Daily Goal: $dailyGoal mL',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Total consumed card
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Total Water Consumed',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$totalConsumed mL',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${completionPercentage.toStringAsFixed(1)}% completed',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Remaining water and entry count
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          'Remaining',
                          '$remainingWater mL',
                          Icons.local_drink,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(
                          'Entries Today',
                          '${waterEntries.length}',
                          Icons.format_list_numbered,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Add Water Intake',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Water amount form
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: waterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Water amount (mL)',
                        hintText: 'Example: 250',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.water_drop),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter water amount';
                        }

                        final amount = int.tryParse(
                          value.trim(),
                        );

                        if (amount == null) {
                          return 'Enter a valid whole number';
                        }

                        if (amount <= 0) {
                          return 'Water amount must be greater than zero';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: addWater,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Water'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Today's Water Entries",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (waterEntries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No water entries yet. Add your first drink!',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...List.generate(waterEntries.length, (index) {
                      final reverseIndex =
                          waterEntries.length - 1 - index;

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.water_drop),
                          ),
                          title: Text(
                            '${waterEntries[reverseIndex]} mL',
                          ),
                          subtitle: Text(
                            'Entry ${reverseIndex + 1}',
                          ),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: confirmReset,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset Today\'s Intake'),
                  ),
                ],
              ),
            ),
    );
  }

  // Reusable information card.
  Widget _infoCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
