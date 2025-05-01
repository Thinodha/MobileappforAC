import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerFavoritesScreen extends StatefulWidget {
  const FarmerFavoritesScreen({super.key});

  @override
  State<FarmerFavoritesScreen> createState() => _FarmerFavoritesScreenState();
}

class _FarmerFavoritesScreenState extends State<FarmerFavoritesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  bool _isLoading = true;

  // Add this initState method
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('username') ?? 'User';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Branding: "Agri" (green) + "connect" (black)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Agri',
                    style: TextStyle(
                      color: Color(0xFF0A7020),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'connect',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Welcome message and profile icon
            Row(
              children: [
                Text(
                  'Welcome, ${userName ?? 'User'}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(width: 8),
                Icon(Icons.account_circle, color: Colors.black, size: 24),
              ],
            ),
          ],
        ),
      ),
      body: Center(child: Text("Favorites Page")),
    );
  }
}
