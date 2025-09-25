import 'package:flutter/material.dart';

class ParcelFormPage extends StatefulWidget {
  const ParcelFormPage({super.key});

  @override
  State<ParcelFormPage> createState() => _ParcelFormPageState();
}

class _ParcelFormPageState extends State<ParcelFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _parcelNameController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _parcelNameController.dispose();
    _cropTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _continueToMap() {
    if (!_formKey.currentState!.validate()) return;

    final parcelData = {
      'parcelName': _parcelNameController.text.trim(),
      'cropType': _cropTypeController.text.trim(),
      'notes': _notesController.text.trim(),
    };

    Navigator.pushNamed(context, '/map', arguments: parcelData).then((
      result,
    ) async {
      if (!mounted) return;
      if (result is Map && result['geometry'] != null) {
        final geometry = (result['geometry'] as List).toList();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Área seleccionada, enviando análisis...'),
          ),
        );
        setState(() {
          _submitting = true;
        });
        try {
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
            arguments: {
              'geometry': geometry,
              'start_date': '2023-01-01',
              'end_date': DateTime.now().toIso8601String().substring(0, 10),
            },
          );
        } finally {
          if (mounted)
            setState(() {
              _submitting = false;
            });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de la Parcela')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cuéntanos sobre tu parcela',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Estos datos nos ayudarán a personalizar el análisis satelital.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _parcelNameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre de la parcela',
                            hintText: 'Ej. Lote Norte 1',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cropTypeController,
                          decoration: InputDecoration(
                            labelText: 'Cultivo',
                            hintText: 'Ej. Maíz, Trigo, Soja',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            labelText: 'Notas (opcional)',
                            hintText: 'Detalles adicionales',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          minLines: 3,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: _submitting ? null : _continueToMap,
                            icon: const Icon(Icons.map_outlined),
                            label: _submitting
                                ? const Text('Procesando...')
                                : const Text('Continuar a mapa'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
