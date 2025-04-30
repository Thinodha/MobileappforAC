import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project_1/screens/selectfruits.dart';
import 'package:project_1/services/auth_service.dart';
import 'package:project_1/services/item_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VegetableSelectionScreen(),
    );
  }
}

class VegetableSelectionScreen extends StatefulWidget {
  const VegetableSelectionScreen({super.key});

  @override
  State<VegetableSelectionScreen> createState() =>
      _VegetableSelectionScreenState();
}

class _VegetableSelectionScreenState extends State<VegetableSelectionScreen> {
  final _itemService = ItemServices();
  final List<String> vegetableImages = [
    'assets/images/carrot.png',
    'assets/images/potato.png',
    'assets/images/cucumber.png',
    'assets/images/tomato.png',
    'assets/images/pumpkin.png',
    'assets/images/cabbage.png',
    'assets/images/onions.png',
    'assets/images/chillies.png',
    'assets/images/beetr.png',
    'assets/images/brinjal.png',
    'assets/images/lattice.png',
    'assets/images/leeks.png',
  ];
  final List<String> vegetableNames = [
    'carrot',
    'potato',
    'cucumber',
    'tomato',
    'pumpkin',
    'cabbage',
    'onions',
    'chillies',
    'beetroot',
    'brinjal',
    'lettuce',
    'leeks',
  ];
  // Store selected images
  final Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns to left
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Agri",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A7020),
                      ),
                    ),
                    TextSpan(
                      text: "connect",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Set up your account",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select your vegetables",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Grid of Vegetable Images
            Expanded(
              child: GridView.builder(
                itemCount:
                    vegetableImages.length > 12 ? 12 : vegetableImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndexes.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            vegetableImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                0.4,
                              ), // Opacity fixed
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/selectfruits');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: const Color(0xFF0A7020),
                    ),
                    child: const Icon(
                      LucideIcons.chevronsRight,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      // Convert selected indexes to maps with empty price and quantity
                      List<Map<String, dynamic>> selectedVegetableMaps =
                          selectedIndexes.map((index) {
                            return {
                              'name': vegetableNames[index],
                              'price': '', // Empty price initially
                              'quantity': '', // Empty quantity initially
                              'imageUrl':
                                  vegetableImages[index], // Store image path
                            };
                          }).toList();

                      if (user != null) {
                        try {
                          await _itemService.saveSelectedVegetables(
                            uid: user.uid,
                            vegetables:
                                selectedVegetableMaps, // Pass the maps instead of just names
                          );
                          Navigator.pushNamed(context, '/selectfruits');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to save selected vegetables: $e',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: const Color(0xFF0A7020),
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
