import 'package:foods_app/models/place_autocomplete_model.dart';
import 'package:foods_app/models/place_model.dart';

abstract class BasePlacesRepository {
  Future<List<PlaceAutoComplete>?> getAutoComplete(String searchInput) async {}
  Future<Place?> getPlace(String placeId) async {}
}
