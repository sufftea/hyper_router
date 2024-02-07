import 'dart:math';

final _r = Random.secure();

class Product {
  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.score,
  }) : id = _r.nextInt(1 << 10).toString();

  final String id;
  final String name;
  final String price;
  final String description;
  final int score;
}

final products = Map<String, Product>.fromIterable(
  [
    Product(
      name: "Laptop",
      price: "\$999.99",
      description:
          "Experience powerful computing with this high-performance laptop. Perfect for work, entertainment, and everything in between.",
      score: 8,
    ),
    Product(
      name: "Smartphone",
      price: "\$599.99",
      description:
          "Stay connected and enjoy advanced features with this cutting-edge smartphone. Capture stunning photos, play games, and more.",
      score: 9,
    ),
    Product(
      name: "Coffee Maker",
      price: "\$49.99",
      description:
          "Start your day with a perfect cup of coffee using this automatic coffee maker. Easy to use and ensures a delicious brew every time.",
      score: 7,
    ),
    Product(
      name: "Fitness Tracker",
      price: "\$79.99",
      description:
          "Achieve your fitness goals with this smart tracker. Monitor your activities, track your progress, and stay motivated on your journey.",
      score: 6,
    ),
    Product(
      name: "Wireless Headphones",
      price: "\$129.99",
      description:
          "Immerse yourself in a superior audio experience with these wireless headphones. Enjoy music, movies, and calls with comfort and convenience.",
      score: 8,
    ),
  ],
  key: (element) => element.id,
);
