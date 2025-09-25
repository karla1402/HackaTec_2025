// Archivo: dashboard.dart (Versión final)

import 'package:flutter/material.dart';
import 'package:xolitos/termo.dart';

class AgriculturalDashboard extends StatefulWidget {
  const AgriculturalDashboard({super.key});

  @override
  _AgriculturalDashboardState createState() => _AgriculturalDashboardState();
}

class _AgriculturalDashboardState extends State<AgriculturalDashboard> {
  int selectedHeatmapIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              _buildHeatmapsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF08A20D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.satellite_alt,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AgroSat Dashboard',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mapas Satelitales de Calor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Análisis en tiempo real de datos satelitales agrícolas',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapsGrid() {
    return Column(
      children: [
        // Primer mapa (más grande)
        SizedBox(
          height: 800, // Aumentada la altura para más espacio vertical
          child: _buildHeatmapCard(
            'NDVI - Vigor y Biomasa',
            'Este mapa muestra la salud de la vegetación. Los valores más altos (verde oscuro) indican plantas más vigorosas y saludables.',
            0,
                  ['','','',],
                  ['','','','','',''],
            isLarge: true,
          ),
        ),

        const SizedBox(height: 16),

        // Dos mapas inferiores (más pequeños)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 600, // Aumentada la altura para los mapas pequeños
                child: _buildHeatmapCard(
                  'Estrés integrado',
                  'lalalalala',
                  1,
                  ['','','',],
                  ['','','','','',''],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 600, // Aumentada la altura para los mapas pequeños
                child: _buildHeatmapCard(
                  'NDWI - Contenido hídrico',
                  'lalalalala',
                  2,
                  ['','','',],
                  ['','','','','',''],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatmapCard(String title, String description, int index, List<String> dynamicRows, List<String> dynamicCols, {bool isLarge = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isLarge ? 24 : 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isLarge ? 20 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (isLarge) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Center(
                child: MatrixHeatmapVertical(rows: dynamicRows, cols: dynamicCols), //aqui
              )
            ),
          ),
          if (isLarge) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  _buildLegendItem('Alto', const Color(0xFF08A20D)),
                  const SizedBox(width: 16),
                  _buildLegendItem('Medio', Colors.yellow[600]!),
                  const SizedBox(width: 16),
                  _buildLegendItem('Bajo', Colors.red[600]!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}