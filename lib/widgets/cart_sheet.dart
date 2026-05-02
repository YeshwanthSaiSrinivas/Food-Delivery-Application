import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartSheet extends StatefulWidget {
  const CartSheet({super.key});

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  String address = "100a Ealing Rd";
  int cutlery = 1;

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context);

    if (cart.items.isEmpty) {
      return const SizedBox.shrink();
    }

    double delivery = cart.totalPrice > 30 ? 0 : 30;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xfff7f7f7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              children: [
                const Text(
                  "We will deliver in\n24 minutes to the address:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(address, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        TextEditingController c = TextEditingController(
                          text: address,
                        );

                        String? result = await showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: TextField(controller: c),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, c.text);
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            );
                          },
                        );

                        if (result != null && result.isNotEmpty) {
                          setState(() {
                            address = result;
                          });
                        }
                      },
                      child: Text(
                        "Change address",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ...cart.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          // child: Image.network(
                          //   item.item.image,
                          //   height: 56,
                          //   width: 56,
                          //   fit: BoxFit.cover,
                          // ),
                          child: CachedNetworkImage(
                            imageUrl: item.item.image,
                            height: 56,
                            width: 56,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.item.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          "\$${item.item.price}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16),
                                onPressed: () {
                                  cart.decreaseQty(item.item.id);
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16),
                                onPressed: () {
                                  cart.increaseQty(item.item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                Divider(color: Colors.grey.shade300),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant, size: 18),
                      const SizedBox(width: 10),
                      const Expanded(child: Text("Cutlery")),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () {
                                if (cutlery > 0) {
                                  setState(() {
                                    cutlery--;
                                  });
                                }
                              },
                            ),
                            Text(cutlery.toString()),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () {
                                setState(() {
                                  cutlery++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade300),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery"),
                    Text(
                      delivery == 0
                          ? "Free"
                          : "\$${delivery.toStringAsFixed(0)}",
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // FIX: show threshold notice only when delivery fee is being charged
                if (delivery > 0)
                  Text(
                    "Free delivery from \$30",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),

                const SizedBox(height: 20),

                const Text(
                  "Payment method",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // FIX: use an actual icon instead of empty string
                    child: const Icon(Icons.apple, size: 18),
                  ),
                  title: const Text("Apple Pay"),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                cart.clearCart();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Order placed")));
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pay", style: TextStyle(color: Colors.white)),
                  Text(
                    "24 min  •  \$${(cart.totalPrice + delivery).toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
