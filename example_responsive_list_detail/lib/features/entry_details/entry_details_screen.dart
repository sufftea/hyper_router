import 'package:flutter/material.dart';
import 'package:responsive_list_detail/features/entry_list/data/email.dart';
import 'package:responsive_list_detail/features/utils/screen_sizes.dart';
import 'package:snowflake_route/snowflake_route.dart';

class EmailRouteData extends RouteValue {
  EmailRouteData(this.email);

  final Email email;
}

class EmailDetailsScreen extends StatelessWidget {
  const EmailDetailsScreen({
    required this.data,
    super.key,
  });

  final EmailRouteData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: expanded ? Colors.transparent : null,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        // title: Text('staoheustoaehu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(
                const Size.fromWidth(mediumWidth * 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person_4_sharp),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              data.email.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              '20 mins ago',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.email.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.email.content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
