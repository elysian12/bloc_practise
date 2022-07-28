import 'dart:convert' as convert;

import 'package:foods_app/models/place_autocomplete_model.dart';
import 'package:foods_app/models/place_model.dart';
import 'package:foods_app/repositories/places/base_places_repository.dart';

import 'package:http/http.dart' as http;

class PlacesRepository extends BasePlacesRepository {
  final String key = 'AIzaSyDRpE59BtlvX146IQ9C8TJo1mqqqM2msXs';
  final String types = 'geocode';

  @override
  Future<List<PlaceAutoComplete>?> getAutoComplete(String searchInput) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = json['predictions'] as List;
    return result.map((place) => PlaceAutoComplete.fromMap(place)).toList();
  }

  @override
  Future<Place?> getPlace(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = json['result'] as Map<String, dynamic>;
    return Place.fromMap(result);
  }
}
