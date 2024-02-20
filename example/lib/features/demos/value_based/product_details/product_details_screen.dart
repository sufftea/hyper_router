import 'package:example/features/demos/value_based/product_list/product.dart';
import 'package:example/features/demos/value_based/star_rating_widget.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/url/url_parser.dart';
import 'package:star/star.dart';

class ProductRouteValue extends RouteValue {
  const ProductRouteValue(this.productId);

  final String productId;
}

class ProductSegmentParser extends UrlSegmentParser<ProductRouteValue> {
  @override
  ProductRouteValue? decodeSegment(SegmentData segment) {
    return ProductRouteValue(segment.name);
  }

  @override
  SegmentData encodeSegment(ProductRouteValue value) {
    return SegmentData(name: value.productId);
  }
}

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({
    required ProductRouteValue value,
    super.key,
  }) : productId = value.productId;

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = products[productId];

    return Scaffold(
      appBar: AppBar(),
      body: product == null
          ? buildNoSuchProduct(context)
          : buildProductDetails(context, product),
    );
  }

  Widget buildNoSuchProduct(BuildContext context) {
    return Center(
      child: Text("Product with id $productId doesn't seem to exist"),
    );
  }

  Widget buildProductDetails(BuildContext context, Product product) {
    return SingleChildScrollView(
      child: LimitWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context, product),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Product product) {
    return switch (context.width) {
      < compactWidth => _PortraitHeader(product: product),
      _ => _LandscapeHeader(product: product),
    };
  }
}

class _PortraitHeader extends StatelessWidget {
  const _PortraitHeader({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/value_based/product.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StarRatingWidget(score: product.score),
                const SizedBox(height: 16),
                Text(
                  product.price,
                  style: TextStyle(
                    fontSize: 24,
                    color: context.col.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LandscapeHeader extends StatelessWidget {
  const _LandscapeHeader({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 256,
            width: 256,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/value_based/product.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StarRatingWidget(score: product.score),
                  const SizedBox(height: 16),
                  Text(
                    product.price,
                    style: TextStyle(
                      fontSize: 24,
                      color: context.col.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
