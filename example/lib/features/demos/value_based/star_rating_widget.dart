import 'package:example/features/utils/context_x.dart';
import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    required this.score,
    super.key,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        iconTheme: IconThemeData(
          color: context.col.primary,
        )
      ),
      child: Row(
        children: [
          for (int i = 1; i <= 5; i++)
            if (i * 2 <= score)
              const Icon(Icons.star)
            else if (i * 2 - 1 <= score)
              const Icon(Icons.star_half)
            else
              const Icon(Icons.star_border),
        ],
      ),
    );
  }
}
