import 'package:example/features/demos/guard/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> logIn() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(authenticated: true));
  }

  Future<void> logOut() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(authenticated: false));
  }
}
