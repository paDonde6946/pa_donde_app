// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_ubicacion.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_destino_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_inicio_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/marcador_manual_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/agregar_servicio1_form.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/agregar_servicio2_form.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/agregar_servicio3_form.dart';
//---------------------------------------------------------------------

class RutaPag extends StatefulWidget {
  const RutaPag({Key? key}) : super(key: key);

  @override
  _RutaPagState createState() => _RutaPagState();
}

class _RutaPagState extends State<RutaPag> {
  /// LATE sirve para esperar a que se cree.
  late LocalizacionBloc localizacionBloc;
  late PreserviciosBloc preserviciosBloc;

  PageController controller = PageController();
  int page = 0;

  @override
  void initState() {
    super.initState();
    preserviciosBloc = BlocProvider.of<PreserviciosBloc>(context);
    localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);
    localizacionBloc.getPosicioActual();
    // localizacionBloc.comenzarSeguirUsuario();
  }

  @override
  void dispose() {
    // localizacionBloc.pararSeguirUsuario();

    super.dispose();
  }

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
                    markers: mapaState.markers.values.toSet(),
                  ),
                  SafeArea(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const BtnUbicacion())),
                  const MarcardorManual(),
                  SlidingUpPanel(
                    maxHeight: 230,
                    minHeight: 230,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    panelBuilder: (sc) => pageView(),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    onPanelSlide: (double pos) => setState(() {}),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget panel1() {
    return Column(children: [
      const SizedBox(height: 20),
      const BuscadorBarraInicio(),
      const SizedBox(height: 20),
      const BuscadorBarraDestino(),
      btnContinuar()
    ]);
  }

  Widget pageView() {
    return PageView(
      onPageChanged: (i) {
        page = i;
      },
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        panel1(),
        const AgregarServicioParte1(),
        const AgregarServicioParte2(),
        const AgregarServicioParte3(),
      ],
    );
  }

  Widget btnContinuar() {
    final size = MediaQuery.of(context).size;
    // final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    // final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);
    // final mapaBloc = BlocProvider.of<MapsBloc>(context);

    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        SizedBox(
          width: size.width * 0.9,
          child: BtnAnaranja(
              titulo: 'Continuar',
              function: () async {
                controller.jumpToPage(1);
                BlocProvider.of<PreserviciosBloc>(context)
                    .add(OnCambiarPagina(controller));

                // final coordenadaInicio =
                //     localizacionBloc.state.ultimaLocalizacion;

                // if (coordenadaInicio == null) return;

                // final coordenadaFin = mapaBloc.centroMapa;
                // if (coordenadaFin == null) return;

                // final reesponseRuta = await busquedaBloc.getCoordInicioYFin(
                //     coordenadaInicio, coordenadaFin);

                // await mapaBloc.dibujarRutaPolyline(context, reesponseRuta);

                // busquedaBloc.add(OnDesactivarMarcadorManual());
              }),
        ),
      ],
    );
  }
}
