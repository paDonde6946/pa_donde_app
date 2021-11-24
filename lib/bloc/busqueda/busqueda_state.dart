part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;
  final List<BusquedaResultado> historial;

  BusquedaState(
      {this.seleccionManual = false, List<BusquedaResultado>? historial})
      : historial = (historial == null) ? [] : historial;

  BusquedaState copyWith({
    bool? seleccionManual,
    List<BusquedaResultado>? historial,
  }) =>
      BusquedaState(
          seleccionManual: seleccionManual ?? this.seleccionManual,
          historial: historial ?? this.historial);
}
