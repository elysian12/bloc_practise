part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthIntialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {}

class UnAuthenticatedState extends AuthState {}

class AuthSignedInState extends AuthState {
  final User user;
  AuthSignedInState({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
