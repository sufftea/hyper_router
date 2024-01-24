import 'package:example/features/demos/value_based/product_details/product_details_screen.dart';
import 'package:example/features/demos/value_based/product_list/product.dart';
import 'package:example/features/demos/value_based/star_rating_widget.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/widgets/banner_button.dart';
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 256),
      child: VerticalBannerButton(
        onPressed: () {
          context.star.navigate(ProductRouteValue(product));
        },
        title: product.name,
        image: 'assets/value_based/product.jpeg',
        caption: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 8),
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
    );
  }
}
