import 'package:badges/badges.dart';
import 'package:brightstar/account.dart';
import 'package:brightstar/cart.dart';
import 'package:brightstar/model/list.dart';
import 'package:brightstar/model/subitem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brightstar/Wishlist.dart';

class Detailes extends StatefulWidget {
  var title;
  Detailes({Key key, @required this.title}) : super(key: key);
  @override
  _DetailesState createState() => _DetailesState(this.title);
}

class _DetailesState extends State<Detailes> {
  var title, item = "Tops", q = 1, cartQuantity = 0;
  final db = FirebaseFirestore.instance;
  _DetailesState(this.title);
  List<SubItem> subitem = [];

  @override
  void initState() {
    Firebase.initializeApp();
    getItem(item);
    getCartQuantity();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPressed(i) {
    setState(() {
      this.item = i;
    });
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

  void getItem(category) {
    db
        .collection('Item')
        .where('category', isEqualTo: item)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.length != 0) {
        subitem.length != null ? subitem.clear() : print("subitem null");
        snapshot.docs.forEach((element) {
          setState(() {
            this.subitem.add(SubItem(
                name: element['name'],
                category: element['category'],
                washPrice: element['wash_price'],
                ironPrice: element['iron_price'],
                colorPrice: element['color_price'],
                premiumPrice: element['premium_price']));
          });
        });
      } else {
        subitem.clear();
        print('null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "$title".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()));
                },
                child: Icon(Icons.person)),
            SizedBox(width: 20)
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 4 / 7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal, Colors.limeAccent],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 6.0),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryData.length,
                  itemBuilder: (context, index) {
                    bool isSelected = false;
                    if (index == 0) {
                      isSelected = true;
                    }
                    return Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            onPressed(categoryData[index].name);
                            getItem(categoryData[index].name);
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                    color: categoryData[index].name == item
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 10)
                                          ]
                                        : null),
                                child: Center(
                                  child:
                                      Image.asset(categoryData[index].imageUrl),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                categoryData[index].name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
                top: 150,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: ListView.builder(
                      itemCount: subitem != null ? subitem.length : 0,
                      itemBuilder: (context, index) {
                        return _item(context: context, index: index, q: q);
                      },
                    )))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Badge(
              badgeColor: Colors.pink,
              badgeContent: Text(
                '$cartQuantity',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Icon(
                    FontAwesomeIcons.truck,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {
              cartQuantity > 0
                  ? Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()))
                  : null;
            }));
  }

  _item({context, index, q}) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: InkWell(
              onTap: () {},
              child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subitem[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wishlist(
                                              process: title,
                                              category: subitem[index].category,
                                              item: subitem[index].name,
                                              ironPrice:
                                                  subitem[index].ironPrice,
                                              colorPrice:
                                                  subitem[index].colorPrice,
                                              washPrice:
                                                  subitem[index].washPrice,
                                              premiumPrice:
                                                  subitem[index].premiumPrice,
                                            )));
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 25,
                                color: Colors.pink,
                              ),
                            )
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
                                  'IRON PRICE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  subitem[index].ironPrice.toUpperCase(),
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
                                  'WASH PRICE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  subitem[index].washPrice + " TK",
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
                                  'COLOR PRICE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  subitem[index].colorPrice.toString() + " PCS",
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
                                  'PREMIUM',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  subitem[index].premiumPrice.toString() +
                                      " TK",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )))),
    );
  }
}
