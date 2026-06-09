import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ileum/services/location/location_state.dart';

class LocationService {
  /// Configuration constants for fine-tuning
  static const Duration _locationTimeout = Duration(seconds: 15);
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Only update if user moves 10 meters
  );

  /// Main entry point to get processed location data
  Future<LocationState> getLocationData() async {
    try {
      final Position position = await _determinePosition();

      // Reverse geocoding to get address details
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException("Address lookup timed out"),
          );

      if (placemarks.isEmpty) {
        throw Exception("No address found for these coordinates.");
      }

      final place = placemarks.first;

      return LocationState(
        status: LocationStatus.success,
        latitude: position.latitude,
        longitude: position.longitude,
        city: place.locality ?? place.subAdministrativeArea ?? '',
        state: place.administrativeArea ?? '',
        country: place.country ?? '',
        fullAddress: _formatAddress(place),
      );
    } on TimeoutException catch (_) {
      return const LocationState(
        status: LocationStatus.error,
        error: "Connection timed out. Please check your GPS signal.",
      );
    } catch (e) {
      return LocationState(
        status: LocationStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Internal logic to handle the complex permission/service flow
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if hardware GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // PRO TIP: Direct the user to settings instead of just failing
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled. Please enable GPS.');
    }

    // 2. Handle Permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Direct user to App Settings since we can't ask again via code
      await Geolocator.openAppSettings();
      return Future.error(
        'Permissions are permanently denied. Please enable them in settings.',
      );
    }

    // 3. Get Position with a timeout to prevent infinite loading
    return await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    ).timeout(_locationTimeout);
  }

  /// Cleanly formats the address string, skipping null/empty values
  String _formatAddress(Placemark place) {
    final components = [
      place.street,
      place.locality,
      place.administrativeArea,
      place.country,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return components.join(', ');
  }
}
