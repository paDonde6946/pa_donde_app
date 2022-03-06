part of 'chat_bloc.dart';

class ChatState extends Equatable {
  // Variable que guarda el nombre y el uid del remitente
  final dynamic para;
  // Varible que guarda el uid
  final String servicio;

  const ChatState({this.para = "", this.servicio = ""});

  ChatState copyWith({dynamic para, String? servicio}) => ChatState(
        para: para ?? this.para,
        servicio: servicio ?? this.servicio,
      );

  @override
  List<Object> get props => [para, servicio];
}
