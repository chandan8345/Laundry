class list {
  final String name;
  final String count;
  final String imageUrl;

  list({this.imageUrl, this.name, this.count});
}

List<list> categoryData = [
  new list(
    imageUrl:"assets/item/tshirt.png",
    name: "Tops",
    count: "6"
  ),
  new list(
    imageUrl: "assets/item/jeans.png",
    name: "Bottoms",
    count: "6"
  ),
  new list(
    imageUrl:"assets/item/dress.png",
    name: "Dresses",
    count: "6"
  ),
  new list(
    imageUrl:"assets/item/suit.png",
    name: "Suits",
    count: "6"
  ),
  new list(
    imageUrl:"assets/item/praying.png",
    name: "Religious",
    count: "6"
  ),
    new list(
    imageUrl:"assets/item/hooded-jacket.png",
    name: "Winter",
    count: "6"
  ),
      new list(
    imageUrl:"assets/item/hooded-jacket.png",
    name: "Others",
    count: "6"
  ),

];
