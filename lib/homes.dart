import 'package:brightstar/account.dart';
import 'package:brightstar/cart.dart';
import 'package:brightstar/details.dart';
import 'package:brightstar/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedIndex = 0, cartQuantity = 0;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    Firebase.initializeApp();
    getCartQuantity();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCartQuantity() {
    db
        .collection('Cart')
        .where('cart-id', isEqualTo: "01762981976")
        .where('checkout', isEqualTo: "No")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        this.cartQuantity = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          //overflow: Overflow.visible,
          fit: StackFit.loose,
          children: <Widget>[
            ClipPath(
              //clipper: ClippingClass(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 4 / 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green, Colors.white70],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 80,
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/home_images/user.png"),
              ),
            ),
            Positioned(
              left: 20,
              top: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Hi John",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      )),
                  Text(
                      "Get your laundry washed, folded \nand delivered straight to your door.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                ],
              ),
            ),
            Positioned(
              left: 20,
              top: 280,
              right: 20,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _customCard(
                            imageUrl: "ironing.png",
                            item: "Iron",
                            duration: "1 Days",
                            context: context),
                        _customCard(
                            imageUrl: "washing-machine.png",
                            item: "Wash",
                            duration: "3 Day",
                            context: context),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _customCard(
                            imageUrl: "dry.png",
                            item: "Color",
                            duration: "5 Days",
                            context: context),
                        _customCard(
                            imageUrl: "clean.png",
                            item: "Premium",
                            duration: "3 Days",
                            context: context)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBorderColor: Colors.transparent,
            selectedItemBackgroundColor: Colors.deepOrange,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
            showSelectedItemShadow: true,
            barHeight: 70,
          ),
          selectedIndex: selectedIndex,
          onSelectTab: (index) {
            setState(() {
              selectedIndex = index;
            });
            switch (index) {
              case 0:
                break;
              case 1:
                cartQuantity > 0
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()))
                    : null;
                break;
              case 2:
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Order()));
                break;
              case 3:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Account()));
                break;
              case 4:
                break;
            }
          },
          items: [
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.home,
              label: 'Home',
              //selectedBackgroundColor: Colors.pink,
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.shoppingBag,
              label: 'Cart',
              //selectedBackgroundColor: Colors.blue,
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.firstOrderAlt,
              label: 'Orders',
              //selectedBackgroundColor: Colors.purple,
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.dashcube,
              label: 'Account',
              //selectedBackgroundColor: Colors.orange,
            ),
          ],
        ));
  }
}

class Orders {}

_customCard({String imageUrl, String item, String duration, context}) {
  return SizedBox(
      height: 168,
      width: 150,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Detailes(
                        title: item,
                      )));
          print(item);
        },
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/home_images/" + imageUrl),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(duration)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var controlPoint = Offset(size.width - (size.width / 2), size.height - 180);
    var endPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
