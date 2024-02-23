import 'package:example/features/demos/guard/state/auth_cubit.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/material_match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_router/hyper_router.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.hyper.pop(),
                    style: ButtonStyle(
                      textStyle: materialMatch(
                        all: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      foregroundColor: materialMatch(
                        all: context.col.error,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const _LoadingButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingButton extends StatefulWidget {
  const _LoadingButton();

  @override
  State<_LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<_LoadingButton> {
  final isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        isLoading.value = true;
        await context.read<AuthCubit>().logOut();
        isLoading.value = false;

        if (context.mounted) {
          context.hyper.pop();
        }
      },
      style: ButtonStyle(
        textStyle: materialMatch(
          all: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, loading, child) {
          return Stack(
            children: [
              Opacity(
                opacity: loading ? 0 : 1,
                child: const Text('Log out'),
              ),
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Opacity(
                      opacity: loading ? 1 : 0,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
