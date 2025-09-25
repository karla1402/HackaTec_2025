// Archivo: lib/api_service.dart

import 'dart:convert';
import 'dart:io'; // Necesario para HttpStatus
import 'package:http/http.dart' as http;

class ApiService {
  // CORRECCIÓN: URL base actualizada para coincidir con el endpoint.
  static const String _baseUrl = 'https://agroorbit.onrender.com/api';

  /// Ejecuta el análisis satelital enviando los datos a la API.
  ///
  /// Lanza una excepción si la llamada a la API falla.
  static Future<Map<String, dynamic>> runAnalysis({
    required List<Map<String, double>> aoiCoords,
    required String startDate,
    required String endDate,
  }) async {
    // CORRECCIÓN: La ruta ahora se construye correctamente.
    final url = Uri.parse('$_baseUrl/v1/analyze/full');

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'aoi_coords': aoiCoords,
      'start_date': startDate,
      'end_date': endDate,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      // MEJORA: Manejo de errores más específico.
      if (response.statusCode == HttpStatus.ok) {
        // HttpStatus.ok es 200
        final responseBody = utf8.decode(response.bodyBytes);
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } else {
        // Intenta decodificar el cuerpo del error si existe.
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody['detail'] ?? response.reasonPhrase;
        throw Exception(
          'Error de la API (${response.statusCode}): $errorMessage',
        );
      }
    } on SocketException {
      throw Exception('Error de red: No se pudo conectar al servidor.');
    } catch (e) {
      // Relanza otros errores (ej. JSON malformado, etc.)
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }
}
