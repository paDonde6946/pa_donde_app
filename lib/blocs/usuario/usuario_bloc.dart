import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

part 'usuario_event.dart';
part 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  UsuarioBloc() : super(UsuarioState(usuario: Usuario())) {
    on<OnActualizarUsuario>((event, emit) {
      emit(state.copyWith(usuario: event.usuario));
    });
  }
}
