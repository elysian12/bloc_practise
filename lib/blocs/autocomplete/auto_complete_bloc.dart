import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foods_app/repositories/places/places_repository.dart';

import '../../models/place_autocomplete_model.dart';

part 'auto_complete_event.dart';
part 'auto_complete_state.dart';

class AutoCompleteBloc extends Bloc<AutoCompleteEvent, AutoCompleteState> {
  final PlacesRepository _placesRepository;
  AutoCompleteBloc({required PlacesRepository placesRepository})
      : _placesRepository = placesRepository,
        super(AutoCompleteLoadingState()) {
    on<AutoCompleteEvent>((event, emit) async {
      if (event is LoadAutoCompleteEvent) {
        List<PlaceAutoComplete>? response =
            await _placesRepository.getAutoComplete(event.searchInput);

        emit(AutoCompleteLoadedState(autocomplete: response!));
      }
    });
  }
}
