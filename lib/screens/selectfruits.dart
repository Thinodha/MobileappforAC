import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project_1/services/item_services.dart';

class FruitSelectionScreen extends StatefulWidget {
  const FruitSelectionScreen({super.key});

  @override
  State<FruitSelectionScreen> createState() => _FruitSelectionScreenState();
}

class _FruitSelectionScreenState extends State<FruitSelectionScreen> {
  final _itemServices = ItemServices();
  final List<String> fruitImages = [
    'assets/images/strawberry.png',
    'assets/images/mango.png',
    'assets/images/orange.png',
    'assets/images/apple.png',
    'assets/images/banana.png',
    'assets/images/blueberry.png',
    'assets/images/papaya.png',
    'assets/images/pears.png',
    'assets/images/watermelon.png',
    'assets/images/dragonfruit.png',
    'assets/images/peach.png',
  ];
  final List<String> fruitNames = [
    'strawberry',
    'mango',
    'orange',
    'apple',
    'banana',
    'blueberry',
    'papaya',
    'pears',
    'watermelon',
    'dragonfruit',
    'peach',
  ];

  // Store selected fruits
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
              "Select your fruits",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Grid of Fruit Images
            Expanded(
              child: GridView.builder(
                itemCount: fruitImages.length > 12 ? 12 : fruitImages.length,
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
                            fruitImages[index],
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
                      Navigator.pop(context); // Go back
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: const Color(0xFF0A7020),
                    ),
                    child: const Icon(
                      LucideIcons.chevronsLeft,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      // Convert selected indexes to maps with empty price and quantity
                      List<Map<String, dynamic>> selectedFruitMaps =
                          selectedIndexes.map((index) {
                            return {
                              'name': fruitNames[index],
                              'price': '', // Empty price initially
                              'quantity': '', // Empty quantity initially
                              'imageUrl':
                                  fruitImages[index], // Store image path
                            };
                          }).toList();

                      if (user != null) {
                        try {
                          await _itemServices.saveSelectedFruits(
                            uid: user.uid,
                            fruits:
                                selectedFruitMaps, // Pass the maps instead of just names
                          );
                          Navigator.pushNamed(
                            context,
                            '/farmerRegisterSuccessfull',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to save selected fruits: $e',
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
