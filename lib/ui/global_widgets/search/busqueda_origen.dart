import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';

class BusquedaOrigen extends SearchDelegate<BusquedaResultado> {
  @override
  // ignore: overridden_fields
  String searchFieldLabel;
  final TraficoServicio traficoServicio;
  final LatLng proximidad;

  BusquedaOrigen(this.proximidad)
      : searchFieldLabel = "Buscar",
        traficoServicio = TraficoServicio();

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
    final s = traficoServicio.getResultadosPorQuery(query.trim(), proximidad);
    print(s);
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text("Colocar ubicacion manulamente"),
          onTap: () {
            /// El usuario no cancelo pero si elijo la opcion manualmente
            close(context, BusquedaResultado(cancelo: false, manual: true));
          },
        )
      ],
    );
  }

  Widget _construirResultadosSugerencias() {
    return FutureBuilder(
      future: traficoServicio.getResultadosPorQuery(query.trim(), proximidad),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lugares = snapshot.data!.features;

        return ListView.separated(
          itemCount: lugares == null ? 0 : lugares.length,
          separatorBuilder: (_, i) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            final lugar = lugares![index];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(lugar.textEs!),
              subtitle: Text(lugar.placeNameEs!),
              onTap: () {
                print(lugar);
              },
            );
          },
        );
      },
    );
  }
}
