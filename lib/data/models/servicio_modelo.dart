import 'dart:convert';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/response/pasejeros_response.dart';
//---------------------------------------------------------------------

Servicio servicioFromJson(String str) => Servicio.fromJson(json.decode(str));

String servicioToJson(Servicio data) => json.encode(data.toJson());

class Servicio {
  int? _estado;
  String? _nombreOrigen;
  String? _nombreDestino;
  String? _polylineRuta;
  String? _idVehiculo;
  String? _fechayhora;
  int? _cantidadCupos;
  String? _auxilioEconomico;
  String? _distancia;
  String? _duracion;
  List<Feature>? _historialOrigen;
  List<Feature>? _historialDestino;
  List<PasajeroElement>? _pasajeros;
  String? _uid;
  String? _nombreConductor;

  Servicio(
      {int? pEstado,
      String? pNombreOrigen,
      String? pNombreDestino,
      String? pPolylineRuta,
      String? pFechayhora,
      String? pIdVehiculo,
      int? pCantidadCupos,
      String? pAuxilioEconomico,
      String? pDistancia,
      String? pDuracion,
      List<Feature>? pHistorialOrigen,
      List<Feature>? pHistorialDestino,
      String? pUid,
      List<PasajeroElement>? pPasajeros,
      String? pNombreConductor}) {
    estado = pEstado;
    nombreOrigen = pNombreOrigen;
    nombreDestino = pNombreDestino;
    polylineRuta = pPolylineRuta;
    fechayhora = pFechayhora;
    idVehiculo = pIdVehiculo;
    cantidadCupos = pCantidadCupos;
    auxilioEconomico = pAuxilioEconomico;
    distancia = pDistancia;
    duracion = pDuracion;
    historialOrigen = pHistorialOrigen;
    historialDestino = pHistorialDestino;
    uid = pUid;
    nombreConductor = pNombreConductor;
    pasajeros = pPasajeros;
  }

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
      pEstado: json['estado'],
      pNombreOrigen: json["nombreOrigen"],
      pNombreDestino: json["nombreDestino"],
      pPolylineRuta: json["polylineRuta"],
      pFechayhora: json["fechayhora"],
      pIdVehiculo: json["idVehiculo"],
      pCantidadCupos: json["cantidadCupos"],
      pAuxilioEconomico: json["idAuxilioEconomico"],
      pDistancia: json["distancia"],
      pDuracion: json["duracion"],
      pHistorialOrigen: json["historialOrigen"],
      pHistorialDestino: json["historialDestino"],
      pUid: json["uid"],
      pNombreConductor: json["nombreConductor"],
      pPasajeros: List<PasajeroElement>.from(
          json["pasajeros"].map((x) => PasajeroElement.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "nombreOrigen": nombreOrigen,
        "nombreDestino": nombreDestino,
        "polylineRuta": polylineRuta,
        "fechayhora": fechayhora.toString(),
        "idVehiculo": idVehiculo,
        "cantidadCupos": cantidadCupos,
        "idAuxilioEconomico": auxilioEconomico,
        "distancia": distancia,
        "duracion": duracion,
        "historialOrigen": historialOrigen,
        "historialDestino": historialDestino,
        "uid": uid,
        "nombreConductor": nombreConductor
      };

  get estado => _estado;

  set estado(estado) {
    _estado = estado;
  }

  get nombreOrigen => _nombreOrigen;

  set nombreOrigen(nombreOrigen) {
    _nombreOrigen = nombreOrigen;
  }

  get polylineRuta => _polylineRuta;

  set polylineRuta(polylineRuta) {
    _polylineRuta = polylineRuta;
  }

  get nombreDestino => _nombreDestino;

  set nombreDestino(nombreDestino) {
    _nombreDestino = nombreDestino;
  }

  get fechayhora => _fechayhora;

  set fechayhora(fechayHora) {
    _fechayhora = fechayHora;
  }

  get idVehiculo => _idVehiculo;

  set idVehiculo(idVehiculo) {
    _idVehiculo = idVehiculo;
  }

  get cantidadCupos => _cantidadCupos;

  set cantidadCupos(cantidadCupos) {
    _cantidadCupos = cantidadCupos;
  }

  get auxilioEconomico => _auxilioEconomico;

  set auxilioEconomico(auxilioEconomico) {
    _auxilioEconomico = auxilioEconomico;
  }

  get distancia => _distancia;

  set distancia(pDistancia) {
    _distancia = pDistancia;
  }

  get duracion => _duracion;

  set duracion(pDuracion) {
    _duracion = pDuracion;
  }

  get historialOrigen => _historialOrigen;

  set historialOrigen(pHistorialOrigen) {
    _historialOrigen = pHistorialOrigen;
  }

  get historialDestino => _historialDestino;

  set historialDestino(pHistorialDestino) {
    _historialDestino = pHistorialDestino;
  }

  get uid => _uid;

  set uid(pUid) {
    _uid = pUid;
  }

  get pasajeros => _pasajeros;

  set pasajeros(pPasajeros) {
    _pasajeros = pPasajeros;
  }

  get nombreConductor => _nombreConductor;
  set nombreConductor(pNombreConductor) {
    _nombreConductor = pNombreConductor;
  }
}
