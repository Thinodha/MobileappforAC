import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SetupAccountPage extends StatelessWidget {
  final _authService = AuthService();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final fieldAddressController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
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
              const SizedBox(height: 10),
              const Text(
                'Set up your account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('Welcome farmers!', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: 'Name',
                hintText: 'Enter your name',
                controller: nameController,
              ),
              buildTextField(
                label: 'Address',
                hintText: 'Enter your address',
                controller: addressController,
              ),
              buildTextField(
                label: 'Address (field)',
                hintText: 'Enter your field address',
                controller: fieldAddressController,
              ),
              buildTextField(
                label: 'Phone no',
                hintText: 'Enter your phone number',
                controller: phone1Controller,
              ),
              buildTextField(
                label: 'Phone no 2',
                hintText: 'Enter your phone number',
                controller: phone2Controller,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await _authService.saveFarmerDetails(
                          uid: user.uid,
                          name: nameController.text.trim(),
                          address: addressController.text.trim(),
                          fieldAddress: fieldAddressController.text.trim(),
                          phone1: phone1Controller.text.trim(),
                          phone2: phone2Controller.text.trim(),
                        );
                        Navigator.pushNamed(context, '/setbankdet');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save details: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A7020),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0A7020)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
