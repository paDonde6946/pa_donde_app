part of 'paginas_bloc.dart';

class PaginasState extends Equatable {
  final int controladorPagina;
  final Widget paginaMostrar;

  const PaginasState({
    this.controladorPagina = 0,
    required this.paginaMostrar,
  });

  PaginasState copyWith({
    int? controladorPagina,
    Widget? paginaMostrar,
  }) =>
      PaginasState(
          paginaMostrar: paginaMostrar ?? this.paginaMostrar,
          controladorPagina: controladorPagina ?? this.controladorPagina);

  @override
  List<Object> get props => [controladorPagina, paginaMostrar];
}
