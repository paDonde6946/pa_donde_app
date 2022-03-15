part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class OnCargarChat extends ChatEvent {
  final List<Mensaje> conversacion;
  const OnCargarChat(this.conversacion);
}
