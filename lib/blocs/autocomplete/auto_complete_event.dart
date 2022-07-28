// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auto_complete_bloc.dart';

abstract class AutoCompleteEvent extends Equatable {
  const AutoCompleteEvent();

  @override
  List<Object> get props => [];
}

class LoadAutoCompleteEvent extends AutoCompleteEvent {
  final String searchInput;

  LoadAutoCompleteEvent({
    this.searchInput = '',
  });

  @override
  List<Object> get props => [searchInput];
}
