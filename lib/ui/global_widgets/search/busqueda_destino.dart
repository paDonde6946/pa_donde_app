import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';

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
    return Text("Build Results");
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
}
