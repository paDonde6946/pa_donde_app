import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<OnEmpezarChat>((event, emit) {
      // TODO: implement event handler
    });
    on<OnCerrarChat>((event, emit) {
      // TODO: implement event handler
    });
  }
}
