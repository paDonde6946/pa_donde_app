// To parse this JSON data, do
//
//     final servicio = servicioFromJson(jsonString);

import 'dart:convert';
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';

Servicio servicioFromJson(String str) => Servicio.fromJson(json.decode(str));

String servicioToJson(Servicio data) => json.encode(data.toJson());

class Servicio {
  String? _estado;
  String? _nombreOrigen;
  String? _nombreDestino;
  String? _polylineRuta;
  String? _idVehiculo;
  DateTime? _fechayhora;
  int? _cantidadCupos;
  String? _auxilioEconomico;
  RutaDestino? _rutaDestino;

  Servicio({
    String? pEstado,
    String? pNombreOrigen,
    String? pNombreDestino,
    String? pPolylineRuta,
    DateTime? pFechayhora,
    String? pIdVehiculo,
    int? pCantidadCupos,
    String? pAuxilioEconomico,
    RutaDestino? pRutaDestino,
  }) {
    estado = pEstado;
    nombreOrigen = pNombreOrigen;
    nombreDestino = pNombreDestino;
    polylineRuta = pPolylineRuta;
    fechayhora = pFechayhora;
    idVehiculo = pIdVehiculo;
    cantidadCupos = pCantidadCupos;
    auxilioEconomico = pAuxilioEconomico;
    rutaDestino = pRutaDestino;
  }

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
        pNombreOrigen: json["nombreOrigen"],
        pNombreDestino: json["nombreDestino"],
        pPolylineRuta: json["polylineRuta"],
        pFechayhora: json["fechayhora"],
        pIdVehiculo: json["idVehiculo"],
        pCantidadCupos: json["cantidadCupos"],
        pAuxilioEconomico: json["idAuxilioEconomico"],
      );

  Map<String, dynamic> toJson() => {
        "nombreOrigen": nombreOrigen,
        "nombreDestino": nombreDestino,
        "polylineRuta": polylineRuta,
        "fechayhora": fechayhora.toString(),
        "idVehiculo": idVehiculo,
        "cantidadCupos": cantidadCupos,
        "idAuxilioEconomico": auxilioEconomico,
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

  get rutaDestino => _rutaDestino;

  set rutaDestino(pRutaDestino) {
    _rutaDestino = pRutaDestino;
  }
}
