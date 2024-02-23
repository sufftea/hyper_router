import 'package:example/features/demos/guard/authwalled_screen.dart';
import 'package:example/features/demos/guard/state/auth_cubit.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_router/hyper_router.dart';

class AuthRouteValue extends RouteValue {
  AuthRouteValue(this.redirect);
  final RouteValue? redirect;
}

class AuthSegmentParser extends UrlSegmentParser<AuthRouteValue> {
  @override
  AuthRouteValue? decodeSegment(SegmentData segment) {
    if (segment.name == 'auth') {
      return AuthRouteValue(
        switch (segment.state['auth-redirect']) {
          String name => RouteName(name),
          _ => null,
        },
      );
    }
    return null;
  }

  @override
  SegmentData encodeSegment(AuthRouteValue value) {
    return SegmentData(
      name: 'auth',
      state: {
        if (value.redirect case final RouteName redirect)
          'auth-redirect': redirect.name,
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.value,
    super.key,
  });

  final AuthRouteValue value;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final passwordFocus = FocusNode();
  final loginFocus = FocusNode();

  final loadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LimitWidth(
        maxWidth: 256,
        child: FocusScope(
          child: Builder(builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'username',
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  focusNode: passwordFocus,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'password',
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    loadingNotifier.value = true;
                    await context.read<AuthCubit>().logIn();
                    loadingNotifier.value = false;

                    if (context.mounted) {
                      context.hyper.navigate(
                        widget.value.redirect ?? AuthwalledScreen.routeName,
                      );
                    }
                  },
                  focusNode: loginFocus,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: loadingNotifier,
                        builder: (context, loading, child) {
                          return Stack(
                            children: [
                              Opacity(
                                opacity: loading ? 0 : 1,
                                child: const Icon(Icons.login),
                              ),
                              Positioned.fill(
                                child: Opacity(
                                  opacity: loading ? 1 : 0,
                                  child: CircularProgressIndicator(
                                    color: context.col.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          );
                          // return Icon(Icons.login);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text('Log in'),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
