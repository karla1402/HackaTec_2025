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
  bool _isDrawing = true;
  String? _error;
  bool _submitting = false;

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

    final parcelArgs = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text('Delimita tu parcela')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _currentLocation!,
              initialZoom: 14.0,
              onTap: (tapPosition, point) {
                if (!_isDrawing) return;
                setState(() {
                  points.add(point);
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.xolitos.app',
              ),
              if (points.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: points,
                      color: Colors.green.withOpacity(0.25),
                      isFilled: true,
                      borderColor: Colors.green.shade700,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (points.isNotEmpty)
                MarkerLayer(
                  markers: points
                      .map(
                        (p) => Marker(
                          point: p,
                          child: const Icon(
                            Icons.place,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      _isDrawing ? Icons.gesture : Icons.check_circle,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isDrawing
                            ? 'Toca en el mapa para agregar vértices. Mínimo 3 puntos.'
                            : 'Revisa la selección y envía para análisis.',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_error != null)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red.shade600,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: points.isEmpty
                      ? null
                      : () {
                          setState(() {
                            points.removeLast();
                          });
                        },
                  icon: const Icon(Icons.undo),
                  label: const Text('Deshacer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: points.isEmpty
                      ? null
                      : () {
                          setState(() {
                            points.clear();
                            _isDrawing = true;
                          });
                        },
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    if (_isDrawing) {
                      if (points.length < 3) {
                        setState(() {
                          _error =
                              'Agrega al menos 3 puntos para cerrar el polígono.';
                        });
                        return;
                      }
                      setState(() {
                        _error = null;
                        _isDrawing = false;
                      });
                      return;
                    }

                    final polygon = [...points, points.first];
                    final coordinates = polygon
                        .map((p) => [p.latitude, p.longitude])
                        .toList();

                    setState(() {
                      _submitting = true;
                    });
                    // Hand over to previous screen to trigger API or handle inline
                    Navigator.pop(context, {
                      'geometry': coordinates,
                      'parcel': parcelArgs,
                    });
                  },
                  icon: Icon(_isDrawing ? Icons.check : Icons.send),
                  label: Text(
                    _isDrawing
                        ? 'Cerrar'
                        : (_submitting ? 'Enviando...' : 'Enviar'),
                  ),
                ),
              ),
            ],
          ),
        ),
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
