part of 'chat_bloc.dart';

class ChatState extends Equatable {
  // Variable que guarda el nombre y el uid del remitente
  final List<Mensaje>? conversacion;

  const ChatState({this.conversacion});

  ChatState copyWith({List<Mensaje>? conversacion}) =>
      ChatState(conversacion: conversacion);

  @override
  List<Object?> get props => [conversacion];
}
