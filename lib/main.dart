import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Model class for parking location details.
class ParkingLocation {
  final String name;
  final String coordinates; // Format: "latitude,longitude"
  final String occupancy;   // Format: "occupied/total", e.g., "4/5"

  ParkingLocation({
    required this.name,
    required this.coordinates,
    required this.occupancy,
  });
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          elevation: 4,
        ),
        cardColor: Colors.blueGrey[800],
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: ParkingApp(),
    ),
  );
}

class ParkingApp extends StatelessWidget {
  // Replace these with your actual location data.
  final List<ParkingLocation> locations = [
    ParkingLocation(
      name: 'AB1 Parking',
      coordinates: '12.84361,80.15333', // Converted from DMS to decimal degrees.
      occupancy: '4/5',
    ),
    ParkingLocation(
      name: 'AB2 Parking',
      coordinates: '12.84389,80.15444',
      occupancy: '5/5',
    ),
    ParkingLocation(
      name: 'AB3 Parking',
      coordinates: '12.84278,80.15639',
      occupancy: '2/5',
    ),
    ParkingLocation(
      name: 'Student Parking 1',
      coordinates: '12.84139, 80.15306',
      occupancy: '5/5',
    ),
    ParkingLocation(
      name: 'Student Parking 2',
      coordinates: '12.84028,80.15500',
      occupancy: '1/5',
    ),
    ParkingLocation(
      name: 'Student Parking 3',
      coordinates: '12.84194,80.15194',
      occupancy: '0/5',
    ),
    ParkingLocation(
      name: 'MG Auditorium Parking',
      coordinates: '12.84028, 80.15500',
      occupancy: '0/5',
    ),
  ];

  /// Attempts to launch Google Maps using the native scheme first, then falls back to a universal URL.
  Future<void> _launchGoogleMaps(String coordinates) async {
    // Try the native navigation URI (Android).
    final Uri nativeUri = Uri.parse('google.navigation:q=$coordinates');
    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      return;
    }

    // Fallback to the universal Google Maps URL.
    final Uri universalUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving',
    );
    if (await canLaunchUrl(universalUri)) {
      await launchUrl(universalUri, mode: LaunchMode.externalApplication);
      return;
    }

    throw 'Could not launch Google Maps for coordinates: $coordinates';
  }

  /// Determines the color based on occupancy.
  /// Returns redAccent if fully occupied, otherwise greenAccent.
  Color getOccupancyColor(String occupancy) {
    try {
      final parts = occupancy.split('/');
      final int occupied = int.parse(parts[0]);
      final int total = int.parse(parts[1]);
      return occupied == total ? Colors.redAccent : Colors.greenAccent;
    } catch (e) {
      // Fallback color in case of parsing error.
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom color for building names.
    const buildingNameColor = Colors.lightBlueAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VIT Parking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(
                location.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: buildingNameColor, // Custom color for building names.
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Occupied: ${location.occupancy}',
                  style: TextStyle(
                    fontSize: 14,
                    color: getOccupancyColor(location.occupancy),
                  ),
                ),
              ),
              trailing: Icon(Icons.navigation, size: 28),
              onTap: () => _launchGoogleMaps(location.coordinates),
            ),
          );
        },
      ),
    );
  }
}
