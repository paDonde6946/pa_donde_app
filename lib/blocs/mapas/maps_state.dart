part of 'maps_bloc.dart';

class MapsState extends Equatable {
  final bool estaMapaInicializado;
  final bool seguirUsuario;
  final bool mostrarMiRuta;

  // Polylines
  final Map<String, Polyline> polylines;

  const MapsState(
      {this.estaMapaInicializado = false,
      this.seguirUsuario = true,
      this.mostrarMiRuta = false,
      Map<String, Polyline>? polylines})
      : polylines = polylines ?? const {};

  MapsState copyWith({
    bool? estaMapaInicializado,
    bool? seguirUsuario,
    bool? mostrarMiRuta,
    Map<String, Polyline>? polylines,
  }) =>
      MapsState(
        estaMapaInicializado: estaMapaInicializado ?? this.estaMapaInicializado,
        seguirUsuario: seguirUsuario ?? this.seguirUsuario,
        mostrarMiRuta: mostrarMiRuta ?? this.mostrarMiRuta,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props =>
      [estaMapaInicializado, seguirUsuario, mostrarMiRuta, polylines];
}
