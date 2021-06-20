import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Wishlist extends StatefulWidget {
  String process,
      item,
      ironPrice,
      washPrice,
      colorPrice,
      category,
      premiumPrice;

  Wishlist({
    Key key,
    @required this.process,
    @required this.item,
    @required this.ironPrice,
    @required this.washPrice,
    @required this.colorPrice,
    @required this.category,
    @required this.premiumPrice,
  }) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState(
      process, ironPrice, colorPrice, washPrice, category, item, premiumPrice);
}

class _WishlistState extends State<Wishlist> {
  String process,
      item,
      ironPrice,
      washPrice,
      colorPrice,
      category,
      premiumPrice,
      token;
  int quantity = 1;
  final db = FirebaseFirestore.instance;

  _WishlistState(this.process, this.ironPrice, this.colorPrice, this.washPrice,
      this.category, this.item, this.premiumPrice);

  @override
  void initState() {
    hasQuantity();
    itemWisePrice();
    tokenGen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void itemWisePrice() {
    if (ironPrice.contains("0") ||
        washPrice.contains("0") ||
        colorPrice.contains("0") ||
        premiumPrice.contains("0")) {
      db
          .collection("Item")
          .where("category", isEqualTo: category)
          .where("name", isEqualTo: item)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  setState(() {
                    this.ironPrice = doc['iron_price'];
                    this.washPrice = doc['wash_price'];
                    this.colorPrice = doc['color_price'];
                    this.premiumPrice = doc['premium_price'];
                  });
                })
              });
    }
  }

  void tokenGen() {
    db
        .collection('Token')
        .where('cart-id', isEqualTo: "01762981976")
        .where('expired', isEqualTo: "No")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.length != 0)
                {
                  querySnapshot.docs.forEach((doc) {
                    setState(() {
                      this.token = doc.id;
                    });
                  })
                }
              else
                {setToken()}
            });
  }

  void setToken() {
    db.collection("Token").add({
      'cart-id': "01762981976",
      'expired': "No",
    });
    db
        .collection("Token")
        .where("cart-id", isEqualTo: "01762981976")
        .where("expired", isEqualTo: "No")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  this.token = doc.id;
                });
              })
            });
  }

  Future<void> hasQuantity() async {
    db
        .collection('Cart')
        .where('process', isEqualTo: process)
        .where('category', isEqualTo: category)
        .where('checkout', isEqualTo: "No")
        .where('cart-id', isEqualTo: "01762981976")
        .where('name', isEqualTo: item)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  this.quantity = doc["quantity"];
                });
              })
            });
  }

  void addToCart() {
    String amount = process.contains("Iron")
        ? ironPrice
        : process.contains("Wash")
            ? washPrice
            : process.contains("Color")
                ? colorPrice
                : premiumPrice;
    db
        .collection("Cart")
        .where("cart-id", isEqualTo: "01762981976")
        .where("process", isEqualTo: process)
        .where("name", isEqualTo: item)
        .where("checkout", isEqualTo: "No")
        .where("token-id", isEqualTo: token)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.length > 0)
                {
                  querySnapshot.docs.forEach((doc) {
                    db.collection("Cart").doc(doc.id).update({
                      'cart-id': "01762981976",
                      'process': process,
                      'name': item,
                      'checkout': "No",
                      "token-id": token,
                      'per-amount': process.contains("Iron")
                          ? ironPrice
                          : process.contains("Wash")
                              ? washPrice
                              : process.contains("Color")
                                  ? colorPrice
                                  : premiumPrice,
                      'category': category,
                      'total': double.parse(amount) * quantity,
                      'quantity': quantity,
                      'date': DateTime.now()
                    });
                    print("Item Updated");
                  })
                }
              else
                {
                  db.collection("Cart").add({
                    'cart-id': "01762981976",
                    'process': process,
                    'name': item,
                    'checkout': "No",
                    "token-id": token,
                    'per-amount': process.contains("Iron")
                        ? ironPrice
                        : process.contains("Wash")
                            ? washPrice
                            : process.contains("Color")
                                ? colorPrice
                                : premiumPrice,
                    'category': category,
                    'total': double.parse(amount) * quantity,
                    'quantity': quantity,
                    'date': DateTime.now()
                  }),
                  print("Item Added")
                }
            });
    Navigator.of(context).pop();
  }

  void increase() {
    setState(() {
      this.quantity++;
    });
  }

  void decrease() {
    if (quantity > 1) {
      setState(() {
        this.quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "$process".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.unfold_more,
                  size: 30,
                ),
                onPressed: () {
                  process.contains("Iron")
                      ? this.process = "Wash"
                      : process.contains("Wash")
                          ? this.process = "Color"
                          : process.contains("Color")
                              ? this.process = "Premium"
                              : this.process = "Iron";
                  setState(() {
                    this.quantity = 1;
                  });
                  hasQuantity();
                }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ITEM : ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text(item,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("PROCESS : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text("$process",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("CATEGORY : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text(category,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("PER-PCS : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text(
                    process.contains("Iron")
                        ? ironPrice + " Tk"
                        : process.contains("Wash")
                            ? washPrice + " Tk"
                            : process.contains("Color")
                                ? colorPrice + " Tk"
                                : premiumPrice + " Tk",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("QUANTITY : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text("x  " + "$quantity",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
              thickness: 2,
              color: Colors.pink,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TOTAL AMOUNT : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text(
                    process.contains("Iron")
                        ? (double.parse(ironPrice) * quantity).toString() +
                            " Tk"
                        : process.contains("Wash")
                            ? (double.parse(washPrice) * quantity).toString()
                            : process.contains("Color")
                                ? (double.parse(colorPrice) * quantity)
                                        .toString() +
                                    " Tk"
                                : (double.parse(premiumPrice) * quantity)
                                        .toString() +
                                    " Tk",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                  height: 75,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  decrease();
                                },
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.blueGrey),
                                    child: Center(
                                      child: Text(
                                        " - ",
                                        style: TextStyle(
                                            fontSize: 28,
                                            letterSpacing: 5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "   " + quantity.toString() + "   ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'roboto'),
                                    ),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  increase();
                                },
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.pink),
                                    child: Center(
                                      child: Text(
                                        " + ",
                                        style: TextStyle(
                                            fontSize: 28,
                                            letterSpacing: 5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                              ),
                            ]),
                        TextButton(
                          onPressed: () {
                            token != null ? addToCart() : print("token null");
                          },
                          style: flatButtonStyle,
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ]))),
        ));
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(100, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    backgroundColor: Colors.green,
  );
}
