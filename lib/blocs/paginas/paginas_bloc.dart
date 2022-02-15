import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';

part 'paginas_event.dart';
part 'paginas_state.dart';

class PaginasBloc extends Bloc<PaginasEvent, PaginasState> {
  PaginasBloc() : super(const PaginasState(paginaMostrar: PrincipalPag())) {
    on<OnCambiarPaginaPrincipal>((event, emit) {
      emit(state.copyWith(
          paginaMostrar: event.pagina,
          controladorPagina: event.controladorPagina));
    });
  }
}
