import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';
import 'package:responsive_list_detail/features/entry_details/entry_details_screen.dart';
import 'package:responsive_list_detail/features/entry_list/data/email.dart';

class EntryWidget extends StatelessWidget {
  const EntryWidget({
    required this.data,
    super.key,
  });

  final Email data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {        
        context.frouter.navigate(EmailRouteData(data));
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person_4)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        data.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        '10 minutes ago',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  color: theme.onSurfaceVariant,
                  style: const ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                      width: 0.5,
                    )),
                  ),
                  icon: const Icon(Icons.star_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              data.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
