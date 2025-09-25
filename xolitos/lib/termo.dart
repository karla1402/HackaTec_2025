import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';

class HeatmapPage extends StatefulWidget {
  const HeatmapPage({super.key});

  @override
  State<HeatmapPage> createState() => _HeatmapPageState();
}

class _HeatmapPageState extends State<HeatmapPage> {
  late HeatmapData heatmapData;
  HeatmapItem? selectedItem;

  @override
  void initState() {
    super.initState();
    _generateExampleData();
  }

  void _generateExampleData() {
    const rows = ['2022', '2021', '2020', '2019'];
    const cols = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final random = Random();
    heatmapData = HeatmapData(
      rows: rows,
      columns: cols,
      items: [
        for (int y = 0; y < rows.length; y++)
          for (int x = 0; x < cols.length; x++)
            HeatmapItem(
              value: random.nextDouble() * 10,
              unit: 'kWh',
              xAxisLabel: cols[x],
              yAxisLabel: rows[y],
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heatmap tipo matriz")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              selectedItem != null
                  ? 'Valor: ${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}\n(${selectedItem!.yAxisLabel} - ${selectedItem!.xAxisLabel})'
                  : 'Selecciona una celda',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Heatmap(
              heatmapData: heatmapData,
              rowsVisible: 4, // filas visibles a la vez
              onItemSelectedListener: (HeatmapItem? item) {
                setState(() => selectedItem = item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
