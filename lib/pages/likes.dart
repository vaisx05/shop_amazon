import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List products = []; 
  String searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    fetchLikedProducts();
  }

  
  Future<void> fetchLikedProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/products'));
      if (response.statusCode == 200) {
        final allProducts = jsonDecode(response.body);

       
        setState(() {
          products =
              allProducts.where((product) => product['liked'] == true).toList();
        });
      } else {
        throw Exception('Failed to load liked products');
      }
    } catch (error) {
      print('Error fetching liked products: $error');
    }
  }

  
  Future<void> updateLikedStatus(int productId, bool liked) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/products/$productId/like'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {'liked': liked}), 
      );

      if (response.statusCode == 200) {
        print('Product liked status updated successfully');
      } else {
        throw Exception('Failed to update liked status');
      }
    } catch (error) {
      print('Error updating liked status: $error');
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
            'Liked Products',
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
                hintText: 'Search liked products...',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: products.isEmpty
            ? const Center(
                child: Text('No products are liked.',
                    style: TextStyle(
                        fontSize: 18))) 
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  
                  if (searchQuery.isNotEmpty &&
                      !product['name'].toLowerCase().contains(searchQuery)) {
                    return Container(); 
                  }
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      textColor: Colors.black,
                      tileColor: const Color.fromRGBO(255, 255, 255, 1),
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Rs ${product['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              product['liked']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: product['liked'] ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                product['liked'] =
                                    !product['liked']; 
                              });
                              updateLikedStatus(
                                  product['id'],
                                  product[
                                      'liked']);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              product['in_cart']
                                  ? Icons.shopping_cart
                                  : Icons.add_shopping_cart,
                            ),
                            onPressed: () {
                              setState(() {
                                product['in_cart'] =
                                    !product['in_cart']; 
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor:
          const Color.fromRGBO(255, 255, 255, 1), 
    );
  }
}
