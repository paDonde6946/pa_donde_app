import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/response/busqueda_response.dart';
//---------------------------------------------------------------------

void main() {
  /// RUTA DESTINO  MODELO PRUEBAS UNITARIAS - METODO CONSTRUCTOR COMPLETO
  test("Ruta Destino Modelo Pruebas - Método constructor completo", () {
    /// Función a probar (Constructor - campos completos)

    final lugarDestino = Feature();
    final rutaDestino = RutaDestino(
      puntos: [const LatLng(1.0, 0.1)],
      duracion: 30.3,
      distancia: 15,
      lugarFinal: lugarDestino,
    );

    // Valores esperados
    expect(rutaDestino.puntos, [const LatLng(1.0, 0.1)]);
    expect(rutaDestino.duracion, 30.3);
    expect(rutaDestino.distancia, 15);
    expect(rutaDestino.lugarFinal, lugarDestino);
  });
}
