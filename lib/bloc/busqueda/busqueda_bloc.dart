import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState());

  @override
  Stream<BusquedaState> mapEventToState(BusquedaEvent event) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: true);
    } else if (event is OnDesactivarMarcadorManual) {
      yield state.copyWith(seleccionManual: false);
    } else if (event is OnAgregarHistorial) {
      final existe = state.historial
          .where((resultado) =>
              resultado.nombreDestino == event.resultado.nombreDestino)
          .length;
      if (existe == 0) {
        final newHistorial = [...state.historial, event.resultado];
        yield state.copyWith(historial: newHistorial);
      }
    }
  }
}
