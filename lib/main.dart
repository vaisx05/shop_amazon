import 'package:flutter/material.dart';
import 'package:shop/pages/accountpage.dart';
import 'package:shop/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  int currentIndex = 0;

 
  final List<Widget> pages = [const HomePage(), const Accountpage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              child: Image.asset(
                'assets/icons/amazon.png', // Path to the image
                height: 30,
              ),
            ),
          ),
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          actions: [
            IconButton(
              onPressed: () {
                print("Location image pressed");
              },
              icon: Image.asset(
                'assets/icons/location.png',
                width: 25,
                height: 25,
              ),
            ),
            const Text(
              "Deliver to\nNew York 10150",
              style: TextStyle(
                fontFamily: "AmazonEmber",
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: () {
                print("Notification image pressed");
              },
              icon: Image.asset(
                'assets/icons/notification.png',
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
        body: pages[
            currentIndex], 
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                height: 30,
                width: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/account.png",
                height: 30,
                width: 30,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
