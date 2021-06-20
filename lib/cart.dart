import 'package:brightstar/Wishlist.dart';
import 'package:brightstar/details.dart';
import 'package:brightstar/model/shop.dart';
import 'package:brightstar/model/cartitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var selectedIndex = 0, netAmount = 0.0, netQuantity = 0;
  List<Shop> shopData = [];
  List<CartItem> cartData = [];
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    Firebase.initializeApp();
    getShop();
    getCart();
    getTotalAmountQuantity();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkout() {
    db
        .collection("Cart")
        .where("cart-id", isEqualTo: "01762981976")
        .where("checkout", isEqualTo: "No")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                createItemOrder(doc);
                db
                    .collection("Token")
                    .doc(doc['token-id'])
                    .update({'expired': "Yes"});
              })
            })
        .then((_) => print("Checkout"));
    Navigator.of(context).pop();
  }

  void createItemOrder(val) {
    db.collection("Cart").doc(val.id).update({
      'checkout': "Yes",
      'status': "pending",
      'shop-name': shopData[selectedIndex].name,
      'shop-address': shopData[selectedIndex].address,
      'shop-owner': shopData[selectedIndex].owner,
      'shop-mobile': shopData[selectedIndex].mobile,
      'net-amount': netAmount,
      'net-quantity': netQuantity,
      'customer-address': "Ekdala,Sirajganj",
      'customer-mobile': "01762981976"
    });
  }

  void delete(index) {
    db
        .collection("Cart")
        .doc(cartData[index].id)
        .delete()
        .then((_) => print("delete"));
  }

  void getShop() {
    db.collection('Shop').snapshots().listen((snapshot) {
      if (snapshot.docs.length != 0) {
        shopData.length != null ? shopData.clear() : print("shop null");
        snapshot.docs.forEach((element) {
          //print(element['Name']);
          setState(() {
            this.shopData.add(Shop(
                  name: element['name'],
                  owner: element['owner'],
                  address: element['address'],
                  mobile: element['mobile'],
                ));
          });
        });
      } else {
        shopData.clear();
        print('null');
      }
    });
  }

  void getCart() {
    db
        .collection('Cart')
        .where('checkout', isEqualTo: "No")
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.length != 0) {
        cartData.length != null ? cartData.clear() : print("cart null");
        snapshot.docs.forEach((element) {
          setState(() {
            this.cartData.add(CartItem(
                  id: element.id,
                  name: element['name'],
                  token: element['token-id'],
                  total: element['total'],
                  quantity: element['quantity'],
                  process: element['process'],
                  date: element['date'],
                  price: element['per-amount'],
                  category: element['category'],
                ));
          });
        });
      } else {
        cartData.clear();
        print('null');
        Navigator.of(context).pop();
      }
    });
  }

  void getTotalAmountQuantity() {
    db
        .collection('Cart')
        .where('checkout', isEqualTo: "No")
        .snapshots()
        .listen((snapshot) {
      // ignore: unnecessary_statements
      netAmount != 0.0 ? this.netAmount = 0.0 : null;
      snapshot.docs.forEach((element) {
        setState(() {
          netAmount += element['total'];
          netQuantity += element['quantity'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          elevation: 10,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Detailes(
                                title: "Iron",
                              )));
                },
                child: Icon(Icons.app_registration)),
            SizedBox(width: 20)
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select a Laundry",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: shopData.length,
                    itemBuilder: (context, index) {
                      return _shop(index: index);
                    },
                  )),
              SizedBox(height: 10),
              Text(
                "Cart",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cartData.length,
                      itemBuilder: (context, index) {
                        return _cart(index: index);
                      })),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total Amount : ",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          Text(
                            netAmount.toString() + " TK",
                            style: TextStyle(
                                fontFamily: 'Sanns-Serif',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          checkout();
                        },
                        style: flatButtonStyle,
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ))));
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(100, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    backgroundColor: Colors.pink,
  );

  _cart({index}) {
    return InkWell(
        onTap: () {},
        child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Card(
                elevation: 10,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cartData[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wishlist(
                                                process:
                                                    cartData[index].process,
                                                item: cartData[index].name,
                                                ironPrice: "0",
                                                washPrice: "0",
                                                colorPrice: "0",
                                                category:
                                                    cartData[index].category,
                                                premiumPrice: "0")));
                                  },
                                  child: Icon(
                                    Icons.app_registration,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    delete(index);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.pink,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(height: 1),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PROCESS',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartData[index].process.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PER-PCS',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartData[index].price + " TK",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QUANTITY',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartData[index].quantity.toString() + " PCS",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL AMOUNT',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartData[index].total.toString() + " TK",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )))));
  }

  _shop({index}) {
    return InkWell(
      onTap: () {
        setState(() {
          this.selectedIndex = index;
        });
      },
      child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Card(
              elevation: 10,
              color: selectedIndex == index ? Colors.green : Colors.pink,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(shopData[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 3),
                      Text(shopData[index].address,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text(
                        shopData[index].owner,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              ))),
    );
  }
}
