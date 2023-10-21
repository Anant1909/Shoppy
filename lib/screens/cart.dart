import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;
    final totalAmount = cart.totalAmount; 

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Cart'),
        backgroundColor: Colors.indigo[900],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) {
                final product = cartItems[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Price: \$${product.price.toStringAsFixed(2)}',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 24,
                        onPressed: () {
                          cart.removeItem(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                ElevatedButton(
                        onPressed: () {
    
                            },
                               style: ButtonStyle(
                             backgroundColor: MaterialStateProperty.all(Colors.indigo[900]),
                                   ),
                                  child: const Text('Proceed to Buy'),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
