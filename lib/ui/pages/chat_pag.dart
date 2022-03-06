import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/chat_servicio.dart';
import 'package:provider/provider.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/widgets/mensaje_chat_widget.dart';

//---------------------------------------------------------------------

class ChatPag extends StatefulWidget {
  @override
  _ChatPagState createState() => _ChatPagState();
}

class _ChatPagState extends State<ChatPag> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<MensajeChatWidget> _mensajes = [];
  bool _estaEscribiendo = false;

  ChatServicio servicioChat = ChatServicio();
  // SocketServicio servicioSocket;

  @override
  void initState() {
    // this.servicioSocket = Provider.of<SocketServicio>(context, listen: false);
    // this.servicioSocket.socket.on('recibirMensaje', _escucharMensaje);
    // super.initState();

    // _cargarHistorial(this.servicioAutenticacion.usuarioServiciosActual.uid);
  }

  // void _cargarHistorial(String usuarioID) async {
  //   // List<MensajeModelo> chat = await this.servicioChat.getChat(usuarioID);

  //   final history = chat.map((m) => MensajeChatWidget(
  //         texto: m.mensaje,
  //         mio: m.de == this.servicioChat.postulado.id ? false : true,
  //         animationController: new AnimationController(
  //             vsync: this, duration: Duration(milliseconds: 0))
  //           ..forward(),
  //       ));

  //   setState(() {
  //     _mensajes.insertAll(0, history);
  //   });
  // }

  // void _escucharMensaje(dynamic payload) {
  //   print(payload);
  //   MensajeChatWidget message = new MensajeChatWidget(
  //     texto: payload['mensaje'],
  //     mio: false,
  //     animationController: AnimationController(
  //         vsync: this, duration: Duration(milliseconds: 300)),
  //   );

  //   if (this.mounted) {
  //     setState(() {
  //       _mensajes.insert(0, message);
  //     });
  //   }

  //   message.animationController.forward();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        child: encabezadoChat(),
        preferredSize:
            Size(MediaQuery.of(context).size.width, size.height * 0.077),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _mensajes.length,
              itemBuilder: (_, i) => _mensajes[i],
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            // Container(
            //   color: Colors.white,
            //   child: Text("Hola"),
            // )
          ],
        ),
      ),
    );
  }

  /// Este es el encabezado del chat que contiene el circculo del avatar y ademas el nombre del proveedor
  Widget encabezadoChat() {
    final size = MediaQuery.of(context).size;

    return PreferredSize(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [
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
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    "Ho",
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  maxRadius: 14,
                ),
                const SizedBox(height: 0.5),
                Text(
                  'Juan ',
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
  // Widget _entradaChat() {
  //   return SafeArea(
  //     child: Container(
  //       margin: EdgeInsets.symmetric(
  //         horizontal: 8.0,
  //       ),
  //       padding: EdgeInsets.symmetric(vertical: 10.0),
  //       child: Row(
  //         children: <Widget>[
  //           Flexible(
  //               child: TextField(
  //             controller: _textController,
  //             onSubmitted: _enviar,
  //             onChanged: (String texto) {
  //               setState(() {
  //                 if (texto.trim().length > 0) {
  //                   _estaEscribiendo = true;
  //                 } else {
  //                   _estaEscribiendo = false;
  //                 }
  //               });
  //             },
  //             decoration: InputDecoration.collapsed(hintText: "Enviar mensaje"),
  //             focusNode: _focusNode,
  //           )),
  //           Container(
  //               margin: EdgeInsets.symmetric(horizontal: 4.0),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     margin: EdgeInsets.symmetric(horizontal: 4.0),
  //                     child: IconTheme(
  //                       data: IconThemeData(color: Colors.blue[400]),
  //                       child: IconButton(
  //                         highlightColor: Colors.transparent,
  //                         splashColor: Colors.transparent,
  //                         icon: Icon(
  //                           Icons.send,
  //                           color: Theme.of(context).primaryColorDark,
  //                         ),
  //                         onPressed: _estaEscribiendo
  //                             ? () => _enviar(_textController.text.trim())
  //                             : null,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ///Es la accion mas la animacion que realiza cuando se envian los mensajes, ademas de eso limpia el teclado
  // _enviar(String texto) {
  //   if (texto.length == 0) return;

  //   _textController.clear();
  //   _focusNode.requestFocus();

  //   final newMenssage = new MensajeChatWidget(
  //     mio: true,
  //     texto: texto,
  //     animationController: AnimationController(
  //         vsync: this, duration: Duration(milliseconds: 200)),
  //   );
  //   _mensajes.insert(0, newMenssage);
  //   newMenssage.animationController.forward();
  //   setState(() {
  //     _estaEscribiendo = false;
  //   });

  //   // this.servicioSocket.emit('grabarMensaje', {
  //   //   'de': this.servicioAutenticacion.usuarioServiciosActual.uid,
  //   //   'para': this.servicioChat.postulado.id,
  //   //   'mensaje': texto,
  //   //   'servicio': this.servicioChat.servicio
  //   // });
  // }

  // @override
  // void dispose() {
  //   for (MensajeChatWidget message in _mensajes) {
  //     message.animationController.dispose();
  //   }

  //   super.dispose();
  // }
}
