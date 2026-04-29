import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/cart_provider.dart';

class ItemDetailSheet extends StatefulWidget {
  final Item item;

  const ItemDetailSheet({super.key, required this.item});

  @override
  State<ItemDetailSheet> createState() => _ItemDetailSheetState();
}

class _ItemDetailSheetState extends State<ItemDetailSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Center(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(item.image, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              item.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              item.description,
              style: TextStyle(color: Colors.grey[600], height: 1.4),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nutri("kcal", item.nutrition.kcal),
                  _nutri("grams", item.nutrition.grams),
                  _nutri("proteins", item.nutrition.protein),
                  _nutri("fats", item.nutrition.fats),
                  _nutri("carbs", item.nutrition.carbs),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (_, cart, _) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          for (int i = 0; i < quantity; i++) {
                            cart.addToCart(item);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Add to cart  ₹${(item.price * quantity).toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _nutri(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
