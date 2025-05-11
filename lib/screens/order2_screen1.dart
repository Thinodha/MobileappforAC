import 'package:flutter/material.dart';
import 'package:project_1/screens/order2_screen2.dart';
import 'package:project_1/screens/supplier_notification2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: Order2Screen1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Order2Screen1 extends StatelessWidget {
  const Order2Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Agri',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'connect',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text('Welcome, Sarath', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 8),
              Icon(Icons.account_circle, color: Colors.black),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: Colors.black, size: 12),
                SizedBox(width: 8),
                Text(
                  'Client Hotel Galadari Order',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.all(12),
                child: Text(
                  'Purchase order',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoText('Delivery Date: 2025-04-16'),
                  _infoText('In-charge: Mr. Xoil (Assistant hotel manager)'),

                  SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    children: [
                      _buildTableHeader(),
                      _buildTableRow('Cauliflower', '60'),
                      _buildTableRow('Eggplant', '35'),
                      _buildTableRow('Cabbage', '80'),
                      _buildTableRow('Bell pepper', '60'),
                      _buildTableRow('Cucumber', '60'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green[50], // light green background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "Total Earnings = LKR 6500",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Order2Screen2();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12),
                ),
                child: Icon(Icons.check, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.green.shade200),
      children: [
        _tableCell('Vegetables and Fruits', true),
        _tableCell('Quantity', true),
      ],
    );
  }

  TableRow _buildTableRow(String item, String quantity) {
    return TableRow(
      children: [_tableCell(item, false), _tableCell(quantity, false)],
    );
  }

  Widget _tableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
