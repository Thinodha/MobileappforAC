import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;

  const FavoritesPage({Key? key, required this.favoriteProducts})
    : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  bool _isLoading = true;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Agri',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: 'connect',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome,',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Text(
                      userName ?? 'User',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.account_circle, color: Colors.black, size: 30),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.favoriteProducts.isEmpty
                ? const Center(
                  child: Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
                : ListView.builder(
                  itemCount: widget.favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = widget.favoriteProducts[index];
                    return ListTile(
                      title: Text(
                        product['name'] ?? 'Unnamed Product',
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        product['description'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.favorite, color: Colors.red),
                    );
                  },
                ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.green),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0A7020),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.white),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Colors.black),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
