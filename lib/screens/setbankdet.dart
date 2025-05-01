import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SetupBankPage extends StatelessWidget {
  final _authService = AuthService();

  final nameController = TextEditingController();
  final accountNoController = TextEditingController();
  final bankController = TextEditingController();
  final branchController = TextEditingController();

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
                child: Text(
                  'Your bank details',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: 'Name',
                hintText: 'Enter your name',
                controller: nameController,
              ),
              buildTextField(
                label: 'Account no',
                hintText: 'Enter your account number',
                controller: accountNoController,
              ),
              buildTextField(
                label: 'Bank',
                hintText: 'Enter your bank',
                controller: bankController,
              ),
              buildTextField(
                label: 'Branch',
                hintText: 'Enter your bank branch',
                controller: branchController,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      try {
                        await _authService.saveBankDetails(
                          uid: user.uid,
                          name: nameController.text.trim(),
                          accountNumber: accountNoController.text.trim(),
                          bank: bankController.text.trim(),
                          branch: branchController.text.trim(),
                        );
                        Navigator.pushNamed(context, '/selectveg');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to save bank details: $e'),
                          ),
                        );
                      }
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
