part of 'localizacion_bloc.dart';

class LocalizacionState extends Equatable {
  final bool seguirUsuario;
  final LatLng? ultimaLocalizacion;
  final List<LatLng> miLocalizacionHistoria;

  const LocalizacionState({
    this.seguirUsuario = false,
    this.ultimaLocalizacion,
    miLocalizacionHistoria,
  }) : miLocalizacionHistoria = miLocalizacionHistoria ?? const [];

  LocalizacionState copyWith({
    bool? seguirUsuario,
    LatLng? ultimaLocalizacion,
    List<LatLng>? miLocalizacionHistoria,
  }) =>
      LocalizacionState(
        seguirUsuario: seguirUsuario ?? this.seguirUsuario,
        ultimaLocalizacion: ultimaLocalizacion ?? this.ultimaLocalizacion,
        miLocalizacionHistoria:
            miLocalizacionHistoria ?? this.miLocalizacionHistoria,
      );

  @override
  List<Object?> get props =>
      [seguirUsuario, ultimaLocalizacion, miLocalizacionHistoria];
}
