import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/screens/farmer_favorites.dart';
import 'package:project_1/screens/farmer_notification.dart';
import 'package:project_1/screens/farmerharvest_update.dart';
import 'package:project_1/screens/farmerharvest_update2.dart';
import 'package:project_1/screens/home_farmer_content.dart';
import 'package:project_1/services/auth_service.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _selectedIndex = 0;
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

  List<Widget> get _pages => [
    HomeContent(username: userName ?? 'User'),
    FarmerFavoritesScreen(), // This is now the combined page
    HarvestUpdatePage(), // Using the same combined page
    NotificationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A7020),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(Icons.home),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(Icons.favorite),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(Icons.agriculture),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(Icons.chat_bubble),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
