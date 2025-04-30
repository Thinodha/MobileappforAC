import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Stack for image and welcome text
          Stack(
            children: [
              // Image covering the entire upper part of the page
              Container(
                height:
                    MediaQuery.of(context).size.height * 0.6, // Extended height
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/agriconnect.png'),
                    fit: BoxFit.cover, // Adjusts without stretching
                  ),
                ),
              ),

              // Welcome text inside the image
              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  color: Colors.white.withOpacity(
                    0.7,
                  ), // White background like in design
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Welcome,\n',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'to ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Agri',
                          style: TextStyle(
                            color: Color(0xFF0A7020),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Box covering remaining space
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF0A7020), width: 2),
                color: Color(0xFFF5F5F5), // Light green background
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Greenery Shopping',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A7020),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Shop smart, save time! Get your fresh veggies delivered to your doorstep with our easy-to-use shopping app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Navigating to SignUpPage...");
                        Navigator.pushNamed(
                          context,
                          '/signup',
                        ); // Use named route
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A7020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Login Text inside the box
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to LoginPage
                          print("Navigating to LoginPage...");
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0A7020),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
