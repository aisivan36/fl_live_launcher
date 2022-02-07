import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

enum ProductSortType {
  name,
  price,
}

final productSortTypeProvider = StateProvider<ProductSortType>(
  // We return the default sort type, here name.
  (ref) => ProductSortType.name,
);

class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: 'iPhone', price: 999),
  Product(name: 'cookie', price: 2),
  Product(name: 'ps5', price: 500),
];

final productsProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.price:
      return _products.sorted((a, b) => a.price.compareTo(b.price));
  }
});
