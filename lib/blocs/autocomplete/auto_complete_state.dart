part of 'auto_complete_bloc.dart';

abstract class AutoCompleteState extends Equatable {
  const AutoCompleteState();

  @override
  List<Object> get props => [];
}

class AutoCompleteLoadingState extends AutoCompleteState {}

class AutoCompleteLoadedState extends AutoCompleteState {
  final List<PlaceAutoComplete> autocomplete;

  AutoCompleteLoadedState({
    required this.autocomplete,
  });

  @override
  List<Object> get props => [autocomplete];
}

class AutoCompleteErrorState extends AutoCompleteState {}
