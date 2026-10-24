
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String foodName;
  final double price;
  final IconData foodIcon;
  final VoidCallback onAddToCart;

  const FoodCard({
    super.key,
    required this.foodName,
    required this.price,
    required this.foodIcon,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Food Icon
            Icon(
              foodIcon,
              size: 55,
              color: Colors.deepOrange,
            ),

            const SizedBox(width: 16),

            // Food Name and Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'ADD TO CART',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
