// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:project_1/services/item_services.dart'; // Make sure to import your service

// class HarvestUpdatePage1 extends StatefulWidget {
//   const HarvestUpdatePage1({super.key});

//   @override
//   State<HarvestUpdatePage1> createState() => _HarvestUpdatePage1State();
// }

// class _HarvestUpdatePage1State extends State<HarvestUpdatePage1> {
//   final _itemServices = ItemServices();
//   final user = FirebaseAuth.instance.currentUser;

//   bool _isLoading = true;
//   bool _isUpdated = false; // Add this to track if update button has been tapped
//   List<Map<String, dynamic>> vegetables = [];
//   List<Map<String, dynamic>> fruits = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedItems();
//   }

//   Future<void> _loadSelectedItems() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       if (user != null) {
//         final userData = await _itemServices.getUserSelectedItems(user!.uid);

//         setState(() {
//           vegetables = List<Map<String, dynamic>>.from(
//             userData['selectedVegetables'],
//           );
//           fruits = List<Map<String, dynamic>>.from(userData['selectedFruits']);
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error loading selected items: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load selected items: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen width and compute a scaling factor based on Pixel 4 XL's width (411.4px).
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double scaleFactor =
//         screenWidth / 411.4; // Pixel 4 XL width is 411.4px

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // "Agri" in green and "connect" in black.
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: 'Agri',
//                     style: TextStyle(
//                       color: Color(0xFF0A7020),
//                       fontSize: 24 * scaleFactor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'connect',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24 * scaleFactor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Welcome message with profile icon.
//             Row(
//               children: [
//                 Text(
//                   'Welcome Nirmala',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16 * scaleFactor,
//                   ),
//                 ),
//                 SizedBox(width: 8 * scaleFactor),
//                 Icon(
//                   Icons.account_circle,
//                   color: Colors.black,
//                   size: 24 * scaleFactor,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body:
//           _isLoading
//               ? Center(
//                 child: CircularProgressIndicator(color: Color(0xFF0A7020)),
//               )
//               : SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.all(16 * scaleFactor),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           'Update your harvest',
//                           style: TextStyle(
//                             fontSize: 20 * scaleFactor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16 * scaleFactor),
//                       _buildHarvestForm(scaleFactor),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }

//   Widget _buildHarvestForm(double scaleFactor) {
//     return Container(
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(16 * scaleFactor),
//         border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Vegetables Section
//           if (vegetables.isNotEmpty) ...[
//             Container(
//               padding: EdgeInsets.symmetric(
//                 vertical: 8 * scaleFactor,
//                 horizontal: 16 * scaleFactor,
//               ),
//               decoration: BoxDecoration(
//                 color: Color(0xFF0A7020),
//                 borderRadius: BorderRadius.circular(16 * scaleFactor),
//               ),
//               child: Text(
//                 'Harvest Quantity',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14 * scaleFactor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16 * scaleFactor),
//             Text(
//               'Vegetables',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20 * scaleFactor,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             SizedBox(height: 16 * scaleFactor),

//             // List of vegetable items
//             ...vegetables.asMap().entries.map((entry) {
//               final index = entry.key;
//               final vegetable = entry.value;
//               return _buildHarvestItem(
//                 vegetable['name'] ?? 'Unknown',
//                 vegetable['imageUrl'] ?? 'assets/images/placeholder.png',
//                 scaleFactor,
//                 'vegetable',
//                 index,
//                 vegetable['price'] ?? '',
//                 vegetable['quantity'] ?? '',
//               );
//             }).toList(),

//             SizedBox(height: 20 * scaleFactor),
//           ],

//           // Fruits Section
//           if (fruits.isNotEmpty) ...[
//             Text(
//               'Fruits',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20 * scaleFactor,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),

//             SizedBox(height: 16 * scaleFactor),

//             // List of fruit items
//             ...fruits.asMap().entries.map((entry) {
//               final index = entry.key;
//               final fruit = entry.value;
//               return _buildHarvestItem(
//                 fruit['name'] ?? 'Unknown',
//                 fruit['imageUrl'] ?? 'assets/images/placeholder.png',
//                 scaleFactor,
//                 'fruit',
//                 index,
//                 fruit['price'] ?? '',
//                 fruit['quantity'] ?? '',
//               );
//             }).toList(),
//           ],

//           // Add a row with the action buttons (reject and save)
//           SizedBox(height: 24 * scaleFactor),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // Cancel option
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.red,
//                   ),
//                   padding: EdgeInsets.all(16 * scaleFactor),
//                   child: Icon(
//                     Icons.cancel,
//                     color: Colors.white,
//                     size: 24 * scaleFactor,
//                   ),
//                 ),
//               ),
//               // Save option
//               InkWell(
//                 onTap: () {
//                   _saveHarvestUpdates();
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF0A7020),
//                   ),
//                   padding: EdgeInsets.all(16 * scaleFactor),
//                   child: Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 24 * scaleFactor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Maps to track the input values for quantity and price
//   final Map<String, Map<int, TextEditingController>> _quantityControllers = {
//     'vegetable': {},
//     'fruit': {},
//   };
//   final Map<String, Map<int, TextEditingController>> _priceControllers = {
//     'vegetable': {},
//     'fruit': {},
//   };

