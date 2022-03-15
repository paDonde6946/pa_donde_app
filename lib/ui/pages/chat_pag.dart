import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/chat/chat_bloc.dart';
import 'package:pa_donde_app/blocs/usuario/usuario_bloc.dart';
import 'package:pa_donde_app/data/models/mensaje_modelo.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/chat_servicio.dart';
import 'package:pa_donde_app/data/services/socket_servicio.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/widgets/mensaje_chat_widget.dart';

//---------------------------------------------------------------------

class ChatPag extends StatefulWidget {
  final String servicio;
  final String? uidPasajero;
  final String? nombre;
  final String token;

  const ChatPag(this.servicio, this.uidPasajero, this.nombre, this.token,
      {Key? key})
      : super(key: key);

  @override
  _ChatPagState createState() => _ChatPagState();
}

class _ChatPagState extends State<ChatPag> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<MensajeChatWidget> _mensajes = [];
  bool _estaEscribiendo = false;

  ChatServicio servicioChat = ChatServicio();
  late SocketServicio servicioSocket;
  late Usuario usuario;

  @override
  // ignore: must_call_super
  void initState() {
    usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;
    servicioSocket = SocketServicio(
        datosMensaje: Mensaje(
            para: widget.uidPasajero,
            de: usuario.uid,
            servicio: widget.servicio),
        context: context,
        token: widget.token);
    servicioSocket.socket
        .on('recibirMensaje', (data) => {servicioSocket.recivirMensaje(data)});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        child: encabezadoChat(),
        preferredSize:
            Size(MediaQuery.of(context).size.width, size.height * 0.077),
      ),
      body: Column(
        children: [
          Flexible(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.conversacion == []) {
                  return Container();
                } else {
                  return conversacion(state.conversacion);
                }
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _entradaChat(),
          )
        ],
      ),
    );
  }

  /// Este es el encabezado del chat que contiene el circculo del avatar y ademas el nombre del proveedor
  Widget encabezadoChat() {
    final size = MediaQuery.of(context).size;

    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ]),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 20.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, right: size.width * 0.43),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ICONO PARA REGRESAR A LA PAGINA ANTERIOR
            IconButton(
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    widget.nombre!.split('')[0],
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  maxRadius: 14,
                ),
                const SizedBox(height: 0.5),
                Text(
                  widget.nombre!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.045,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      preferredSize:
          Size(MediaQuery.of(context).size.width, size.height * 0.077),
    );
  }

  // /// Es la parte inferior del chat en la cual se escribe para poder ingresar y enviar un mensaje
  Widget _entradaChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Flexible(
                child: TextField(
              controller: _textController,
              // onSubmitted: ,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().isNotEmpty) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                  hintText: "Enviar mensaje..."),
              focusNode: _focusNode,
            )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: _estaEscribiendo
                              ? () => _enviar(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // ///Es la accion mas la animacion que realiza cuando se envian los mensajes, ademas de eso limpia el teclado
  _enviar(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    Mensaje mensaje = Mensaje(
        de: usuario.uid, para: "", mensaje: texto, servicio: widget.servicio);
    BlocProvider.of<ChatBloc>(context).agregarMensajeConversacion(mensaje);
    // .state.conversacion?.add(mensaje);

    servicioSocket.enviarMensaje(texto);
  }

  // Carga los mensajes
  Widget conversacion(List<Mensaje> conversacion) {
    List<Widget> chat = [];
    for (Mensaje mensaje in conversacion) {
      chat.add(MensajeChatWidget(
        texto: mensaje.mensaje!,
        mio: mensaje.de == usuario.uid,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward(),
      ));
    }

    return ListView(
      children: chat,
      physics: const BouncingScrollPhysics(),
      reverse: true,
    );
  }

  @override
  void dispose() {
    for (MensajeChatWidget message in _mensajes) {
      message.animationController.dispose();
    }
    servicioSocket.disconnect();
    super.dispose();
  }
}
