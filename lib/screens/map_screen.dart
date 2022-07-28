import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foods_app/blocs/auth/auth_bloc.dart';
import 'package:foods_app/blocs/geolocation/geolocation_bloc.dart';
import 'package:foods_app/screens/login_screens.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/autocomplete/auto_complete_bloc.dart';
import '../blocs/places/places_bloc.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map-screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> mapcontroller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PlacesBloc, PlacesState>(
        listener: (context, state) async {
          if (state is PlacesLoadedState) {
            var controller = await mapcontroller.future;
            await controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(state.place.lat, state.place.lng),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: BlocBuilder<GeolocationBloc, GeolocationState>(
                builder: (context, state) {
                  if (state is GeolocationLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GeolocationLoadedState) {
                    return GoogleMap(
                      onMapCreated: (controller) {
                        mapcontroller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.position.latitude,
                          state.position.longitude,
                        ),
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    );
                  }
                  return Center(child: Text('Something went Wrong !!!!'));
                },
              ),
            ),
            LocationField(),
            SaveButton(),
          ],
        ),
      ),
      floatingActionButton: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticatedState) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          }
        },
        child: FloatingActionButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignOutEvent());
          },
        ),
      ),
    );
  }
}

class LocationField extends StatelessWidget {
  const LocationField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Column(
        children: [
          LocationSearchBox(),
          BlocBuilder<AutoCompleteBloc, AutoCompleteState>(
            builder: (context, state) {
              if (state is AutoCompleteLoadingState) {
                return CircularProgressIndicator();
              } else if (state is AutoCompleteLoadedState) {
                return Container(
                  margin: EdgeInsets.all(8),
                  height: 300,
                  color: state.autocomplete.length > 0
                      ? Colors.black.withOpacity(0.6)
                      : Colors.transparent,
                  child: ListView.builder(
                    itemCount: state.autocomplete.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(
                          state.autocomplete[index].description,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          context.read<PlacesBloc>().add(LoadPlaceEvent(
                              placeId: state.autocomplete[index].placeId));
                          context
                              .read<AutoCompleteBloc>()
                              .add(LoadAutoCompleteEvent());
                          // controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                );
              }
              return Center(child: Text('Something went Wrong !!!!'));
            },
          ),
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: ElevatedButton(
          child: Text('Save'),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter your Location',
          suffixIcon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          contentPadding: EdgeInsets.only(left: 20, bottom: 5, right: 5),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        onChanged: (value) {
          context
              .read<AutoCompleteBloc>()
              .add(LoadAutoCompleteEvent(searchInput: value));
        },
      ),
    );
  }
}
