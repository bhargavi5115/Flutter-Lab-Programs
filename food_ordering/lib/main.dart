
import 'package:flutter/material.dart';
import 'food_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: const FoodHomePage(),
    );
  }
}

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});

  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  int cartCount = 0;

  void addToCart() {
    setState(() {
      cartCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Food added to cart!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Ordering App'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 5),
                Text(
                  '$cartCount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      backgroundColor: Colors.orange.shade50,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Delicious Food Menu',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Choose your favourite food!',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 15),

            // First Food Item
            FoodCard(
              foodName: 'Pizza',
              price: 199.00,
              foodIcon: Icons.local_pizza,
              onAddToCart: addToCart,
            ),

            // Second Food Item
            FoodCard(
              foodName: 'Burger',
              price: 99.00,
              foodIcon: Icons.lunch_dining,
              onAddToCart: addToCart,
            ),

            // Third Food Item
            FoodCard(
              foodName: 'Biryani',
              price: 180.00,
              foodIcon: Icons.rice_bowl,
              onAddToCart: addToCart,
            ),

            const SizedBox(height: 20),

            Text(
              'Items in Cart: $cartCount',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
