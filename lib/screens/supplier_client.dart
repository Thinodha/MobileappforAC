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
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: PurchaseOrderPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PurchaseOrderPage extends StatelessWidget {
  const PurchaseOrderPage({super.key});

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
              Text(
                'Welcome, Sarath',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
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
                  'Client Shangri-La purchase order',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
                  _infoText('Delivery time: Friday, 6am (08th April)'),
                  _infoText('In-charge: Mr. Xoil (Assistant hotel manager)'),
                  _infoText('Purchase order no: 05'),
                  SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    children: [
                      _buildTableHeader(),
                      _buildTableRow('Carrot', '50'),
                      _buildTableRow('Cabbage', '25'),
                      _buildTableRow('Potato', '70'),
                      _buildTableRow('Beans', '50'),
                      _buildTableRow('Cucumber', '30'),
                      _buildTableRow('Tomato', '50'),
                      _buildTableRow('Lettuce', '20'),
                      _buildTableRow('Bell pepper', '20'),
                      _buildTableRow('Onion', '60'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
      children: [
        _tableCell(item, false),
        _tableCell(quantity, false),
      ],
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
