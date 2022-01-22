import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
//---------------------------------------------------------------------

class BusquedaDestino extends SearchDelegate<BusquedaResultado> {
  @override
  // ignore: overridden_fields
  String searchFieldLabel;

  BusquedaDestino() : searchFieldLabel = "Buscar destino";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      // El usuario cancelo la busqueda
      onPressed: () => close(context, BusquedaResultado(cancelo: true)),
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    final localizacionBloc =
        BlocProvider.of<LocalizacionBloc>(context).state.ultimaLocalizacion;

    busquedaBloc.getLugaresPorQuery(localizacionBloc!, query);

    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        final lugares = state.lugares;
        return ListView.separated(
          itemCount: lugares.length,
          itemBuilder: (context, i) {
            final lugar = lugares[i];
            return ListTile(
              title: Text(lugar.text!),
              subtitle: Text(lugar.placeName!),
              leading: const Icon(Icons.place_outlined, color: Colors.black),
              onTap: () {
                /// El usuario no cancelo pero si elijo la opcion manualmente
                close(
                    context,
                    BusquedaResultado(
                      cancelo: false,
                      manual: false,
                      posicion: LatLng(lugar.center![1], lugar.center![0]),
                      nombreDestino: lugar.text,
                      descripcion: lugar.placeName,
                    ));

                busquedaBloc.add(OnAgregarHistorialDestionoEvent(lugar));
                busquedaBloc.add(OnDesactivarMarcadorManual());
              },
            );
          },
          separatorBuilder: (context, i) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final historial =
        BlocProvider.of<BusquedaBloc>(context).state.historialDestino;

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text("Colocar ubicacion manulamente"),
          onTap: () {
            /// El usuario no cancelo pero si elijo la opcion manualmente
            close(context, BusquedaResultado(cancelo: false, manual: true));
          },
        ),
        ...historial.map((lugar) => ListTile(
              title: Text(lugar.text!),
              subtitle: Text(lugar.placeName!),
              leading: const Icon(Icons.history, color: Colors.black),
              onTap: () {
                close(
                    context,
                    BusquedaResultado(
                      cancelo: false,
                      manual: false,
                      posicion: LatLng(lugar.center![1], lugar.center![0]),
                      nombreDestino: lugar.text,
                      descripcion: lugar.placeName,
                    ));
              },
            ))
      ],
    );
  }
}
