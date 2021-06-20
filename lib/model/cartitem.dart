import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String id;
  String name;
  String category;
  String price;
  String process;
  double total;
  int quantity;
  Timestamp date;
  String token;

  CartItem({
    this.id,
    this.name,
    this.category,
    this.price,
    this.process,
    this.total,
    this.quantity,
    this.date,
    this.token,
  });
}
