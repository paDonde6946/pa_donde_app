part of 'paginas_bloc.dart';

abstract class PaginasEvent extends Equatable {
  const PaginasEvent();

  @override
  List<Object> get props => [];
}

class OnCambiarPaginaPrincipal extends PaginasEvent {
  final Widget pagina;
  final int controladorPagina;
  const OnCambiarPaginaPrincipal(this.pagina, this.controladorPagina);
}
