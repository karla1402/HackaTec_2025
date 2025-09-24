import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un área'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(21.875846206223176, -102.26134354763948), // Coordenadas de Ciudad de México
          initialZoom: 10,
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
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

