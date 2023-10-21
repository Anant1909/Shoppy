// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/screens/cart.dart';
import 'dart:convert';

import 'package:shoppy/screens/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> categoryList = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(categoryList);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load categories. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        this.error = 'Error fetching categories: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text('Shoppy', textAlign: TextAlign.center),
          ],
        ),
        actions: <Widget>[
          IconButton(
  icon: const Icon(Icons.shopping_cart),
  onPressed: () {
   
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  CartScreen(), 
      ),
    );
  },
),

        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Drawer(
              child: Text('Error loading user data: ${snapshot.error}'),
            );
          } else {
            final user = snapshot.data;
            return Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.indigo[900]),
                    
                    accountName: Text(user?['name'] ?? 'User Name'),
                    accountEmail: Text(user?['email'] ?? 'Email'),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                    
                  ),
                ],
              ),
            );
          }
        },
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
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              categoryId: category['id'].toString(),
                              categoryName: '',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.teal[100],
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0), 
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: <Widget>[
                              Icon(
                                Icons.category,
                                size: 64,
                                color: Colors.indigo[900],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                category['name'] ?? 'No Name Available',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/users/1'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      throw Exception('Error fetching user data: $error');
    }
  }
}
