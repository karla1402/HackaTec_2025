import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  bool _isLoading = true;

  List<LatLng> points = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (e.g., show a message to the user)
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentLocation == null) {
      return const Center(child: Text("Unable to get your location."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un área')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation!,
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            setState(() {
              points.add(point);
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.xolitos.app',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: points,
                color: Colors.blue.withOpacity(0.5),
                isFilled: true,
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
            ],
          ),
          MarkerLayer(
            markers: points
                .map(
                  (point) => Marker(
                    point: point,
                    child: const Icon(Icons.location_on, color: Colors.red),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment
            .end, // Alinea los botones al final de la pantalla (abajo)
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              // Lógica para enviar el área al backend
              if (points.isNotEmpty) {
                // Cierra el polígono (opcional)
                points.add(points.first);

                final formattedPoints = points
                    .map((p) => [p.latitude, p.longitude])
                    .toList();
                print('Enviando al backend: $formattedPoints');
              }
            },
            label: const Text('Enviar área'),
            icon: const Icon(Icons.send),
          ),
          const SizedBox(height: 10), // Espacio entre los botones
          FloatingActionButton.extended(
            onPressed: () {
              // Lógica para limpiar la selección
              setState(() {
                points.clear();
              });
              print('Puntos limpiados');
            },
            label: const Text('Limpiar'),
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition();
}
