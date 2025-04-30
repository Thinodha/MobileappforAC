import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierHarvestUpdate extends StatefulWidget {
  const SupplierHarvestUpdate({super.key});

  @override
  State<SupplierHarvestUpdate> createState() => _SupplierHarvestUpdateState();
}

class _SupplierHarvestUpdateState extends State<SupplierHarvestUpdate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentDocId = 'eEZISoQDMWsWe884nfj3'; // Initialize with default ID

  final TextEditingController _carrotQty = TextEditingController();
  final TextEditingController _carrotPrice = TextEditingController();
  final TextEditingController _carrotTotal = TextEditingController();

  final TextEditingController _cabbageQty = TextEditingController();
  final TextEditingController _cabbagePrice = TextEditingController();
  final TextEditingController _cabbageTotal = TextEditingController();

  final TextEditingController _potatoQty = TextEditingController();
  final TextEditingController _potatoPrice = TextEditingController();
  final TextEditingController _potatoTotal = TextEditingController();

  final TextEditingController _totalEarning = TextEditingController();

  bool _isEditing = false;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // First try to get the most recent document from newdocID collection
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('newdocID')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        currentDocId = querySnapshot.docs.first.get('docId') ?? currentDocId;
      }

      DocumentSnapshot doc =
          await _firestore.collection('supplier').doc(currentDocId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _carrotQty.text = data['carrot']['qty']?.toString() ?? '';
          _carrotPrice.text = data['carrot']['price']?.toString() ?? '';
          _carrotTotal.text = data['carrot']['total']?.toString() ?? '';

          _cabbageQty.text = data['cabbage']['qty']?.toString() ?? '';
          _cabbagePrice.text = data['cabbage']['price']?.toString() ?? '';
          _cabbageTotal.text = data['cabbage']['total']?.toString() ?? '';

          _potatoQty.text = data['potato']['qty']?.toString() ?? '';
          _potatoPrice.text = data['potato']['price']?.toString() ?? '';
          _potatoTotal.text = data['potato']['total']?.toString() ?? '';

          _totalEarning.text = data['totalEarning']?.toString() ?? '';
          _isDeleted = false;
        });
      } else {
        setState(() {
          _isDeleted = true;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  void _updateTotals() {
    double parse(String value) => double.tryParse(value) ?? 0;
    double carrotTotal = parse(_carrotQty.text) * parse(_carrotPrice.text);
    double cabbageTotal = parse(_cabbageQty.text) * parse(_cabbagePrice.text);
    double potatoTotal = parse(_potatoQty.text) * parse(_potatoPrice.text);
    double total = carrotTotal + cabbageTotal + potatoTotal;

    setState(() {
      _carrotTotal.text = carrotTotal.toStringAsFixed(2);
      _cabbageTotal.text = cabbageTotal.toStringAsFixed(2);
      _potatoTotal.text = potatoTotal.toStringAsFixed(2);
      _totalEarning.text = total.toStringAsFixed(2);
    });
  }

  Future<void> _updateData() async {
    if (currentDocId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document selected for update!')),
      );
      return;
    }

    final harvestData = {
      "carrot": {
        "qty": _carrotQty.text,
        "price": _carrotPrice.text,
        "total": _carrotTotal.text,
      },
      "cabbage": {
        "qty": _cabbageQty.text,
        "price": _cabbagePrice.text,
        "total": _cabbageTotal.text,
      },
      "potato": {
        "qty": _potatoQty.text,
        "price": _potatoPrice.text,
        "total": _potatoTotal.text,
      },
      "totalEarning": _totalEarning.text,
    };

    try {
      await _firestore
          .collection('supplier')
          .doc(currentDocId)
          .update(harvestData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully!')),
      );
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating data: $e')));
    }
  }

  Future<void> _deleteData() async {
    try {
      await _firestore.collection('supplier').doc(currentDocId).delete();
      await _firestore.collection('newdocID').doc(currentDocId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data deleted successfully!')),
      );
      setState(() {
        _isDeleted = true;
        _isEditing = false;
        _carrotQty.clear();
        _carrotPrice.clear();
        _carrotTotal.clear();
        _cabbageQty.clear();
        _cabbagePrice.clear();
        _cabbageTotal.clear();
        _potatoQty.clear();
        _potatoPrice.clear();
        _potatoTotal.clear();
        _totalEarning.clear();
      });
    } catch (e) {
      print('Error deleting data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting data: $e')));
    }
  }

  Future<void> _addNewData() async {
    final harvestData = {
      "carrot": {
        "qty": _carrotQty.text,
        "price": _carrotPrice.text,
        "total": _carrotTotal.text,
      },
      "cabbage": {
        "qty": _cabbageQty.text,
        "price": _cabbagePrice.text,
        "total": _cabbageTotal.text,
      },
      "potato": {
        "qty": _potatoQty.text,
        "price": _potatoPrice.text,
        "total": _potatoTotal.text,
      },
      "totalEarning": _totalEarning.text,
    };

    try {
      DocumentReference docRef = await _firestore
          .collection('supplier')
          .add(harvestData);
      currentDocId = docRef.id;

      await _firestore.collection('newdocID').doc(currentDocId).set({
        'docId': currentDocId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New data added successfully!')),
      );
      setState(() {
        _isDeleted = false;
        _isEditing = false;
      });
    } catch (e) {
      print('Error adding new data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding new data: $e')));
    }
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        readOnly: readOnly || (!_isEditing && !_isDeleted),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
        ),
        onChanged: (_) => _updateTotals(),
      ),
    );
  }

  Widget _buildProductItem(
    String title,
    String imagePath,
    TextEditingController qtyController,
    TextEditingController priceController,
    TextEditingController totalController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imagePath, height: 120, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildInput('Qty', qtyController),
                  _buildInput('Price', priceController),
                  _buildInput('Total', totalController, readOnly: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: const Color(0xFF0A7020),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/farmerHarvestUpdate');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Agri",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A7020),
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: "connect",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      "Sarath",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Icon(Icons.account_circle, color: Colors.black, size: 28),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_isDeleted)
                    Column(
                      children: [
                        const Text(
                          'Add New Products',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        _buildProductItem(
                          'Carrot',
                          'assets/images/carrot.png',
                          _carrotQty,
                          _carrotPrice,
                          _carrotTotal,
                        ),
                        _buildProductItem(
                          'Cabbage',
                          'assets/images/cabbage.png',
                          _cabbageQty,
                          _cabbagePrice,
                          _cabbageTotal,
                        ),
                        _buildProductItem(
                          'Potato',
                          'assets/images/potato.png',
                          _potatoQty,
                          _potatoPrice,
                          _potatoTotal,
                        ),
                        const SizedBox(height: 16),
                        _buildInput(
                          'Total Earnings',
                          _totalEarning,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addNewData,
                          child: const Text('Save New Data'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildProductItem(
                          'Carrot',
                          'assets/images/carrot.png',
                          _carrotQty,
                          _carrotPrice,
                          _carrotTotal,
                        ),
                        _buildProductItem(
                          'Cabbage',
                          'assets/images/cabbage.png',
                          _cabbageQty,
                          _cabbagePrice,
                          _cabbageTotal,
                        ),
                        _buildProductItem(
                          'Potato',
                          'assets/images/potato.png',
                          _potatoQty,
                          _potatoPrice,
                          _potatoTotal,
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Total Earnings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        _buildInput(
                          'Total Earnings',
                          _totalEarning,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _deleteData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_isEditing) {
                                  _updateData();
                                } else {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                }
                              },
                              child: Text(_isEditing ? 'Save' : 'Edit'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}
