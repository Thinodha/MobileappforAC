import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_1/screens/favoritepage.dart';
import 'package:project_1/screens/supplier_homepage3.dart';
import 'package:project_1/screens/supplier_homepage4.dart';
import 'package:project_1/screens/supplier_homepage5.dart';
import 'package:project_1/screens/supplier_homepage6.dart';

class Harvest_detail_page extends StatefulWidget {
  @override
  _HarvestDetailPageState createState() => _HarvestDetailPageState();
}

class _HarvestDetailPageState extends State<Harvest_detail_page> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> favoriteProducts = [];
  bool isLoading = true;
  String totalEarning = "0";

  @override
  void initState() {
    super.initState();
    fetchHarvestData();
  }

  Future<void> fetchHarvestData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('supplier')
              .doc('T3njwlokEjRHeCwpaTlJ')
              .get();

      final data = snapshot.data();
      if (data != null) {
        List<Map<String, dynamic>> loadedProducts = [];

        if (data.containsKey('carrot')) {
          loadedProducts.add({
            "name": "Carrot",
            "price": int.parse(data['carrot']['price']),
            "image": "assets/images/carrot.png",
          });
        }
        if (data.containsKey('cabbage')) {
          loadedProducts.add({
            "name": "Cabbage",
            "price": int.parse(data['cabbage']['price']),
            "image": "assets/images/cabbage.png",
          });
        }
        if (data.containsKey('potato')) {
          loadedProducts.add({
            "name": "Potato",
            "price": int.parse(data['potato']['price']),
            "image": "assets/images/potato.png",
          });
        }
        if (data.containsKey('leeks')) {
          loadedProducts.add({
            "name": "leeks",
            "price": int.parse(data['leeks']['price']),
            "image": "assets/images/leeks.png",
          });
        } else {
          loadedProducts.add({
            "name": "leeks",
            "price": 20,
            "image": "assets/images/leeks.png",
          });
        }

        setState(() {
          products = loadedProducts;
          totalEarning = data['totalEarning'] ?? "0";
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Agri",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A7020),
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: "connect",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      "Sarath",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Icon(Icons.account_circle, color: Colors.black, size: 28),
              ],
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_circle,
                          color: Colors.black,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Farmer Nimal’s harvest details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Earning: Rs. $totalEarning",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FavoritesPage(
                                  favoriteProducts: favoriteProducts,
                                ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: Text("Add to your favourites ❤")),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7, // Adjusted
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            name: products[index]["name"],
                            price: products[index]["price"],
                            image: products[index]["image"],
                            onPressed: () {
                              setState(() {
                                favoriteProducts.add(products[index]);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${products[index]["name"]} added to favorites',
                                  ),
                                ),
                              );

                              if (products[index]["name"] == "Carrot") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CarrotProductScreen(),
                                  ),
                                );
                              } else if (products[index]["name"] == "Cabbage") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CabbageProductScreen(),
                                  ),
                                );
                              } else if (products[index]["name"] == "Potato") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PotatoProductScreen(),
                                  ),
                                );
                              } else if (products[index]["name"] == "leeks") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BeansProductScreen(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: const Color(0xFF0A7020),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favoriteProducts: []),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/agriconnecthome');
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final VoidCallback onPressed;

  const ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fix overflow
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 80,
                fit: BoxFit.cover,
              ), // Reduced height
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Rs.$price",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
