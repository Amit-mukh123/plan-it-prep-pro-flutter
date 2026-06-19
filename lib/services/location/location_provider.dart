import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ileum/services/location/location_service.dart';
import 'package:ileum/services/location/location_state.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((
  ref,
) {
  final notifier = LocationNotifier(LocationService());
  // Trigger initialization immediately when the provider is first watched/read
  notifier.initLocation();
  return notifier;
});

class LocationNotifier extends StateNotifier<LocationState> {
  final LocationService _service;
  static const String _storageKey = 'user_location_data';

  LocationNotifier(this._service) : super(LocationState.initial());

  /// Initializes state from Local Storage or fetches fresh if empty
  Future<void> initLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedData = prefs.getString(_storageKey);

      if (cachedData != null) {
        final Map<String, dynamic> decodedData = jsonDecode(cachedData);
        // Update state with cached data
        state = LocationState.fromMap(decodedData);
        //debugPrint("Successfully loaded CACHED location data: $cachedData");
      } else {
        // No cache, trigger fresh fetch
        await loadLocation();
      }
    } catch (e) {
      //debugPrint("Error loading cache: $e");
      await loadLocation();
    }
  }

  /// Fetches fresh location and persists it on success
  Future<void> loadLocation() async {
    // 1. Explicitly update state to loading to trigger UI changes
    state = state.copyWith(status: LocationStatus.loading, clearError: true);

    final result = await _service.getLocationData();

    // 2. Update state with final result (Success or Error)
    state = result;

    // debugPrint(
    //   "Fresh location fetched: Lat: ${result.latitude}, City: ${result.city}",
    // );

    if (result.status == LocationStatus.success) {
      await _saveToStorage(result);
    }
  }

  /// Persists location data to local storage
  Future<void> _saveToStorage(LocationState data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data.toMap());
      await prefs.setString(_storageKey, jsonString);
     // debugPrint("Data successfully saved to Local Storage: $jsonString");
    } catch (e) {
      //debugPrint("Storage save error: $e");
    }
  }
}
