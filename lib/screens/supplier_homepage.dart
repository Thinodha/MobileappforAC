import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupplierHomepage extends StatelessWidget {
  const SupplierHomepage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The best prices,",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 8),
            _buildPriceCard(context),
            const SizedBox(height: 16),
            const Text(
              "Farmers you may be interested in,",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            _buildFarmerCard(context, "Nimal", [
              "Carrot",
              "Cabbage",
              "Potato",
            ], 4.5),
            _buildFarmerCard(context, "Kasun", [
              "Carrot",
              "Beetroot",
              "Beans",
            ], 4.3),
            const SizedBox(height: 16),
            const Text(
              "Hotel/restaurant owners you interact with,",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            _buildClientCard(context, "Shangri-La", [
              "Carrot",
              "Tomato",
              "Beetroot",
            ]),
            _buildClientCard(context, "Cinnamon Grand", [
              "Carrot",
              "Beans",
              "Potato",
            ]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F3E6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('supplier')
                  .doc('T3njwlokEjRHeCwpaTlJ')
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading prices'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            var products =
                data.keys.where((key) => key != 'totalEarning').toList();

            return Column(
              children: [
                ...products.map((product) {
                  var productData = data[product];
                  if (productData is Map<String, dynamic>) {
                    String price = productData['price'] ?? "0";
                    return _buildPriceRow(product, "Rs.${price}/kg");
                  } else {
                    return const SizedBox();
                  }
                }).toList(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildViewMoreButton(context, '/details'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceRow(String item, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$item - $price", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFarmerCard(
    BuildContext context,
    String name,
    List<String> products,
    double rating,
  ) {
    return Card(
      color: Colors.green.shade50,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, size: 30),
                const SizedBox(width: 8),
                Text("Farmer,\n$name", style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Icon(Icons.star, color: Colors.yellow[700]),
                Text(rating.toString(), style: const TextStyle()),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Harvest products",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...products.map((p) => Text(p)).toList(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buildViewMoreButton(context, '/farmerDetails')],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(
    BuildContext context,
    String name,
    List<String> orders,
  ) {
    return Card(
      color: Colors.green.shade50,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, size: 30),
                const SizedBox(width: 8),
                Text("Client,\n$name", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Purchase order",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...orders.map((o) => Text(o)).toList(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _buildViewMoreButton(context, '/details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMoreButton(BuildContext context, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text("View more", style: TextStyle(color: Colors.black)),
        ),
      ),
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
            icon: const Icon(Icons.favorite, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/farmerHarvestUpdate');
            },
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: const Color(0xFF0A7020),
      ),
      body: const Center(
        child: Text("More details here.", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class HarvestDetailPage extends StatelessWidget {
  const HarvestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harvest Details"),
        backgroundColor: const Color(0xFF0A7020),
      ),
      body: const Center(
        child: Text(
          "Details about the farmer's harvest.",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FarmerDetailPage extends StatelessWidget {
  const FarmerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Details"),
        backgroundColor: const Color(0xFF0A7020),
      ),
      body: const Center(
        child: Text(
          "Details about the selected farmer.",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
