// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories/${widget.categoryId}/products'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> productList = json.decode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(productList);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load products. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        this.error = 'Error fetching products: $error';
      });
    }
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Center(
            child: Text(
              product['title'] ?? 'No Name Available',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    product['images'][0] ?? 'URL to a Placeholder Image',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                product['description'] ?? 'No Description Available',
              ),
              Center(
                child: Text(
                  'Price: \$${product['price'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _addToCart(product);
                Navigator.of(context).pop();
              },
              child: const Text('Add to Cart'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(Map<String, dynamic> product) {
  final cartProvider = context.read<CartProvider>();
  cartProvider.addToCart(
    Product(
      id: product['id'].toString(),
      title: product['title'],
      price: double.parse(product['price'].toString()),
      imageUrl: product['images'][0],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.indigo[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Text('Error: $error'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        _showProductDetails(product);
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  product['images'][0] ?? 'URL to a Placeholder Image',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              product['title'] ?? 'No Name Available',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
