import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foods_app/repositories/places/places_repository.dart';

import '../../models/place_model.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository _placesRepository;
  PlacesBloc({required PlacesRepository placesRepository})
      : _placesRepository = placesRepository,
        super(PlacesLoadingState()) {
    on<PlacesEvent>((event, emit) async {
      if (event is LoadPlaceEvent) {
        emit(PlacesLoadingState());
        var result = await _placesRepository.getPlace(event.placeId);
        emit(PlacesLoadedState(place: result!));
      }
    });
  }
}
