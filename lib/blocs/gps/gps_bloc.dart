import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  ///
  StreamSubscription? gpsServicioSuscripcion;
  bool? validar = false;

  GpsBloc()
      : super(const GpsState(
            estaGpsHabilitado: false, tieneGpsPermisoOtorgado: false)) {
    /// Va a cambiar los estados cuando se llame.
    on<GpsYPermisoEvent>((event, emit) => emit(state.copyWith(
          pEstaGpsHabilitado: event.estaGpsHabilitado,
          pTieneGpsPermisoOtorgado: event.tieneGpsPerimisoOtorgados,
        )));
    on<OnTienePermiso>((event, emit) => emit(state.copyWith(
          pTieneGpsPermisoOtorgado: event.tieneGpsPerimisoOtorgados,
        )));

    _init();
  }

  /// Metódo que inicia apenas se crea el bloc
  Future<void> _init() async {
    /// Se ejecuta en simultaneo los future
    final gpsInitStatus = await Future.wait([
      _verificarGpsEstado(),
      _verificarPermisoGpsOtorgado(),
    ]);

    /// Se agrega un nuevo evento al Bloc para que se dispare si llega a cambiar
    add(GpsYPermisoEvent(
      estaGpsHabilitado: gpsInitStatus[0],
      tieneGpsPerimisoOtorgados: gpsInitStatus[1],
    ));
  }

  /// Verifica que la localización del dispositivo este activa o no
  Future<bool> _verificarGpsEstado() async {
    final estaHabilitado = await Geolocator.isLocationServiceEnabled();

    /// Esta validando o escuchando el estado de la localización del dispositivo
    gpsServicioSuscripcion =
        Geolocator.getServiceStatusStream().listen((event) {
      final localizacionHabilitado = (event.index == 1) ? true : false;

      /// Se agrega un nuevo evento al Bloc para que se dispare si llega a cambiar
      add(GpsYPermisoEvent(
        estaGpsHabilitado: localizacionHabilitado,
        tieneGpsPerimisoOtorgados: state.tieneGpsPermisoOtorgado,
      ));
    });

    return estaHabilitado;
  }

  /// Verifica que se tenga permisos para poder usar el GPS del dispositivo
  Future<bool> _verificarPermisoGpsOtorgado() async {
    final permisoOtorgado = await Permission.location.isGranted;
    return permisoOtorgado;
  }

  /// Verifica si el APK tiene acceso al GPS del dispositivo - Valida que el APK tenga permisos de localizacion para poder usar el GPS
  Future<void> preguntarGpsAcceso() async {
    final estado = await Permission.location.request();

    switch (estado) {
      case PermissionStatus.granted:
        add(const OnTienePermiso(true));
        validar = true;

        ///
        add(GpsYPermisoEvent(
          estaGpsHabilitado: state.estaGpsHabilitado,
          tieneGpsPerimisoOtorgados: true,
        ));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        add(GpsYPermisoEvent(
          estaGpsHabilitado: state.estaGpsHabilitado,
          tieneGpsPerimisoOtorgados: false,
        ));
        break;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }

  /// Cerrar el listener del Geolocator
  @override
  Future<void> close() {
    gpsServicioSuscripcion?.cancel();
    return super.close();
  }
}
