import 'package:example/features/demos/value_based/product_list/product.dart';
import 'package:example/features/demos/value_based/product_list/product_widget.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/srs/value/route_name.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  static const routeName = RouteName('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: LimitWidth(
          child: Wrap(
            children:
                products.values.map((e) => ProductWidget(product: e)).toList(),
          ),
        ),
      ),
    );
  }
}