//   // Get or create a controller for a specific field
//   TextEditingController _getController(
//     String type,
//     int index,
//     String field,
//     String initialValue,
//   ) {
//     final controllersMap =
//         field == 'quantity' ? _quantityControllers : _priceControllers;

//     if (!controllersMap[type]!.containsKey(index)) {
//       controllersMap[type]![index] = TextEditingController(text: initialValue);
//     }

//     return controllersMap[type]![index]!;
//   }

//   Widget _buildHarvestItem(
//     String name,
//     String imagePath,
//     double scaleFactor,
//     String type,
//     int index,
//     String initialPrice,
//     String initialQuantity,
//   ) {
//     // Get or create controllers
//     final quantityController = _getController(
//       type,
//       index,
//       'quantity',
//       initialQuantity,
//     );
//     final priceController = _getController(type, index, 'price', initialPrice);

//     // Calculate total price if both price and quantity are available
//     double totalPrice = 0;
//     if (priceController.text.isNotEmpty && quantityController.text.isNotEmpty) {
//       try {
//         double price = double.parse(priceController.text);
//         double quantity = double.parse(quantityController.text);
//         totalPrice = price * quantity;
//       } catch (e) {
//         // Handle parsing errors if needed
//       }
//     }

//     return Padding(
//       padding: EdgeInsets.only(bottom: 16 * scaleFactor),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             name.toUpperCase(),
//             style: TextStyle(
//               fontSize: 16 * scaleFactor,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 8 * scaleFactor),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Left column: Item name and image
//               SizedBox(height: 8 * scaleFactor),
//               Container(
//                 width: 80 * scaleFactor,
//                 height: 80 * scaleFactor,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(imagePath),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(8 * scaleFactor),
//                 ),
//               ),
//               SizedBox(width: 16 * scaleFactor),
//               // Right column: Input fields for quantity and price
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         _buildInputField(scaleFactor, quantityController),
//                         SizedBox(width: 8 * scaleFactor),
//                         Text("Kg"),
//                       ],
//                     ),
//                     SizedBox(height: 8 * scaleFactor),
//                     Row(
//                       children: [
//                         _buildInputField(scaleFactor, priceController),
//                         SizedBox(width: 8 * scaleFactor),
//                         Text("Rupees (per 1 kg)"),
//                       ],
//                     ),
//                     // Show total price container when _isUpdated is true
//                     if (_isUpdated) ...[
//                       SizedBox(height: 8 * scaleFactor),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 6 * scaleFactor,
//                           horizontal: 10 * scaleFactor,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color(0xFF0A7020).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8 * scaleFactor),
//                           border: Border.all(
//                             color: Color(0xFF0A7020),
//                             width: 1 * scaleFactor,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.calculate_outlined,
//                               color: Color(0xFF0A7020),
//                               size: 16 * scaleFactor,
//                             ),
//                             SizedBox(width: 4 * scaleFactor),
//                             Text(
//                               "Total: ₹${totalPrice.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                 color: Color(0xFF0A7020),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14 * scaleFactor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField(
//     double scaleFactor,
//     TextEditingController controller,
//   ) {
//     return Container(
//       height: 30 * scaleFactor,
//       width: 70 * scaleFactor,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8 * scaleFactor),
//         border: Border.all(color: Colors.grey, width: 1 * scaleFactor),
//       ),
//       alignment: Alignment.center,
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         decoration: InputDecoration(
//           isCollapsed: true,
//           contentPadding: EdgeInsets.zero,
//           border: InputBorder.none,
//         ),
//         style: TextStyle(fontSize: 14 * scaleFactor),
//         onChanged: (_) {
//           // Refresh UI when input changes to recalculate total
//           if (_isUpdated) {
//             setState(() {});
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _saveHarvestUpdates() async {
//     if (user == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('User not authenticated')));
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Update vegetables
//       for (int i = 0; i < vegetables.length; i++) {
//         if (_quantityControllers['vegetable']!.containsKey(i) &&
//             _priceControllers['vegetable']!.containsKey(i)) {
//           await _itemServices.updateVegetablePriceAndQuantity(
//             uid: user!.uid,
//             index: i,
//             quantity: _quantityControllers['vegetable']![i]!.text,
//             price: _priceControllers['vegetable']![i]!.text,
//           );
//         }
//       }

//       // Update fruits
//       for (int i = 0; i < fruits.length; i++) {
//         if (_quantityControllers['fruit']!.containsKey(i) &&
//             _priceControllers['fruit']!.containsKey(i)) {
//           await _itemServices.updateFruitPriceAndQuantity(
//             uid: user!.uid,
//             index: i,
//             quantity: _quantityControllers['fruit']![i]!.text,
//             price: _priceControllers['fruit']![i]!.text,
//           );
//         }
//       }
//       await _itemServices.updateScreen(uid: user!.uid, isUpdate: true);

//       setState(() {
//         _isUpdated = true; // Set this to true to show total price containers
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Harvest information updated successfully')),
//       );

//       // Reload data to show updated values
//       await _loadSelectedItems();
//     } catch (e) {
//       await _itemServices.updateScreen(uid: user!.uid, isUpdate: false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update harvest information: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
