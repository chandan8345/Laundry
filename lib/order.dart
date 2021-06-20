import 'package:brightstar/model/pending.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  var tabIndex = 0;
  final db = FirebaseFirestore.instance;
  List<Pending> pendingList = [];
  List<Pending> pickedList = [];
  List<Pending> deliveriedList = [];
  List<Pending> canceledList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callNumber(number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  delete(token) {
    db
        .collection("Cart")
        .where("token-id", isEqualTo: token)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                db.collection("Cart").doc(element.id).delete();
              })
            });
    db.collection("Token").doc(token).delete();
    getData();
  }

  remove(token) {
    db
        .collection("Cart")
        .where("token-id", isEqualTo: token)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                db
                    .collection("Cart")
                    .doc(element.id)
                    .update({'status': "canceled"});
              })
            });
    getData();
  }

  getData() {
    db.collection("Token").snapshots().listen((snapshot) {
      pendingList.clear();
      pickedList.clear();
      deliveriedList.clear();
      canceledList.clear();
      snapshot.docs.forEach((element){
         statusWiseData(element.id);
      });
    });
  }

  statusWiseData(tokenId) {
    var status;
    db
        .collection("Cart")
        .where("token-id", isEqualTo: tokenId)
        .where("checkout", isEqualTo: "Yes")
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        status = element['status'];
      });
    });
    print(status);
    var quantity = 0,
        amount = 0.0,
        shop,
        shopAddress,
        customerAddress,
        token,
        shopMobile,
        customerMobile;
    db
        .collection("Cart")
        .where("checkout", isEqualTo: "Yes")
        .where("token-id", isEqualTo: tokenId)
        .where("status", isEqualTo: status)
        .limit(1)
        //   .snapshots()
        //   .listen((event) {
        // event.docs.forEach((doc) {
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                quantity = doc['net-quantity'];
                amount = doc['net-amount'];
                shop = doc['shop-name'];
                shopAddress = doc['shop-address'];
                customerAddress = doc['customer-address'];
                token = tokenId;
                shopMobile = doc['shop-mobile'];
                customerMobile = doc['customer-mobile'];
                status == "pending"
                    ? setState(() {
                        this.pendingList.add(Pending(
                            shop: shop,
                            shopAddress: shopAddress,
                            customerAddress: customerAddress,
                            shopMobile: shopMobile,
                            customerMobile: customerMobile,
                            quantity: quantity,
                            total: amount,
                            token: tokenId));
                      })
                    : status == "picked"
                        ? setState(() {
                            this.pickedList.add(Pending(
                                shop: shop,
                                shopAddress: shopAddress,
                                customerAddress: customerAddress,
                                shopMobile: shopMobile,
                                customerMobile: customerMobile,
                                quantity: quantity,
                                total: amount,
                                token: tokenId));
                          })
                        : status == "delivered"
                            ? setState(() {
                                this.deliveriedList.add(Pending(
                                    shop: shop,
                                    shopAddress: shopAddress,
                                    customerAddress: customerAddress,
                                    shopMobile: shopMobile,
                                    customerMobile: customerMobile,
                                    quantity: quantity,
                                    total: amount,
                                    token: tokenId));
                              })
                            : setState(() {
                                this.canceledList.add(Pending(
                                    shop: shop,
                                    shopAddress: shopAddress,
                                    customerAddress: customerAddress,
                                    shopMobile: shopMobile,
                                    customerMobile: customerMobile,
                                    quantity: quantity,
                                    total: amount,
                                    token: tokenId));
                              });
              }),
            });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white.withOpacity(0.98),
        appBar: AppBar(
          title: Text(
            "Orders",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black),
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              width: width,
              color: Colors.white.withOpacity(0.98),
              child: SingleChildScrollView(
                child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        TabBar(
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          indicatorColor: Colors.blueGrey,
                          onTap: (index) {
                            setState(() {
                              this.tabIndex = index;
                            });
                          },
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                'PENDING',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'PICKED',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'DELEVERED',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            width: width,
                            height: height,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 5),
                              child: TabBarView(
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    pendingListView(),
                                    pickedListView(),
                                    deliveredListView(),
                                    cancelListView()
                                  ]),
                            ))
                      ],
                    )),
              ),
            ),
          ],
        ));
  }

  pendingListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: pendingList.length != 0 ? pendingList.length : 0,
      itemBuilder: (context, index) {
        return pending(index);
      },
    );
  }

  pickedListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: pickedList.length != 0 ? pickedList.length : 0,
      itemBuilder: (context, index) {
        return picked(index);
      },
    );
  }

  deliveredListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: deliveriedList.length != 0 ? deliveriedList.length : 0,
      itemBuilder: (context, index) {
        return deliveried(index);
      },
    );
  }

  cancelListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: canceledList.length != 0 ? canceledList.length : 0,
      itemBuilder: (context, index) {
        return canceled(index);
      },
    );
  }

  pending(index) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pendingList[index].shop,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    Text(
                      pendingList[index].shopAddress,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _callNumber(pendingList[index].shopMobile);
                      },
                      child: Icon(
                        Icons.call,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        remove(pendingList[index].token);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(height: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QUANTITY',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      pendingList[index].quantity.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: Colors.blue,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NET AMOUNT',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      pendingList[index].total.toString() + " TK",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ));
  }

  picked(index) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickedList[index].shop,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    Text(
                      pickedList[index].shopAddress,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _callNumber(pickedList[index].shopMobile);
                      },
                      child: Icon(
                        Icons.call,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        remove(pickedList[index].token);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(height: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QUANTITY',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      pickedList[index].quantity.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: Colors.blue,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NET AMOUNT',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      pickedList[index].total.toString() + " TK",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ));
  }

  deliveried(index) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveriedList[index].shop,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    Text(
                      deliveriedList[index].shopAddress,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _callNumber(deliveriedList[index].shopMobile);
                      },
                      child: Icon(
                        Icons.call,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        remove(deliveriedList[index].token);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(height: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QUANTITY',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      deliveriedList[index].quantity.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: Colors.blue,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NET AMOUNT',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      deliveriedList[index].total.toString() + " TK",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ));
  }

  canceled(index) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canceledList[index].shop,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    Text(
                      canceledList[index].shopAddress,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        delete(canceledList[index].token);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(height: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QUANTITY',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      canceledList[index].quantity.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: Colors.blue,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NET AMOUNT',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      canceledList[index].total.toString() + " TK",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ));
  }

  Widget list(width) => Padding(
        padding: EdgeInsets.only(),
        child: Container(
          width: width,
          height: 100,
          color: Colors.red,
          child: Text("gsdfsfdf"),
        ),
      );
}
