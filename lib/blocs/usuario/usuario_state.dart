part of 'usuario_bloc.dart';

class UsuarioState extends Equatable {
  final Usuario usuario;
  
  
  const UsuarioState({
    required this.usuario
  });

  UsuarioState copyWith({
    Usuario? usuario
  }) => 
      UsuarioState(
        usuario: usuario ?? this.usuario
      );
  
  @override
  List<Object> get props => [usuario];
}

