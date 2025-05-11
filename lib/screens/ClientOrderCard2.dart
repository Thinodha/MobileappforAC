import 'package:flutter/material.dart';
import 'package:project_1/screens/order2_screen1.dart';

class ClientOrderCard2 extends StatelessWidget {
  const ClientOrderCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.account_circle, size: 30),
              SizedBox(width: 8),
              Text(
                "Client,\nHotel Galadari",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Purchase Order",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Cauliflower"),
          const Text("Eggplant"),
          const Text("Cabbage"),
          const Text("Bell pepper"),
          const Text("Cucumber"),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 100,
              height: 30,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Order2Screen1();
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "View more",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
