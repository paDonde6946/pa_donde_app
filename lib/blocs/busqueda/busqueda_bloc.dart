import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';
//---------------------------------------------------------------------

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  TraficoServicio traficoServicio;
  PreserviciosBloc preserviciosBloc;

  BusquedaBloc({
    required this.preserviciosBloc,
    required this.traficoServicio,
  }) : super(const BusquedaState()) {
    on<OnActivarMarcadorManual>(
        (event, emit) => emit(state.copyWith(seleccionManual: true)));
    on<OnDesactivarMarcadorManual>(
        (event, emit) => emit(state.copyWith(seleccionManual: false)));

    on<OnNuevosLugaresEncontradosEvent>(
        (event, emit) => emit(state.copyWith(lugares: event.lugares)));

    on<OnAgregarHistorialOrigenEvent>((event, emit) => emit(state.copyWith(
        historialOrigen: [event.lugarOrigen, ...state.historialOrigen])));

    on<OnAgregarHistorialDestionoEvent>((event, emit) => emit(state.copyWith(
        historialDestino: [event.lugarDestino, ...state.historialDestino])));
  }

  Future<RutaDestino> getCoordInicioYFin(LatLng inicio, LatLng destino) async {
    final traficoResponse =
        await traficoServicio.getCoordsInicioYFin(inicio, destino);

    final Servicio servicio = Servicio();

    /// Informacion del destino
    final lugarFinal =
        await traficoServicio.getInformacionPorCoordenas(destino);

    final distancia = traficoResponse.routes![0].distance;
    final duracion = traficoResponse.routes![0].duration;
    final geometria = traficoResponse.routes![0].geometry;

    // Deecodificar
    final puntos = decodePolyline(geometria!, accuracyExponent: 6);

    servicio.polylineRuta = geometria;
    servicio.distancia = distancia.toString();
    servicio.duracion = duracion.toString();
    preserviciosBloc.add(OnCrearServicio(servicio));

    final latLngLista = puntos
        .map((coord) => LatLng(coord[0].toDouble(), coord[1].toDouble()))
        .toList();

    return RutaDestino(
      puntos: latLngLista,
      duracion: duracion!,
      distancia: distancia!,
      lugarFinal: lugarFinal,
    );
  }

  Future getLugaresPorQuery(LatLng proximidad, String busqueda) async {
    final response =
        await traficoServicio.getResultadosPorQuery(busqueda, proximidad);

    // Disparar el evento para agregar los nuevos lugares buscados
    add(OnNuevosLugaresEncontradosEvent(response));
  }
}
