// Archivo: termo.dart (Versión refactorizada y vertical)

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';

class MatrixHeatmapVertical extends StatefulWidget {
  // 1. Agregar las propiedades 'rows' y 'cols' al constructor
  final List<String> rows;
  final List<String> cols;

  const MatrixHeatmapVertical({super.key, required this.rows,
    required this.cols,});

  @override
  State<MatrixHeatmapVertical> createState() => _MatrixHeatmapVerticalState();
}

class _MatrixHeatmapVerticalState extends State<MatrixHeatmapVertical> {
  late HeatmapData heatmapData;
  HeatmapItem? selectedItem;

  @override
  void initState() {
    super.initState();
    _generateHeatmapData(widget.rows, widget.cols);
  }

  void _generateHeatmapData(List<String> dynamicRows, List<String> dynamicCols) {

    final random = Random();
    heatmapData = HeatmapData(
      rows: dynamicRows, // Se invierten las filas y columnas
      columns: dynamicCols, // Se invierten las filas y columnas
      items: [
        for (int y = 0; y < dynamicCols.length; y++) // Se usa cols para el bucle y
          for (int x = 0; x < dynamicRows.length; x++) // Se usa rows para el bucle x
            HeatmapItem(
              value: random.nextDouble() * 10,
              unit: 'kWh',
              xAxisLabel: dynamicRows[x],
              yAxisLabel: dynamicCols[y],
            ),
      ],
      selectedColor: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          selectedItem != null
              ? 'Valor: ${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}\n(${selectedItem!.yAxisLabel} - ${selectedItem!.xAxisLabel})'
              : 'Selecciona una celda',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // controla ancho
              child: Heatmap(
                  heatmapData: heatmapData,
                  rowsVisible: heatmapData.rows.length,
                  onItemSelectedListener: (HeatmapItem? item) {
                    setState(() => selectedItem = item);
                  },
                ),
            ),
        ),
      ],
    );
  }
}