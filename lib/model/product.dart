import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Category { all, accessories, clothing, home }

class Product {
  const Product(
      {@required this.category,
      @required this.id,
      @required this.isFeatured,
      @required this.name,
      @required this.price})
      : assert(category != null),
        assert(id != null),
        assert(isFeatured != null),
        assert(name != null),
        assert(price != null);

  final Category category;
  final int id;
  final bool isFeatured;
  final String name;
  final int price;

  String get assetName => '$id-0.jpg';

  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name (id=$id)';

  Map<String, Object> get toMap => {
        "id": id,
        "name": name,
        "category": category.index,
        "isFeatured": isFeatured,
        "price": price
      };

  Product.fromSnapshot(DocumentSnapshot document)
      : id = document['id'],
        name = document['name'],
        category = Category.values[document['category']],
        isFeatured = document['isFeatured'],
        price = document['price'];
}
