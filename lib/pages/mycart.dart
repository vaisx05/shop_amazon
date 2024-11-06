import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  List products = []; // List to store fetched cart products
  String searchQuery = ''; // Search query for filtering products

  @override
  void initState() {
    super.initState();
    fetchCartProducts(); // Fetch cart products on initialization
  }

  // Fetch cart products from the PostgreSQL server
  Future<void> fetchCartProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/products'));
      if (response.statusCode == 200) {
        final allProducts = jsonDecode(response.body);

        // Filter products to include only those that are in the cart
        setState(() {
          products = allProducts
              .where((product) => product['in_cart'] == true)
              .toList();
        });
      } else {
        throw Exception('Failed to load cart products');
      }
    } catch (error) {
      print('Error fetching cart products: $error');
    }
  }

  // Update cart status in the database
  Future<void> updateCartStatus(int productId, bool inCart) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/products/$productId/cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {'in_cart': inCart}), // Send the new cart status to the server
      );

      if (response.statusCode == 200) {
        print('Product cart status updated successfully');
      } else {
        throw Exception('Failed to update cart status');
      }
    } catch (error) {
      print('Error updating cart status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            'My Cart',
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search cart products...',
                filled: true,
                fillColor: const Color.fromARGB(255, 240, 240, 240),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value.toLowerCase(); // Update search query state
                });
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: products.isEmpty
            ? const Center(
                child: Text('No products in the cart.',
                    style: TextStyle(
                        fontSize: 18))) // Show message if no cart products
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  // Filter products based on search query
                  if (searchQuery.isNotEmpty &&
                      !product['name'].toLowerCase().contains(searchQuery)) {
                    return Container(); // Hide products that don't match the search
                  }
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      textColor: Colors.black,
                      tileColor: const Color.fromRGBO(255, 255, 255, 1),
                      leading: const Icon(Icons.shopping_cart),
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Rs ${product['price']}'),
                      trailing: IconButton(
                        icon: Icon(
                          product['in_cart']
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                        ),
                        onPressed: () {
                          setState(() {
                            product['in_cart'] =
                                !product['in_cart']; // Toggle cart status
                          });
                          updateCartStatus(
                              product['id'],
                              product[
                                  'in_cart']); // Update status in the database
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor:
          const Color.fromRGBO(255, 255, 255, 1), // Main background color
    );
  }
}
