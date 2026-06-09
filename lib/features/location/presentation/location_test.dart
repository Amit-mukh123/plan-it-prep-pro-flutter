import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ileum/services/location/location_provider.dart';
import 'package:ileum/services/location/location_state.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the location state directly
    final state = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("User Location"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: _buildContent(state)),
      ),
    );
  }

  /// Determines what to show based on the current state status
  Widget _buildContent(LocationState state) {
    switch (state.status) {
      case LocationStatus.loading:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Updating your location..."),
          ],
        );

      case LocationStatus.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              state.error ?? "Failed to get location",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        );

      case LocationStatus.success:
        return _LocationDataCard(state: state);

      case LocationStatus.initial:
        return const Text("Initializing location services...");
    }
  }
}

/// A private helper widget to keep the success UI clean and reusable
class _LocationDataCard extends StatelessWidget {
  final LocationState state;
  const _LocationDataCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListView(
        shrinkWrap: true, // Takes only as much space as needed
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildDetailRow(Icons.location_city, "City", state.city),
          _buildDetailRow(Icons.map, "State", state.state),
          _buildDetailRow(Icons.public, "Country", state.country),
          _buildDetailRow(
            Icons.gps_fixed,
            "Coordinates",
            "${state.latitude?.toStringAsFixed(4)}, ${state.longitude?.toStringAsFixed(4)}",
          ),
          const Divider(),
          _buildDetailRow(
            Icons.home,
            "Full Address",
            state.fullAddress,
            isMultiline: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String? value, {
    bool isMultiline = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      subtitle: Text(
        value ?? "N/A",
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        maxLines: isMultiline ? 3 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
