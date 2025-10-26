import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';

class LocationSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  // Mock data for search suggestions
  final List<Map<String, dynamic>> _searchHistory = [
    {"name": "Main Street", "area": "Downtown", "coords": const LatLng(28.6315, 77.2167)},
    {"name": "Connaught Place", "area": "New Delhi", "coords": const LatLng(28.6330, 77.2193)},
  ];

  @override
  String get searchFieldLabel => 'Search for a location...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _searchHistory.where((loc) => loc["name"].toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];
        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(location["name"]),
          subtitle: Text(location["area"]),
          onTap: () => close(context, location),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _searchHistory
        : _searchHistory.where((loc) => loc["name"].toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final location = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(location["name"]),
          onTap: () {
            query = location["name"];
            showResults(context);
          },
        );
      },
    );
  }
}