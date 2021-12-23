part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool estaGpsHabilitado;
  final bool tieneGpsPermisoOtorgado;

  bool get todoTienePermiso => estaGpsHabilitado && tieneGpsPermisoOtorgado;

  const GpsState({
    required this.estaGpsHabilitado,
    required this.tieneGpsPermisoOtorgado,
  });

  ///
  GpsState copyWith({
    bool? pEstaGpsHabilitado,
    bool? pTieneGpsPermisoOtorgado,
  }) =>
      GpsState(
        estaGpsHabilitado: pEstaGpsHabilitado ?? estaGpsHabilitado,
        tieneGpsPermisoOtorgado:
            pTieneGpsPermisoOtorgado ?? tieneGpsPermisoOtorgado,
      );

  @override
  List<Object> get props => [estaGpsHabilitado, tieneGpsPermisoOtorgado];

  @override
  String toString() =>
      '{estaGpsHabilitado: $estaGpsHabilitado, tiene GPS permisos Otorgados: $tieneGpsPermisoOtorgado}';
}
