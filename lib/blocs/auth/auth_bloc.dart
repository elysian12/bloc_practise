import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foods_app/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthIntialState()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInEvent) {
        emit(AuthLoadingState());
        try {
          User? user =
              await _authRepository.loginViaEmail(event.email, event.password);

          if (user != null) {
            emit(AuthSignedInState(user: user));
          } else {
            emit(AuthErrorState(message: 'SomeThing Went Wrong !!!'));
          }
        } on FirebaseAuthException catch (e) {
          emit(AuthErrorState(message: e.message!));
        }
      }
      if (event is SignOutEvent) {
        await _authRepository.signOut();
        emit(UnAuthenticatedState());
      }

      if (event is AuthStateChangeEvent) {
        if (_authRepository.auth.currentUser != null) {
          emit(AuthenticatedState());
        } else {
          emit(UnAuthenticatedState());
        }
      }
    });
  }
}
