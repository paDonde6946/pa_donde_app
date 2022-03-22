import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
//---------------------------------------------------------------------

void main() {
  /// BUSQUEDA RESULTADOS MODELO PRUEBAS UNITARIAS - CONSTRUCCION DEL METODO CONSTRUCTOR
  test(
      "Busqueda Resultados Modelo Pruebas - Método constructor campos requeridos",
      () {
    /// Función a probar (Constructor - campos requeridos)
    final busquedaResutado = BusquedaResultado(cancelo: true);

    // Valores esperados
    expect(busquedaResutado.cancelo, true);
  });

  /// BUSQUEDA RESULTADOS  MODELO PRUEBAS UNITARIAS - METODO CONSTRUCTOR COMPLETO
  test("Busqueda Resultados Modelo Pruebas - Método constructor completo", () {
    /// Función a probar (Constructor - campos completos)
    final busquedaResutado = BusquedaResultado(
        cancelo: true,
        manual: false,
        posicion: const LatLng(1.0, -0.3),
        nombreDestino: "Tintal Plaza",
        descripcion: "Av. Cali con Av Americas");

    // Valores esperados
    expect(busquedaResutado.cancelo, true);
    expect(busquedaResutado.manual, false);
    expect(busquedaResutado.posicion, const LatLng(1.0, -0.3));
    expect(busquedaResutado.nombreDestino, "Tintal Plaza");
    expect(busquedaResutado.descripcion, "Av. Cali con Av Americas");
  });
}
