import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Model class for parking location details.
class ParkingLocation {
  final String name;
  final String coordinates; // Format: "latitude,longitude"
  int occupied; // Number of occupied spots
  final int totalSpots; // Total spots available

  ParkingLocation({
    required this.name,
    required this.coordinates,
    required this.occupied,
    required this.totalSpots,
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

class ParkingApp extends StatefulWidget {
  @override
  _ParkingAppState createState() => _ParkingAppState();
}

class _ParkingAppState extends State<ParkingApp> {
  final List<ParkingLocation> locations = [
    ParkingLocation(name: 'AB1 Parking', coordinates: '12.84361,80.15333', occupied: 4, totalSpots: 5),
    ParkingLocation(name: 'AB2 Parking', coordinates: '12.84389,80.15444', occupied: 5, totalSpots: 5),
    ParkingLocation(name: 'AB3 Parking', coordinates: '12.84278,80.15639', occupied: 2, totalSpots: 5),
    ParkingLocation(name: 'Student Parking 1', coordinates: '12.84139,80.15306', occupied: 5, totalSpots: 5),
    ParkingLocation(name: 'Student Parking 2', coordinates: '12.84028,80.15500', occupied: 1, totalSpots: 5),
    ParkingLocation(name: 'Student Parking 3', coordinates: '12.84194,80.15194', occupied: 0, totalSpots: 5),
    ParkingLocation(name: 'MG Auditorium Parking', coordinates: '12.84028,80.15500', occupied: 0, totalSpots: 5),
  ];

  /// Launches Google Maps for navigation.
  Future<void> _launchGoogleMaps(String coordinates) async {
    final Uri uri = Uri.parse('google.navigation:q=$coordinates');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final Uri fallbackUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving');
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    }
  }

  /// Displays a grid dialog for spot availability.
  void _showAvailabilityDialog(BuildContext context, ParkingLocation location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Text('${location.name} - Parking Spots', style: TextStyle(color: Colors.white)),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: location.totalSpots,
              itemBuilder: (context, index) {
                bool isOccupied = index < location.occupied;
                return GestureDetector(
                  onTap: isOccupied
                      ? null
                      : () {
                          setState(() {
                            location.occupied++;
                          });
                          Navigator.pop(context);
                          _showSnackbar(context, location);
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOccupied ? Colors.redAccent : Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  /// Shows a snackbar for navigation confirmation.
  void _showSnackbar(BuildContext context, ParkingLocation location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reserved a spot in ${location.name}. Navigate to parking?"),
        action: SnackBarAction(
          label: "Yes",
          onPressed: () => _launchGoogleMaps(location.coordinates),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buildingNameColor = Colors.lightBlueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VIT Parking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          bool isFull = location.occupied == location.totalSpots;

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
                  color: buildingNameColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Occupied: ${location.occupied}/${location.totalSpots}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isFull ? Colors.redAccent : Colors.greenAccent,
                  ),
                ),
              ),
              trailing: Icon(Icons.navigation, size: 28),
              onTap: () {
                if (isFull) {
                  _launchGoogleMaps(location.coordinates);
                } else {
                  _showAvailabilityDialog(context, location);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
