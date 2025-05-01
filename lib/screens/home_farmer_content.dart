import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/screens/login_page.dart';
import 'package:project_1/screens/models/item_quantity.dart';
import 'package:project_1/screens/welcome.dart';
import 'package:project_1/screens/widgets/item_bar_chart.dart';
import 'package:project_1/services/auth_service.dart';

class HomeContent extends StatefulWidget {
  final String username;
  const HomeContent({super.key, required this.username});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _authService = AuthService();
  late Future<Map<String, List<ItemQuantity>>> _futureChartData;

  @override
  void initState() {
    super.initState();
    _futureChartData = _fetchChartData();
  }

  Future<Map<String, List<ItemQuantity>>> _fetchChartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = userDoc.data() ?? {};

    List<ItemQuantity> vegList = [];
    List<ItemQuantity> fruitList = [];

    // Vegetables
    if (data['selectedVegetables'] != null) {
      for (var veg in List<Map<String, dynamic>>.from(
        data['selectedVegetables'],
      )) {
        vegList.add(
          ItemQuantity(
            name: veg['name'] ?? 'Unknown',
            quantity: double.tryParse(veg['quantity'] ?? '0') ?? 0,
            barColor: Colors.green,
            imageUrl: veg['imageUrl'],
          ),
        );
      }
    }
    // Fruits
    if (data['selectedFruits'] != null) {
      for (var fruit in List<Map<String, dynamic>>.from(
        data['selectedFruits'],
      )) {
        fruitList.add(
          ItemQuantity(
            name: fruit['name'] ?? 'Unknown',
            quantity: double.tryParse(fruit['quantity'] ?? '0') ?? 0,
            barColor: Colors.orange,
            imageUrl: fruit['imageUrl'],
          ),
        );
      }
    }

    return {'vegetables': vegList, 'fruits': fruitList};
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Agri',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A7020),
                        ),
                      ),
                      TextSpan(
                        text: 'connect',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Welcome, ${widget.username}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.account_circle, size: 30),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            //Bar Charts
            FutureBuilder<Map<String, List<ItemQuantity>>>(
              future: _futureChartData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data found.'));
                }
                final vegData = snapshot.data!['vegetables']!;
                final fruitData = snapshot.data!['fruits']!;

                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        if (vegData.isNotEmpty)
                          ItemBarChart(
                            data: vegData,
                            title: 'Vegetables Quantity (Kg)',
                          ),
                        if (fruitData.isNotEmpty)
                          ItemBarChart(
                            data: fruitData,
                            title: 'Fruits Quantity (Kg)',
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // const Text(
            //   "Suppliers you may interested in,",
            //   style: TextStyle(fontSize: 16),
            // ),
            // Supplier Cards
            // Expanded(
            //   child: ListView(
            //     children: [
            //       buildSupplierCard(
            //         name: "Nimal",
            //         rating: "4.5",
            //         items: ["Carrot", "Cabbage", "Potato"],
            //       ),
            //       const SizedBox(height: 10),
            //       buildSupplierCard(
            //         name: "Kasun",
            //         rating: "4.3",
            //         items: ["Carrot", "Beetroot", "Beans"],
            //       ),
            //     ],
            //   ),
            // ),

            // Sign Out Button (dummy for now)
            TextButton(
              onPressed: () async {
                // Implement sign out logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign out tapped')),
                );
                await _authService.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSupplierCard({
    required String name,
    required String rating,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F0),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon, name, rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle, size: 24),
                  const SizedBox(width: 5),
                  Text(
                    "Supplier, $name",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price range
          const Text(
            "Price range",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          ...items.map((item) => Text(item)).toList(),

          // View more button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to supplier detail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                elevation: 0,
              ),
              child: const Text(
                "View more",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
