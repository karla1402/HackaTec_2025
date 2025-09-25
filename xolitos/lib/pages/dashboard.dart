// Archivo: dashboard.dart

// No olvides añadir la dependencia de flutter_markdown a tu archivo pubspec.yaml:
// dependencies:
//   flutter_markdown: ^0.7.1 # O la versión más reciente

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:latlong2/latlong.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runAnalysis());
  }

  Future<void> _runAnalysis() async {
    // La lógica de obtención de datos permanece sin cambios.
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final jsonStr = await rootBundle.loadString(
        'response.json',
      ); // Asegúrate que la ruta sea correcta
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _data = parsed;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Fallo al obtener el análisis: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final List geometry = (args?['geometry'] as List?) ?? [];
    final polygon = geometry
        .map((e) => LatLng((e[0] as num).toDouble(), (e[1] as num).toDouble()))
        .toList();

    final LatLng center = polygon.isNotEmpty
        ? LatLng(
            polygon.map((p) => p.latitude).reduce((a, b) => a + b) /
                polygon.length,
            polygon.map((p) => p.longitude).reduce((a, b) => a + b) /
                polygon.length,
          )
        : const LatLng(20.36, -102.685);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Análisis'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 950;
              return isWide
                  ? _buildWideLayout(center, polygon)
                  : _buildNarrowLayout(center, polygon);
            },
          ),
          if (_loading) _buildLoadingOverlay(),
          if (_error != null) _buildErrorBanner(_error!),
        ],
      ),
    );
  }

  /// Layout para pantallas anchas (web/tablet).
  Widget _buildWideLayout(LatLng center, List<LatLng> polygon) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMainMap(center, polygon),
                  const SizedBox(height: 24),
                  _buildAnalysisConclusion(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeatmapCard('NDVI (Vigor Y Biomasa))', 'ndvi'),
                  const SizedBox(height: 16),
                  _buildHeatmapCard('NDWI (Contenio hidrico)', 'ndwi'),
                  const SizedBox(height: 16),
                  _buildHeatmapCard('Estrés integrado', 'stress'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Layout para pantallas estrechas (móvil).
  Widget _buildNarrowLayout(LatLng center, List<LatLng> polygon) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMainMap(center, polygon),
          const SizedBox(height: 16),
          _buildHeatmapCard('NDVI (Índice de Vegetación)', 'ndvi'),
          const SizedBox(height: 16),
          _buildHeatmapCard('NDWI (Índice de Humedad)', 'ndwi'),
          const SizedBox(height: 16),
          _buildHeatmapCard('Estrés Hídrico', 'stress'),
          const SizedBox(height: 16),
          _buildAnalysisConclusion(),
        ],
      ),
    );
  }

  /// Widget que muestra las conclusiones en formato Markdown.
  Widget _buildAnalysisConclusion() {
    const String conclusionText = """
## Conclusión del Análisis

El análisis satelital del polígono seleccionado revela varios puntos clave:

* **Índice NDVI (Vegetación):** Se observa una salud vegetal predominantemente robusta en la zona norte. Sin embargo, el área sureste muestra signos de debilidad, lo que podría indicar un riego deficiente o problemas de nutrientes.

* **Índice NDWI (Humedad):** Los niveles de humedad son consistentes, aunque el mapa de calor sugiere una ligera disminución en las mismas zonas donde el NDVI es bajo. Esto refuerza la hipótesis de un posible estrés hídrico.

* **Nivel de Estrés:** El mapa de estrés resalta una zona de **alerta alta** en el sector sureste. Se recomienda una inspección en campo para determinar la causa raíz.

### Recomendaciones

1.  **Inspección en Campo:** Realizar una visita al área sureste para una evaluación visual.
2.  **Ajuste de Riego:** Considerar un aumento en la frecuencia o volumen de riego en la zona afectada.
3.  **Muestreo de Suelo:** Tomar muestras para analizar deficiencias de nutrientes.
""";

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MarkdownBody(
          data: conclusionText,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            h2: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            h3: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            p: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ),
    );
  }

  /// Widget para el mapa principal que muestra el polígono.
  Widget _buildMainMap(LatLng center, List<LatLng> polygon) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 350,
        child: FlutterMap(
          key: const ValueKey('mainMap'),
          options: MapOptions(initialCenter: center, initialZoom: 17),
          children: [
            TileLayer(
              urlTemplate:
                  'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            ),
            if (polygon.isNotEmpty)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: polygon,
                    isFilled: true,
                    color: Colors.green.withOpacity(0.2),
                    borderColor: Colors.green.shade50,
                    borderStrokeWidth: 2.5,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Gradientes de color para cada tipo de mapa de calor.
  Map<double, Color> _getGradientForKey(String keyName) {
    switch (keyName) {
      case 'ndvi':
        return {
          0.0: Colors.brown,
          0.5: Colors.yellow.shade600,
          1.0: Colors.green.shade800,
        };
      case 'ndwi':
        return {
          0.0: Colors.brown.shade300,
          0.5: Colors.cyan,
          1.0: Colors.blue.shade900,
        };
      case 'stress':
        return {
          0.0: Colors.lightGreen,
          0.5: Colors.yellow,
          1.0: Colors.red.shade900,
        };
      default:
        return {0.0: Colors.blue, 0.5: Colors.lime, 1.0: Colors.red};
    }
  }

  /// Widget para las tarjetas de mapas de calor (NDVI, NDWI, Estrés).
  Widget _buildHeatmapCard(String title, String keyName) {
    final heatList = _extractHeatList(keyName);
    final center =
        _inferCenterFromPoints(heatList ?? []) ?? const LatLng(20.36, -102.685);

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(title),
          SizedBox(
            height: 260,
            child: heatList == null
                ? const Center(child: Text('Sin datos disponibles'))
                : FlutterMap(
                    key: ValueKey('heatmap-$keyName'),
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: 17,
                      // SOLUCIÓN: Desactiva el arrastre (drag) pero mantiene otros gestos como el zoom.
                      // Esto permite que el scroll de la página funcione sobre el mapa.
                      interactionOptions: const InteractionOptions(
                        flags:
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                      ),
                      HeatMapLayer(
                        heatMapDataSource: InMemoryHeatMapDataSource(
                          data: heatList.map((e) {
                            final lat = (e['lat'] as num).toDouble();
                            final lon = (e['lon'] as num).toDouble();
                            final v = (e['value'] as num).toDouble();
                            return WeightedLatLng(LatLng(lat, lon), v);
                          }).toList(),
                        ),
                        heatMapOptions: HeatMapOptions(
                          gradient: _getGradientForKey(keyName).map(
                            (k, v) => MapEntry(
                              k,
                              v is MaterialColor
                                  ? v
                                  : MaterialColor(
                                      v.value,
                                      const <int, Color>{},
                                    ),
                            ),
                          ),
                          radius: 25,
                          blurFactor: 0.5,
                          layerOpacity: 0.8,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS Y MÉTODOS AUXILIARES ---

  /// Widget reutilizable para los títulos de las tarjetas.
  Widget _buildCardTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<dynamic>? _extractHeatList(String keyName) {
    if (_data == null) return null;
    if (keyName == 'stress') {
      return (_data!['heatmaps']?[keyName] ?? _data![keyName]) as List?;
    }
    return (_data!['heatmaps']?[keyName]) as List?;
  }

  LatLng? _inferCenterFromPoints(List list) {
    if (list.isEmpty) return null;
    final lats = list.map((e) => (e['lat'] as num).toDouble()).toList();
    final lons = list.map((e) => (e['lon'] as num).toDouble()).toList();
    return LatLng(
      lats.reduce((a, b) => a + b) / lats.length,
      lons.reduce((a, b) => a + b) / lons.length,
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Generando análisis satelital...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
