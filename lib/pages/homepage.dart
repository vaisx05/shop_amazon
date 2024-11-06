import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/products'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedProducts = jsonDecode(response.body);

        print('Fetched Products: $fetchedProducts');
        setState(() {
          products = fetchedProducts;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> updateLikedStatus(int productId, bool liked) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/products/$productId/like'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'liked': liked}),
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

  Future<void> updateCartStatus(int productId, bool inCart) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/products/$productId/cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'in_cart': inCart}),
      );

      if (response.statusCode == 200) {
        print('Cart status updated successfully');
      } else {
        throw Exception('Failed to update cart status');
      }
    } catch (error) {
      print('Error updating cart status: $error');
    }
  }

  Future<void> updateBuyStatus(int productId, bool buy) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/products/$productId/buy'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'buy': buy}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = products.indexWhere((p) => p['id'] == productId);
          if (index != -1) {
            products[index]['buy'] = buy;
          }
        });
        print('Buy status updated successfully');
      } else {
        throw Exception('Failed to update buy status');
      }
    } catch (error) {
      print('Error updating buy status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 360,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildPageImage()),
            ),
            // Product List
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        if (searchQuery.isNotEmpty &&
                            !product['name']
                                .toLowerCase()
                                .contains(searchQuery)) {
                          return Container();
                        }

                        return _buildProductCard(product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageImage() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search on Amazon...',
              hintStyle:
                  const TextStyle(fontFamily: "AmazonEmber", fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              suffixIcon: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 5),
                  Icon(Icons.qr_code_scanner, color: Colors.black54),
                  SizedBox(width: 10),
                ],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/icons/washing.png")),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/icons/washing.png")),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/icons/washing.png")),
          ],
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Today's Deals",
              style: TextStyle(
                  fontFamily: "APTSans-Bold",
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildProductCard(Map product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            leading: product['imageUrl'] != null && product['imageUrl'] != ""
                ? Image.network(
                    product['imageUrl'],
                    width: 50, // Adjust width as needed
                    height: 50, // Adjust height as needed
                    fit: BoxFit.cover, // Adjust how the image fits
                  )
                : const Text("Hello"),
            // : Image.network(
            //     'https://t4.ftcdn.net/jpg/03/28/37/93/360_F_328379347_xEKgEB2wkjAJmcqSTmrg4uKxfWrlL7D9.jpg',
            //     width: 50,
            //     height: 50,
            //     fit: BoxFit.cover,
            //   ),
            title: Text(
              product['name'] ?? 'Unnamed Product',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rs ${product['price']?.toString() ?? '0'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            trailing: _buildProductActionButtons(product),
          ),
        ),
      ),
    );
  }

  Widget _buildProductActionButtons(Map product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            product['liked'] ? Icons.favorite : Icons.favorite_border,
            color: product['liked'] ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              product['liked'] = !product['liked'];
            });
            updateLikedStatus(product['id'], product['liked']);
          },
        ),
        IconButton(
          icon: Icon(
            product['in_cart'] ? Icons.shopping_cart : Icons.add_shopping_cart,
            color: product['in_cart'] ? Colors.green : null,
          ),
          onPressed: () {
            setState(() {
              product['in_cart'] = !product['in_cart'];
            });
            updateCartStatus(product['id'], product['in_cart']);
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_checkout),
          onPressed: () {
            updateBuyStatus(product['id'], true);
          },
        ),
      ],
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: product['imageUrl'] != null && product['imageUrl'] != ""
                  ? Image.network(
                      product['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://t4.ftcdn.net/jpg/03/28/37/93/360_F_328379347_xEKgEB2wkjAJmcqSTmrg4uKxfWrlL7D9.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            Text(
              product['name'] ?? 'Unnamed Product',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: Rs ${product['price']?.toString() ?? '0'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Description: ${product['description'] ?? 'No description available'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
