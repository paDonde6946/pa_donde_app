// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_alternar_ruta_usuario.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_seguir_usuario.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_ubicacion.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_destino_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_inicio_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/marcador_manual_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//---------------------------------------------------------------------

class RutaPag extends StatefulWidget {
  const RutaPag({Key? key}) : super(key: key);

  @override
  _RutaPagState createState() => _RutaPagState();
}

class _RutaPagState extends State<RutaPag> {
  /// LATE sirve para esperar a que se cree.
  late LocalizacionBloc localizacionBloc;

  @override
  void initState() {
    super.initState();

    localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);
    localizacionBloc.getPosicioActual();
    // localizacionBloc.comenzarSeguirUsuario();
  }

  @override
  void dispose() {
    // localizacionBloc.pararSeguirUsuario();

    super.dispose();
  }

  double _fabHeight = 0;
  final double _initFabHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocalizacionBloc, LocalizacionState>(
        builder: (context, localizacionState) {
          if (localizacionState.ultimaLocalizacion == null) {
            return const Center(child: Text('Espere por favor....'));
          }

          return BlocBuilder<MapsBloc, MapsState>(
            builder: (context, mapaState) {
              Map<String, Polyline> polylines = Map.from(mapaState.polylines);

              if (!mapaState.mostrarMiRuta) {
                polylines.removeWhere((key, value) => key == 'miRuta');
              }

              return Stack(
                children: [
                  MapaView(
                    initialLocalizacion: localizacionState.ultimaLocalizacion!,
                    polylines: polylines.values.toSet(),
                  ),
                  SafeArea(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: const [
                              BtnAlternarRutaUsuario(),
                              BtnSeguirUsuario(),
                              BtnUbicacion(),
                            ],
                          ))),
                  const MarcardorManual(),
                  SlidingUpPanel(
                    maxHeight: 210,
                    minHeight: 160,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    panelBuilder: (sc) => Column(children: [
                      // BuscadorBarraInicio(
                      //     busquedaDireccion: (busquedaBloc.isEmpty)
                      //         ? 'Origen'
                      //         : busquedaBloc[0].nombreDestino!),
                      const SizedBox(height: 20),

                      const BuscadorBarraInicio(busquedaDireccion: ''),
                      const SizedBox(height: 20),
                      const BuscadorBarraDestino(
                        busquedaDireccion: '',
                      ),

                      btnContinuar()
                    ]),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    onPanelSlide: (double pos) => setState(() {
                      _fabHeight = pos * (300 - 100) + _initFabHeight;
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget btnContinuar() {
    final size = MediaQuery.of(context).size;
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);
    final mapaBloc = BlocProvider.of<MapsBloc>(context);

    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        SizedBox(
          width: size.width * 0.9,
          child: BtnAnaranja(
              titulo: 'Continuar',
              function: () async {
                final coordenadaInicio =
                    localizacionBloc.state.ultimaLocalizacion;

                if (coordenadaInicio == null) return;

                final coordenadaFin = mapaBloc.centroMapa;
                if (coordenadaFin == null) return;

                final reesponseRuta = await busquedaBloc.getCoordInicioYFin(
                    coordenadaInicio, coordenadaFin);

                await mapaBloc.dibujarRutaPolyline(context, reesponseRuta);

                busquedaBloc.add(OnDesactivarMarcadorManual());

                // final traficoServicio = TraficoServicio();
                // final inicio =
                //     BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
                // final destino = BlocProvider.of<MapaBloc>(context).state.ubicacionCentral;

                // final ruta = await traficoServicio.getCoordsInicioYFin(
                //     inicio!, destino!);

                // final geometry = ruta.routes![0].geometry;
                // final duracion = ruta.routes![0].duration;
                // final distancia = ruta.routes![0].distance;

                // final points =
                //     Poly.Polyline.Decode(encodedString: geometry!, precision: 6)
                //         .decodedCoords;

                // final List<LatLng> rutaCoords =
                //     points.map((point) => LatLng(point[0], point[1])).toList();

                // mapaBloc.add(OnCrearRutaInicioDestino(
                //     rutaCoords, distancia!, duracion!));
              }),
        ),
      ],
    );
  }
}
