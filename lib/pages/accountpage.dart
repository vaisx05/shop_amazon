import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:shop/pages/history.dart';
import 'package:shop/pages/likes.dart';
import 'package:shop/pages/mycart.dart';

class Accountpage extends StatefulWidget {
  const Accountpage({super.key});

  @override
  State<Accountpage> createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          TopCotent(),
          SizedBox(
            height: 15,
          ),
          MenuSection(),
          SizedBox(
            height: 15,
          ),
          YourOrders(),
          SizedBox(
            height: 15,
          ),
          MyCart()
        ],
      ),
      //  backgroundColor: Colors.white,
    );
  }
}

class TopCotent extends StatefulWidget {
  const TopCotent({super.key});

  @override
  State<TopCotent> createState() => _TopCotentState();
}

class _TopCotentState extends State<TopCotent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset("assets/icons/user.png"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "  Hello, Vaishak",
                    style: TextStyle(
                        fontFamily: "PT Sans",
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
            const SizedBox(
              width: 170,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20,
                  width: 30,
                  child: CountryFlag.fromLanguageCode(
                    'hi',
                    width: 120,
                    height: 80,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 2),
                  child: Text(
                    "EN",
                    style: TextStyle(
                        fontFamily: "PT Sans",
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50), // Width and height
              ),
              child: const Text(
                "Your",
                style: TextStyle(
                    color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50), // Width and height
              ),
              child: const Text(
                "Buy Again",
                style: TextStyle(
                    color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50), // Width and height
              ),
              child: const Text(
                "Your Account",
                style: TextStyle(
                    color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LikesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50), // Width and height
              ),
              child: const Text(
                "Your List",
                style: TextStyle(
                    color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class YourOrders extends StatefulWidget {
  const YourOrders({super.key});

  @override
  State<YourOrders> createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(
              width: 13,
            ),
            Text(
              "Your Orders",
              style: TextStyle(
                  color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
            ),
            SizedBox(
              width: 235,
            ),
            Text(
              "See all",
              style: TextStyle(
                  color: Color.fromARGB(255, 49, 220, 46),
                  fontSize: 15,
                  fontFamily: "PT Sans"),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 13,
            ),
            SizedBox(
              child: GestureDetector(
                  onTap: () {},
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PurchasedPage()),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag))),
            ),
            const Text(
              "Orders",
              style: TextStyle(fontFamily: "PT Sans", fontSize: 16),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: double.infinity,
          height: 5,
          child: Container(color: const Color.fromRGBO(218, 218, 218, 60)),
        )
      ],
    );
  }
}

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(
              width: 13,
            ),
            Text(
              "Cart",
              style: TextStyle(
                  color: Colors.black, fontSize: 17, fontFamily: "PT Sans"),
            ),
            SizedBox(
              width: 295,
            ),
            Text(
              "See all",
              style: TextStyle(
                  color: Color.fromARGB(255, 49, 220, 46),
                  fontSize: 15,
                  fontFamily: "PT Sans"),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 13,
            ),
            SizedBox(
              child: GestureDetector(
                  onTap: () {},
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCartPage()),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag))),
            ),
            const Text(
              "My Cart",
              style: TextStyle(fontFamily: "PT Sans", fontSize: 16),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: double.infinity,
          height: 5,
          child: Container(color: const Color.fromRGBO(218, 218, 218, 60)),
        )
      ],
    );
  }
}
