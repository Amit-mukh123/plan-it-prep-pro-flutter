enum LocationStatus { initial, loading, success, error }

class LocationState {
  final LocationStatus status;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? fullAddress;
  final String? error;

  const LocationState({
    required this.status,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
    this.fullAddress,
    this.error,
  });

  // Initial state helper
  factory LocationState.initial() =>
      const LocationState(status: LocationStatus.initial);

  // Convert Map (JSON) from Local Storage back to Object
  factory LocationState.fromMap(Map<String, dynamic> map) {
    return LocationState(
      status: LocationStatus.success, // If loaded from storage, assume success
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      fullAddress: map['full_address'] as String?,
      error: null,
    );
  }

  // Convert Object to Map for Local Storage (SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'country': country,
      'full_address': fullAddress,
    };
  }

  // Standard copyWith with improved error handling
  LocationState copyWith({
    LocationStatus? status,
    double? latitude,
    double? longitude,
    String? city,
    String? state,
    String? country,
    String? fullAddress,
    String? error,
    bool clearError = false, // Added flag to explicitly clear errors
  }) {
    return LocationState(
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      fullAddress: fullAddress ?? this.fullAddress,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
