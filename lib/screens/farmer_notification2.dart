import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      debugShowCheckedModeBanner: false,
      home: ContactSupplierPage(),
    );
  }
}

class ContactSupplierPage extends StatelessWidget {
  const ContactSupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar (reused from previous code)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Branding: "Agri" (green) + "connect" (black)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Agri',
                    style: TextStyle(
                      color: Color(0xFF0A7020),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'connect',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Welcome message and profile icon
            Row(
              children: [
                Text(
                  'Welcome, Nimal',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(width: 8),
                Icon(Icons.account_circle, color: Colors.black, size: 24),
              ],
            ),
          ],
        ),
      ),
      // Body: Conversation view with a header and chat bubbles
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title on top
            Center(
              child: Text(
                'Contact with the supplier',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            // Expanded ListView to display the conversation
            Expanded(
              child: ListView(
                children: [
                  // Supplier message: includes accept and reject options.
                  ChatBubble(
                    sender: "Saman",
                    message: "Carrot: 50kg available.",
                    isSupplier: true,
                  ),
                  // User reply: no accept/reject options.
                  ChatBubble(
                    sender: "You",
                    message: "Confirmed order for Carrot.",
                    isSupplier: false,
                  ),
                  // Another supplier message.
                  ChatBubble(
                    sender: "Saman",
                    message: "Cabbage: 20kg available.",
                    isSupplier: true,
                  ),
                  // User reply.
                  ChatBubble(
                    sender: "You",
                    message: "Rejected order for Cabbage.",
                    isSupplier: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (reused from previous examples)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0A7020),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            label: '',
          ),
        ],
      ),
    );
  }
}

/// ChatBubble widget displays each message inside a square-bordered container.
/// The header of the bubble shows a profile icon and sender's name.
/// If the message is from the supplier, accept and reject action icons are shown below the message.
class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isSupplier;

  const ChatBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isSupplier,
  });

  @override
  Widget build(BuildContext context) {
    // Supplier messages are aligned left; user messages aligned right.
    Alignment alignment =
    isSupplier ? Alignment.centerLeft : Alignment.centerRight;
    // Use a subtle background tint.
    Color bubbleColor =
    isSupplier ? Colors.grey.shade200 : Colors.green.shade100;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        // Square border with no rounded corners.
        decoration: BoxDecoration(
          color: bubbleColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: profile icon and sender's name.
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isSupplier ? Colors.grey : Color(0xFF0A7020),
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  sender,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // Message text.
            Text(message, style: TextStyle(fontSize: 14, color: Colors.black)),
            // Accept and Reject options (only for supplier messages).
            if (isSupplier) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Accept option.
                  InkWell(
                    onTap: () {
                      print('Accepted message from $sender');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF0A7020),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Accept",
                          style: TextStyle(
                            color: Color(0xFF0A7020),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Reject option.
                  InkWell(
                    onTap: () {
                      print('Rejected message from $sender');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 20),
                        SizedBox(width: 4),
                        Text(
                          "Reject",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}