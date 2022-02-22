part of 'usuario_bloc.dart';

abstract class UsuarioEvent extends Equatable {
  const UsuarioEvent();

  @override
  List<Object> get props => [];  
}

class OnActualizarUsuario extends UsuarioEvent {
  final Usuario usuario;
  const OnActualizarUsuario(this.usuario);
}
