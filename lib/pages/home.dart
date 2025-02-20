import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vending_machine_ordering_app/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [
    {'name': 'Chocolate', 'price': 150, 'image': 'assets/chocolate.jpg'},
    {
      'name': 'Dishwash Liquid',
      'price': 300,
      'image': 'assets/dishwash_liquid.jpg'
    },
    {'name': 'Biscuit', 'price': 200, 'image': 'assets/biscuit.jpg'},
  ];
  List<Map<String, dynamic>> cart = [];
  bool isNewSession = true; // Initially true

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      isNewSession = false; // Mark session as active when adding to cart

      var existingItem = cart.firstWhere(
          (item) => item['name'] == product['name'],
          orElse: () => {});
      if (existingItem.isNotEmpty && existingItem['quantity'] < 5) {
        existingItem['quantity']++;
      } else if (existingItem.isEmpty) {
        cart.add({...product, 'quantity': 1});
      }
    });
    Fluttertoast.showToast(msg: "Item added to cart");
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cart: cart,
          isNewSession: isNewSession,
          onCartUpdated: (updatedCart) {
            setState(() {
              cart = updatedCart;
            });
          },
          onSessionReset: () {
            setState(() {
              isNewSession = true; // Reset session when returning home
              cart.clear(); // Clear cart on a new session
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCart,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Close dialog
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  height: 120,
                ),
                const SizedBox(height: 10),
                Text(product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('₹${product['price']}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => addToCart(product),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
