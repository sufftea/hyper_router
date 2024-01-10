import 'package:flutter/material.dart';
import 'package:responsive_list_detail/features/entry_list/data/email.dart';
import 'package:responsive_list_detail/features/entry_list/widgets/entry_widget.dart';
import 'package:fractal_router/fractal_router.dart';

class EmailListScreen extends StatelessWidget {
  const EmailListScreen({super.key});

  static const name = RouteName('email_list');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: theme.background,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Positioned.fill(
            child: ListView.builder(
              itemCount: emails.length,
              padding: const EdgeInsets.only(top: 86),
              itemBuilder: (context, index) {
                return EntryWidget(data: emails[index]);
              },
            ),
          ),
          const Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: SearchBar(
              // elevation: MaterialStatePropertyAll(1),
              leading: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.search),
              ),
              trailing: [
                CircleAvatar(
                  child: Icon(Icons.person_2_rounded),
                ),
              ],
              hintText: 'Search inbox',
            ),
          ),
        ],
      ),
    );
  }
}
