import 'package:flutter/cupertino.dart';

class Servicio with ChangeNotifier {
  String? _estado;
  String? _nombreOrigen;
  String? _nombreDestino;
  String? _polylineRuta;
  String? _horaInicio;
  String? _idVehiculo;
  DateTime? _fecha;
  int? _cantidadCupos;
  int? _auxilioEconomico;

  Servicio({
    String? pEstado,
    String? pNombreOrigen,
    String? pNombreDestino,
    String? pPolylineRuta,
    String? pHoraInicio,
    DateTime? pFecha,
    String? pIdVehiculo,
    int? pCantidadCupos,
    int? pAuxilioEconomico,
  }) {
    estado = pEstado;
    nombreOrigen = pNombreOrigen;
    nombreDestino = pNombreDestino;
    polylineRuta = pPolylineRuta;
    horaInicio = pHoraInicio;
    fecha = pFecha;
    idVehiculo = pIdVehiculo;
    cantidadCupos = pCantidadCupos;
    auxilioEconomico = pAuxilioEconomico;
  }

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

  get horaInicio => _horaInicio;

  set horaInicio(horaInicio) {
    _horaInicio = horaInicio;
  }

  get fecha => _fecha;

  set fecha(fecha) {
    _fecha = fecha;
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
}
