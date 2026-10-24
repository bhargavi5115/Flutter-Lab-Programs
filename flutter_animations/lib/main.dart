
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Effects',
      debugShowCheckedModeBanner: false,
      home: const AnimationDemo(),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    slideAnimation = Tween<Offset>(
      begin: const Offset(-2, 0),
      end: Offset.zero,
    ).animate(controller);

    scaleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(controller);

    rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(controller);
  }

  void startAnimation() {
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animation Effects'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo.shade50,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Fade Animation
              const Text(
                '1. Fade Animation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: fadeAnimation.value,
                    child: const Icon(
                      Icons.favorite,
                      size: 60,
                      color: Colors.red,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Slide Animation
              const Text(
                '2. Slide Animation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SlideTransition(
                position: slideAnimation,
                child: const Icon(
                  Icons.directions_car,
                  size: 60,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              // Scale Animation
              const Text(
                '3. Scale Animation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ScaleTransition(
                scale: scaleAnimation,
                child: const Icon(
                  Icons.star,
                  size: 60,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 20),

              // Rotation Animation
              const Text(
                '4. Rotation Animation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RotationTransition(
                turns: rotationAnimation,
                child: const Icon(
                  Icons.settings,
                  size: 60,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: startAnimation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('Start All Animations'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
