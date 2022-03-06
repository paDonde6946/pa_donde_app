part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class OnEmpezarChat extends ChatEvent {
  final String servicio;
  final dynamic para;
  const OnEmpezarChat(this.para, this.servicio);
}

class OnCerrarChat extends ChatEvent {
  final String servicio;
  final dynamic para;
  const OnCerrarChat(this.para, this.servicio);
}
