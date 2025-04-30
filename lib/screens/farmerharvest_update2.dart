import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_1/services/item_services.dart';

class HarvestUpdatePage extends StatefulWidget {
  const HarvestUpdatePage({super.key});

  @override
  State<HarvestUpdatePage> createState() => _HarvestUpdatePageState();
}

class _HarvestUpdatePageState extends State<HarvestUpdatePage> {
  final _itemServices = ItemServices();
  final user = FirebaseAuth.instance.currentUser;

  bool _isLoading = true;
  bool _isUpdate = false;
  bool _editMode = false;
  List<Map<String, dynamic>> vegetables = [];
  List<Map<String, dynamic>> fruits = [];
  double totalEarning = 0.0;
  String? userName;

  // Maps to track controllers
  final Map<String, Map<int, TextEditingController>> _quantityControllers = {
    'vegetable': {},
    'fruit': {},
  };
  final Map<String, Map<int, TextEditingController>> _priceControllers = {
    'vegetable': {},
    'fruit': {},
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      if (user != null) {
        // Load update status
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();

        if (userDoc.exists) {
          // Check if the field exists using the contains method
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey('isUpdate')) {
            _isUpdate = userData['isUpdate'] ?? false;
          } else {
            // Initialize the field if it doesn't exist
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .set({'isUpdate': false}, SetOptions(merge: true));
            _isUpdate = false;
          }
          userName = userData['username'] ?? 'User';
        }

        // Load selected items
        final userData = await _itemServices.getUserSelectedItems(user!.uid);
        setState(() {
          vegetables = List<Map<String, dynamic>>.from(
            userData['selectedVegetables'],
          );
          fruits = List<Map<String, dynamic>>.from(userData['selectedFruits']);
          _calculateTotalEarning();
          _isLoading = false;
          _editMode = !_isUpdate;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  //Calculation of total earning
  void _calculateTotalEarning() {
    double total = 0.0;

    for (var vegetable in vegetables) {
      final price = double.tryParse(vegetable['price'] ?? '0') ?? 0.0;
      final quantity = double.tryParse(vegetable['quantity'] ?? '0') ?? 0.0;
      total += price * quantity;
    }

    for (var fruit in fruits) {
      final price = double.tryParse(fruit['price'] ?? '0') ?? 0.0;
      final quantity = double.tryParse(fruit['quantity'] ?? '0') ?? 0.0;
      total += price * quantity;
    }

    totalEarning = total;
  }

  TextEditingController _getController(
    String type,
    int index,
    String field,
    String initialValue,
  ) {
    final controllersMap =
        field == 'quantity' ? _quantityControllers : _priceControllers;
    if (!controllersMap[type]!.containsKey(index)) {
      controllersMap[type]![index] = TextEditingController(text: initialValue);
    }
    return controllersMap[type]![index]!;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scaleFactor = screenWidth / 411.4;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Row(
              children: [
                Text(
                  'Welcome ${userName ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16 * scaleFactor,
                  ),
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
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF0A7020)),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16 * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _isUpdate ? 'Your Earnings' : 'Update your harvest',
                          style: TextStyle(
                            fontSize: 20 * scaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * scaleFactor),
                      _isUpdate && !_editMode
                          ? _buildEarningsView(scaleFactor)
                          : _buildHarvestForm(scaleFactor),
                    ],
                  ),
                ),
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
          // Header
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
              _isUpdate ? 'Earnings Details' : 'Harvest Quantity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16 * scaleFactor),

          // Vegetables Section
          if (vegetables.isNotEmpty) ...[
            Text(
              'Vegetables',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20 * scaleFactor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            ...vegetables.asMap().entries.map((entry) {
              return _buildFormItem(
                entry.value['name'] ?? 'Unknown',
                entry.value['imageUrl'] ?? 'assets/images/placeholder.png',
                scaleFactor,
                'vegetable',
                entry.key,
                entry.value['price'] ?? '',
                entry.value['quantity'] ?? '',
              );
            }).toList(),
            SizedBox(height: 20 * scaleFactor),
          ],

          // Fruits Section
          if (fruits.isNotEmpty) ...[
            Text(
              'Fruits',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20 * scaleFactor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            ...fruits.asMap().entries.map((entry) {
              return _buildFormItem(
                entry.value['name'] ?? 'Unknown',
                entry.value['imageUrl'] ?? 'assets/images/placeholder.png',
                scaleFactor,
                'fruit',
                entry.key,
                entry.value['price'] ?? '',
                entry.value['quantity'] ?? '',
              );
            }).toList(),
          ],

          // Total Earnings
          // if (_isUpdate) ...[
          //   SizedBox(height: 20 * scaleFactor),
          //   _buildTotalEarningsBox(scaleFactor),
          // ],

          // Action buttons
          SizedBox(height: 24 * scaleFactor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel button
              _buildActionButton(
                scaleFactor,
                Colors.red,
                Icons.cancel,
                Colors.white,
                () {
                  if (_isUpdate && _editMode) {
                    setState(() => _editMode = false);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              // Save button
              _buildActionButton(
                scaleFactor,
                Color(0xFF0A7020),
                Icons.check,
                Colors.white,
                () => _saveHarvestUpdates(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsView(double scaleFactor) {
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
          // Header
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
              'Earnings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16 * scaleFactor),

          // Vegetables Section
          if (vegetables.isNotEmpty) ...[
            Text(
              'Vegetables',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20 * scaleFactor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            ...vegetables.asMap().entries.map((entry) {
              return _buildFormItem(
                entry.value['name'] ?? 'Unknown',
                entry.value['imageUrl'] ?? 'assets/images/placeholder.png',
                scaleFactor,
                'vegetable',
                entry.key,
                entry.value['price'] ?? '',
                entry.value['quantity'] ?? '',
              );
            }).toList(),
            SizedBox(height: 20 * scaleFactor),
          ],

          // Fruits Section
          if (fruits.isNotEmpty) ...[
            Text(
              'Fruits',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20 * scaleFactor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            ...fruits.asMap().entries.map((entry) {
              return _buildFormItem(
                entry.value['name'] ?? 'Unknown',
                entry.value['imageUrl'] ?? 'assets/images/placeholder.png',
                scaleFactor,
                'fruit',
                entry.key,
                entry.value['price'] ?? '',
                entry.value['quantity'] ?? '',
              );
            }).toList(),
            SizedBox(height: 20 * scaleFactor),
          ],

          // Total Earnings
          _buildTotalEarningsBox(scaleFactor),

          SizedBox(height: 16 * scaleFactor),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reject button
              // _buildActionButton(
              //   scaleFactor,
              //   Colors.red,
              //   Icons.cancel,
              //   Colors.white,
              //   () async {
              //     if (user != null) {
              //       await _itemServices.updateScreen(
              //         uid: user!.uid,
              //         isUpdate: false,
              //       );
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Harvest update rejected')),
              //       );
              //       await _loadData();
              //     }
              //   },
              // ),
              // Accept button
              _buildActionButton(
                scaleFactor,
                Color(0xFF0A7020),
                Icons.check,
                Colors.white,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harvest update accepted')),
                  );
                },
              ),
              // Edit button
              _buildActionButton(
                scaleFactor,
                Colors.white,
                Icons.edit,
                Colors.black,
                () {
                  //Its taking 1 as monday(Consider the 1st day of the week is monday)
                  if (DateTime.now().weekday == 1) {
                    setState(() => _editMode = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Update the harvest with relevant quantities and prices',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Harvest update only can be done in Monday',
                        ),
                      ),
                    );
                  }
                },
                hasBorder: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalEarningsBox(double scaleFactor) {
    return Container(
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
            'Total Earnings:',
            style: TextStyle(
              fontSize: 16 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Rs  ${totalEarning.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    double scaleFactor,
    Color bgColor,
    IconData icon,
    Color iconColor,
    Function() onTap, {
    bool hasBorder = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: hasBorder ? Border.all(color: Colors.grey) : null,
        ),
        padding: EdgeInsets.all(16 * scaleFactor),
        child: Icon(icon, color: iconColor, size: 24 * scaleFactor),
      ),
    );
  }

  Widget _buildFormItem(
    String name,
    String imagePath,
    double scaleFactor,
    String type,
    int index,
    String initialPrice,
    String initialQuantity,
  ) {
    final quantityController = _getController(
      type,
      index,
      'quantity',
      initialQuantity,
    );
    final priceController = _getController(type, index, 'price', initialPrice);

    double quantityNum = double.tryParse(quantityController.text) ?? 0;
    double priceNum = double.tryParse(priceController.text) ?? 0;
    double totalPrice = quantityNum * priceNum;

    return Padding(
      padding: EdgeInsets.only(bottom: 16 * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 16 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8 * scaleFactor),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
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
              SizedBox(width: 16 * scaleFactor),
              // Input fields
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quantity field
                    Row(
                      children: [
                        _buildInputField(
                          scaleFactor,
                          quantityController,
                          readOnly: _isUpdate && !_editMode,
                        ),
                        SizedBox(width: 8 * scaleFactor),
                        Text("Kg"),
                      ],
                    ),
                    SizedBox(height: 8 * scaleFactor),
                    // Price field
                    Row(
                      children: [
                        _buildInputField(
                          scaleFactor,
                          priceController,
                          readOnly: _isUpdate && !_editMode,
                        ),
                        SizedBox(width: 8 * scaleFactor),
                        Text("Rupees (per 1 kg)"),
                      ],
                    ),
                    // Total price row
                    if (!_editMode) ...[
                      SizedBox(height: 8 * scaleFactor),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(width: 0.3),
                          borderRadius: BorderRadius.circular(8 * scaleFactor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Price:",
                                style: TextStyle(
                                  fontSize: 14 * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Rs  ${totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14 * scaleFactor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              //Expanded(child: Container()),
              if (_editMode)
                IconButton(
                  onPressed: () async {
                    if (type == 'vegetable') {
                      await _itemServices.deleteVegetableItem(
                        uid: user!.uid,
                        index: index,
                      );
                    } else {
                      await _itemServices.deleteFruitItem(
                        uid: user!.uid,
                        index: index,
                      );
                    }
                    await _loadData();
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildViewItem(
  //   String name,
  //   String imagePath,
  //   String quantity,
  //   String price,
  //   double scaleFactor,
  // ) {
  //   // Calculate total price for this item
  //   double quantityNum = double.tryParse(quantity) ?? 0;
  //   double priceNum = double.tryParse(price) ?? 0;
  //   double totalPrice = quantityNum * priceNum;

  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 16 * scaleFactor),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         // Left column: Item name and image
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               name.toUpperCase(),
  //               style: TextStyle(
  //                 fontSize: 16 * scaleFactor,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             SizedBox(height: 8 * scaleFactor),
  //             Container(
  //               width: 80 * scaleFactor,
  //               height: 80 * scaleFactor,
  //               decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                   image: AssetImage(imagePath),
  //                   fit: BoxFit.cover,
  //                 ),
  //                 borderRadius: BorderRadius.circular(8 * scaleFactor),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(width: 16 * scaleFactor),
  //         // Right column: Details
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildInfoRow("Quantity:", "$quantity Kg", scaleFactor),
  //               SizedBox(height: 8 * scaleFactor),
  //               _buildInfoRow("Price (per Kg):", "$price Rs", scaleFactor),
  //               SizedBox(height: 8 * scaleFactor),
  //               _buildInfoRow(
  //                 "Total Price:",
  //                 "Rs.${totalPrice.toStringAsFixed(2)}",
  //                 scaleFactor,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoRow(String label, String value, double scaleFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14 * scaleFactor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14 * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    double scaleFactor,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Container(
      height: 30 * scaleFactor,
      width: 70 * scaleFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * scaleFactor),
        border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
        color: readOnly ? Colors.grey.shade200 : Colors.white,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        readOnly: readOnly,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 14 * scaleFactor),
        onChanged: (_) {
          if (_isUpdate) {
            setState(() => _calculateTotalEarning());
          }
        },
      ),
    );
  }

  Future<void> _saveHarvestUpdates() async {
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not authenticated')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update vegetables
      for (int i = 0; i < vegetables.length; i++) {
        if (_quantityControllers['vegetable']!.containsKey(i) &&
            _priceControllers['vegetable']!.containsKey(i)) {
          await _itemServices.updateVegetablePriceAndQuantity(
            uid: user!.uid,
            index: i,
            quantity: _quantityControllers['vegetable']![i]!.text,
            price: _priceControllers['vegetable']![i]!.text,
          );
        }
      }

      // Update fruits
      for (int i = 0; i < fruits.length; i++) {
        if (_quantityControllers['fruit']!.containsKey(i) &&
            _priceControllers['fruit']!.containsKey(i)) {
          await _itemServices.updateFruitPriceAndQuantity(
            uid: user!.uid,
            index: i,
            quantity: _quantityControllers['fruit']![i]!.text,
            price: _priceControllers['fruit']![i]!.text,
          );
        }
      }

      if (_isUpdate && _editMode) {
        setState(() => _editMode = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Earnings information updated successfully')),
        );
      } else {
        await _itemServices.updateScreen(uid: user!.uid, isUpdate: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harvest information updated successfully')),
        );
        await _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update information: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
