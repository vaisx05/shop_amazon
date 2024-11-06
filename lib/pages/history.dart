import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchasedPage extends StatefulWidget {
  const PurchasedPage({super.key});

  @override
  State<PurchasedPage> createState() => _PurchasedPageState();
}

class _PurchasedPageState extends State<PurchasedPage> {
  List products = []; 
  String searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    fetchPurchasedProducts(); 
  }

  
  Future<void> fetchPurchasedProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/products/buy'));
      if (response.statusCode == 200) {
        final allProducts = jsonDecode(response.body);

        
        setState(() {
          products = allProducts;
        });
      } else {
        throw Exception('Failed to load purchased products');
      }
    } catch (error) {
      print('Error fetching purchased products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(207, 185, 151, 0),
        title: const Text(
          'Purchased Products',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search purchased products...',
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
                      value.toLowerCase(); 
                });
              },
            ),
          ),
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No purchased products.',
                style: TextStyle(fontSize: 18),
              ),
            ) 
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: 0.75, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  if (searchQuery.isNotEmpty &&
                      !product['name'].toLowerCase().contains(searchQuery)) {
                    return Container(); 
                  }
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag,
                            size: 40, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Rs ${product['price']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
