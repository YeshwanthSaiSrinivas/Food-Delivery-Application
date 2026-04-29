import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/cart_sheet.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/item_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String sortBy = "";

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    var items = [...itemProvider.filteredItems];

    if (sortBy == "price") {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "kcal") {
      items.sort((a, b) => a.nutrition.kcal.compareTo(b.nutrition.kcal));
    } else if (sortBy == "protein") {
      items.sort((a, b) => a.nutrition.protein.compareTo(b.nutrition.protein));
    }

    final promoted = itemProvider.promotedItems;

    return Scaffold(
      drawer: Drawer(child: Center(child: Text("Not implemented"))),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "100a Ealing Rd • 24 mins",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Hits of the week",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              height: 260,
              child: PageView.builder(
                itemCount: promoted.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, index) {
                  final item = promoted[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: -12,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 260,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 139, 201, 252),
                                  const Color.fromARGB(255, 241, 201, 248),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "₹${item.price}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(item.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(promoted.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  width: currentIndex == index ? 20 : 10,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),

            SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showSort(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tune, size: 16),
                          SizedBox(width: 4),
                          Text("Sort"),
                        ],
                      ),
                    ),
                  ),
                  ...itemProvider.categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: cat == itemProvider.selectedCategory,
                        onSelected: (_) {
                          itemProvider.selectCategory(cat);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ItemDetailSheet(item: item),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.image,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "₹${item.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${item.nutrition.kcal} kcal",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: cart.items.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CartSheet(),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cart.itemCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showSort(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Price"),
              onTap: () {
                setState(() => sortBy = "price");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Kcal"),
              onTap: () {
                setState(() => sortBy = "kcal");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
