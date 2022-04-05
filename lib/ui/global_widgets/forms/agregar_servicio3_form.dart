import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';
//---------------------------------------------------------------------

class AgregarServicioParte3 extends StatefulWidget {
  const AgregarServicioParte3({Key? key}) : super(key: key);

  @override
  State<AgregarServicioParte3> createState() =>
      // ignore: no_logic_in_create_state
      _AgregarServicioParte3State();
}

class _AgregarServicioParte3State extends State<AgregarServicioParte3> {
  int seleccion = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        children: [
          titulo(),
          listadoPrecios(),
          const SizedBox(height: 10),
          BtnAnaranja(
            titulo: 'Finalizar',
            function: () async {
              final servicioBloc = BlocProvider.of<PreserviciosBloc>(context);
              final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
              if (seleccion >= 0) {
                final tamanioHistorialOrigen =
                    busquedaBloc.state.historialOrigen.length;
                final tamanioHistorialDestino =
                    busquedaBloc.state.historialDestino.length;

                servicioBloc.servicio!.auxilioEconomico =
                    servicioBloc.precios![seleccion].uid;
                servicioBloc.servicio!.historialOrigen =
                    busquedaBloc.state.historialOrigen.sublist(
                        0,
                        tamanioHistorialOrigen < 10
                            ? tamanioHistorialOrigen
                            : 10);
                servicioBloc.servicio!.historialDestino =
                    busquedaBloc.state.historialDestino.sublist(
                        0,
                        tamanioHistorialDestino < 10
                            ? tamanioHistorialDestino
                            : 10);

                servicioBloc.add(OnCrearServicio(servicioBloc.servicio!));

                final servicioEnvio = await ServicioRServicio()
                    .crearServicio(servicioBloc.servicio!);

                if (servicioEnvio) {
                  mostrarShowDialogConfirmar(
                      context: context,
                      titulo: "Servicio",
                      contenido: "Su servicio ha sido creeado",
                      paginaRetorno: 'validarInicioSesion');

                  servicioBloc.add(OnCrearServicio(Servicio()));

                  BlocProvider.of<PaginasBloc>(context)
                      .add(const OnCambiarPaginaPrincipal(PrincipalPag(), 0));

                  setState(() {});
                } else {
                  customShapeSnackBar(
                      context: context, titulo: "No se pudo crear el servicio");
                }
              } else {
                mostrarShowDialogInformativo(
                    context: context,
                    titulo: 'Precio',
                    contenido: 'Debe de seleccionar un precio');
              }
            },
          )
        ],
      ),
    );
  }

  /// Metodo para crear el titulo del form y los botones superiores
  Widget titulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<PreserviciosBloc>(context)
                  .controller!
                  .jumpToPage(2);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        const Text("Seleccione el valor del auxilio"),
        Container(width: 40)
      ],
    );
  }

  Widget cardPrecio(String nombre, int posicion) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        seleccion = posicion;
        setState(() {});
      },
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text(nombre)),
          height: size.height * 0.05,
          width: size.width * 0.3,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: seleccion == posicion
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  offset: const Offset(1.0, 1.0), //(x,y)
                  blurRadius: 9.0,
                ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  Widget listadoPrecios() {
    return BlocBuilder<PreserviciosBloc, PreserviciosState>(
      builder: (context, snapshot) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardPrecio(snapshot.precios[0].valor.toString(), 0),
                cardPrecio(snapshot.precios[1].valor.toString(), 1)
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardPrecio(snapshot.precios[2].valor.toString(), 2),
                cardPrecio(snapshot.precios[3].valor.toString(), 3)
              ],
            )
          ],
        );
      },
    );
  }
}
