import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final String notificationMessage =
      "Customer Saman has requested 50kg of carrots and 20kg of cabbage. You can confirm the order.";

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
      // Top AppBar with branding and welcome message
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
      // Body with notifications text and notifications list
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title header centered inside the body
            Center(
              child: Text(
                'Stay updated!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            // Dynamic list displaying multiple notifications
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Adjust the number of notifications as needed
                itemBuilder: (context, index) {
                  return buildNotificationBox(notificationMessage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget that builds a notification box using a styled container.
  Widget buildNotificationBox(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(message, style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
