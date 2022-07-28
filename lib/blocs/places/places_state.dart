part of 'places_bloc.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

class PlacesLoadingState extends PlacesState {}

class PlacesLoadedState extends PlacesState {
  final Place place;

  PlacesLoadedState({
    required this.place,
  });

  @override
  List<Object> get props => [place];
}

class PlacesErrorState extends PlacesState {}
