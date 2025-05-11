import 'package:flutter/material.dart';
import 'supplier_cart.dart'; // Import PendingOrdersPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class HarvestUpdatePage extends StatefulWidget {
  const HarvestUpdatePage({super.key});

  @override
  State<HarvestUpdatePage> createState() => _HarvestUpdatePageState();
}

class _HarvestUpdatePageState extends State<HarvestUpdatePage> {
  bool _isLoading = false;
  // Reference to Firestore collection
  final CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('cart');

  // Controllers for each vegetable
  final Map<String, Map<String, TextEditingController>> _controllers = {
    'Carrot': {
      'quantity': TextEditingController(),
      'price': TextEditingController(),
    },
    'Cabbage': {
      'quantity': TextEditingController(),
      'price': TextEditingController(),
    },
    'Potato': {
      'quantity': TextEditingController(),
      'price': TextEditingController(),
    },
  };

  // Store calculated totals
  final Map<String, double> _totals = {
    'Carrot': 0.0,
    'Cabbage': 0.0,
    'Potato': 0.0,
  };

  double get totalEarning {
    return _totals.values.fold(0.0, (sum, total) => sum + total);
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to calculate totals when inputs change
    _controllers.forEach((vegetable, controllers) {
      controllers['quantity']!.addListener(() => _calculateTotal(vegetable));
      controllers['price']!.addListener(() => _calculateTotal(vegetable));
    });
  }

  void _calculateTotal(String vegetable) {
    final quantity =
        double.tryParse(_controllers[vegetable]!['quantity']!.text) ?? 0;
    final price = double.tryParse(_controllers[vegetable]!['price']!.text) ?? 0;
    setState(() {
      _totals[vegetable] = quantity * price;
    });
  }

  Future<void> _submitData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create order data
      final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final orderData = {
        'id': orderId,
        'timestamp': Timestamp.now(),
        'farmer': 'Farmer Nimal',
        'items':
            _controllers.entries.map((entry) {
              final vegetable = entry.key;
              final quantity =
                  double.tryParse(entry.value['quantity']!.text) ?? 0;
              final price = double.tryParse(entry.value['price']!.text) ?? 0;

              return {
                'name': vegetable,
                'quantity': '${quantity.toString()}kg',
                'unitPrice': price,
                'totalPrice': _totals[vegetable],
              };
            }).toList(),
        'totalEarning': totalEarning,
      };

      // Add to static orders list (keep for backward compatibility)
      OrdersData.addOrder(orderData);

      // Add to Firestore
      await cartCollection.doc(orderId).set(orderData);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order accepted and saved to Firestore successfully!',
            ),
          ),
        );

        // Navigate to PendingOrdersPage after successful submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PendingOrdersPage()),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _controllers.values.forEach((controllers) {
      controllers.values.forEach((controller) => controller.dispose());
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and compute a scaling factor based on Pixel 4 XL's width (411.4px).
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scaleFactor =
        screenWidth / 411.4; // Pixel 4 XL width is 411.4px

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Agri" in green and "connect" in black.
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Agri',
                    style: TextStyle(
                      color: Color(0xFF0A7020),
                      fontSize: 24 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'connect',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Welcome message with profile icon.
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "Sarath",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8 * scaleFactor),
                Icon(
                  Icons.account_circle,
                  color: Colors.black,
                  size: 24 * scaleFactor,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            // Make the body scrollable
            child: Padding(
              padding: EdgeInsets.all(16 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Your Order',
                      style: TextStyle(
                        fontSize: 20 * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  _buildHarvestForm(scaleFactor),
                ],
              ),
            ),
          ),
          // Overlay a loading spinner when data is being submitted
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A7020)),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A7020),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black, size: 24 * scaleFactor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
              size: 24 * scaleFactor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 24 * scaleFactor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black, size: 24 * scaleFactor),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestForm(double scaleFactor) {
    return Container(
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16 * scaleFactor),
        border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header ("Harvest Quantity").
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8 * scaleFactor,
              horizontal: 16 * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF0A7020),
              borderRadius: BorderRadius.circular(16 * scaleFactor),
            ),
            child: Text(
              'Check out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.account_circle, size: 20),
              SizedBox(width: 5),
              Text(
                "Farmer Nimal,",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16 * scaleFactor),
          // Harvest items
          _buildHarvestItem('Carrot', 'assets/carrot.jpg', scaleFactor),
          _buildHarvestItem('Cabbage', 'assets/cabbage.jpg', scaleFactor),
          _buildHarvestItem('Potato', 'assets/potato.jpg', scaleFactor),
          // Total Earning box below the list and above the action buttons
          SizedBox(height: 16 * scaleFactor),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scaleFactor,
              vertical: 8 * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8 * scaleFactor),
              border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Earning: Rs.',
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalEarning.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16 * scaleFactor),
          // Action buttons (reject, accept, and edit) below the earning box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reject option: red circular button with cross icon.
              InkWell(
                onTap:
                    _isLoading
                        ? null
                        : () {
                          // Handle the reject action here.
                          print('Harvest update rejected');
                        },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.all(16 * scaleFactor),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 24 * scaleFactor,
                  ),
                ),
              ),
              // Accept option: green circular button with check icon.
              InkWell(
                onTap: _isLoading ? null : _submitData,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  padding: EdgeInsets.all(16 * scaleFactor),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24 * scaleFactor,
                  ),
                ),
              ),
              // Edit option: white circular button with edit icon.
              InkWell(
                onTap:
                    _isLoading
                        ? null
                        : () {
                          // Handle the edit action here.
                          print('Editing harvest');
                        },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingOrdersPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
              ),
              child: Text(
                "Cart",
                style: TextStyle(
                  fontSize: 16 * scaleFactor,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestItem(String name, String imagePath, double scaleFactor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16 * scaleFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column: Vegetable name and image.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8 * scaleFactor),
              Container(
                width: 80 * scaleFactor,
                height: 80 * scaleFactor,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                ),
              ),
            ],
          ),
          SizedBox(width: 16 * scaleFactor),
          // Right column: Input fields for quantity and price, and display for total.
          Expanded(
            child: Column(
              children: [
                _buildInputField(
                  'Quantity Kg',
                  scaleFactor,
                  _controllers[name]!['quantity']!,
                ),
                SizedBox(height: 8 * scaleFactor),
                _buildInputField(
                  'Price Rupees (per 1 kg)',
                  scaleFactor,
                  _controllers[name]!['price']!,
                ),
                SizedBox(height: 8 * scaleFactor),
                // Display the total instead of an input field
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12 * scaleFactor,
                    horizontal: 8 * scaleFactor,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8 * scaleFactor),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1 * scaleFactor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price:',
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs. ${_totals[name]!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    double scaleFactor,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * scaleFactor),
        border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8 * scaleFactor),
        ),
        style: TextStyle(fontSize: 14 * scaleFactor),
        keyboardType: TextInputType.number,
        enabled: !_isLoading,
      ),
    );
  }
}
