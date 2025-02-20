import 'package:flutter/material.dart';
import 'package:vending_machine_ordering_app/pages/payment_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final bool isNewSession;
  final Function(List<Map<String, dynamic>>) onCartUpdated;
  final VoidCallback onSessionReset;

  const CartPage({
    required this.cart,
    required this.isNewSession,
    required this.onCartUpdated,
    required this.onSessionReset,
  });
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
    widget.onCartUpdated(widget.cart);
  }

  double getTotalAmount() {
    return widget.cart
        .fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void checkout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          totalAmount: getTotalAmount(),
          onPaymentSuccess: () {
            widget.onSessionReset(); // Reset session on successful payment
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 50),
          child: widget.cart.isEmpty
              ? const Center(child: Text('No items in cart'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.cart.length,
                        itemBuilder: (context, index) {
                          var item = widget.cart[index];
                          return ListTile(
                            title: Text(item['name']),
                            subtitle:
                                Text('₹${item['price']} x ${item['quantity']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => removeFromCart(index),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Total: ₹${getTotalAmount()}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => checkout(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
