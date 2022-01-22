part of 'busqueda_bloc.dart';

@immutable
class BusquedaState extends Equatable {
  final bool seleccionManual;
  final List<Feature> historialOrigen;
  final List<Feature> historialDestino;
  final List<Feature> lugares;

  const BusquedaState({
    this.seleccionManual = false,
    this.lugares = const [],
    this.historialOrigen = const [],
    this.historialDestino = const [],
  });

  BusquedaState copyWith({
    bool? seleccionManual,
    List<Feature>? lugares,
    List<Feature>? historialOrigen,
    List<Feature>? historialDestino,
  }) =>
      BusquedaState(
        seleccionManual: seleccionManual ?? this.seleccionManual,
        lugares: lugares ?? this.lugares,
        historialOrigen: historialOrigen ?? this.historialOrigen,
        historialDestino: historialDestino ?? this.historialDestino,
      );

  @override
  List<Object?> get props =>
      [seleccionManual, lugares, historialOrigen, historialDestino];
}
