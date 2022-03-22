import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pa_donde_app/data/models/mensaje_modelo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<OnCargarChat>((event, emit) {
      emit(state.copyWith(conversacion: event.conversacion));
    });
  }

  void agregarMensajeConversacion(Mensaje mensaje) {
    final chat = [mensaje, ...state.conversacion];
    add(OnCargarChat(chat));
  }

  void eliminarConversacion() {
    List<Mensaje> chat = [];
    add(OnCargarChat(chat));
  }
}
