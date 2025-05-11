import 'package:flutter/material.dart';

class FarmerChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                Icon(Icons.account_circle, size: 30, color: Colors.black),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Contact with the farmer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ChatBubble(
                    isUser: true,
                    text: "Carrot: 50kg",
                    name: "You",
                    isAlignedLeft: true,
                  ),
                  ChatBubble(
                    isUser: false,
                    text: "Order confirmed!",
                    name: "Farmer Nimal",
                    isAlignedLeft: false,
                  ),
                  ChatBubble(
                    isUser: true,
                    text: "Cabbage: 20kg",
                    name: "You",
                    isAlignedLeft: true,
                  ),
                  ChatBubble(
                    isUser: false,
                    text: "Order rejected!",
                    name: "Farmer Nimal",
                    isAlignedLeft: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final String name;
  final bool isAlignedLeft;

  ChatBubble({
    required this.isUser,
    required this.text,
    required this.name,
    required this.isAlignedLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isAlignedLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAlignedLeft)
            Icon(Icons.account_circle, size: 30, color: Colors.black),
          if (isAlignedLeft) SizedBox(width: 5),
          Column(
            crossAxisAlignment:
                isAlignedLeft
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                padding: EdgeInsets.all(8),
                child: Text(text),
              ),
            ],
          ),
          if (!isAlignedLeft) SizedBox(width: 5),
          if (!isAlignedLeft)
            Icon(Icons.account_circle, size: 30, color: Colors.black),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF0A7020),
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.eco, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
