import 'package:flutter/material.dart';
import 'supplier_cart2.dart'; // Import HarvestUpdatePage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// Static class to store orders data
class OrdersData {
  static final List<Map<String, dynamic>> _orders = [];

  static List<Map<String, dynamic>> get orders => _orders;

  static void addOrder(Map<String, dynamic> order) {
    // Add new order to the beginning of the list
    _orders.insert(0, order);
  }

  static void clearOrders() {
    _orders.clear();
  }

  // Add method to remove an order by id
  static void removeOrder(String id) {
    _orders.removeWhere((order) => order['id'] == id);
  }
}

class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({super.key});

  @override
  State<PendingOrdersPage> createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _firestoreOrders = [];
  final CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('cart');

  @override
  void initState() {
    super.initState();
    // Load orders
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get orders from Firestore
      final QuerySnapshot snapshot = await cartCollection.get();

      setState(() {
        _firestoreOrders =
            snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              // Ensure the id is available
              data['id'] = doc.id;
              return data;
            }).toList();

        // Sort by timestamp (newest first)
        _firestoreOrders.sort((a, b) {
          Timestamp timestampA = a['timestamp'] as Timestamp;
          Timestamp timestampB = b['timestamp'] as Timestamp;
          return timestampB.compareTo(timestampA);
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading orders: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeOrder(String id) async {
    try {
      // Remove from Firestore
      await cartCollection.doc(id).delete();

      // Also remove from local state
      setState(() {
        _firestoreOrders.removeWhere((order) => order['id'] == id);
      });

      // Keep the static class sync for backward compatibility
      OrdersData.removeOrder(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing order: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Firestore orders instead of static orders
    final orders = _firestoreOrders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Agri',
                    style: TextStyle(color: Color(0xFF0A7020)),
                  ),
                  TextSpan(text: 'connect'),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      "Sarath",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(width: 8), // Space between text and icon
                Icon(Icons.account_circle, size: 30, color: Colors.black),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Pending orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (_isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A7020)),
                ),
              ),
            )
          else if (orders.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No pending orders found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadOrders,
                color: Color(0xFF0A7020),
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(
                      order: orders[index],
                      onCheckout: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HarvestUpdatePage(),
                          ),
                        );
                      },
                      onRemove: () => _removeOrder(orders[index]['id']),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onCheckout;
  final VoidCallback onRemove;

  const OrderCard({
    required this.order,
    required this.onCheckout,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.green[50],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        order['farmer'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog before removing
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Remove Order'),
                              content: Text(
                                'Are you sure you want to remove this order?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onRemove();
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              ...order['items']
                  .map<Widget>(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text("${item['name']} - ${item['quantity']}"),
                    ),
                  )
                  .toList(),
              SizedBox(height: 8),
              Text(
                "Total: Rs. ${order['totalEarning'].toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: onCheckout,
                  child: Text(
                    "Check out",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF0A7020), // Custom hex color for the bottom app bar
      child: SizedBox(
        height: 45, // Reduced height for a more compact look
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
