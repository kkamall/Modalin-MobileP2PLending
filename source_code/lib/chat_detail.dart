import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class Chat {
  String isi_chat = "";
  String id_user_penerima = "";
  String id_user_pengirim = "";

  Chat(
      {required this.isi_chat,
      required this.id_user_penerima,
      required this.id_user_pengirim});
  // Chat(this.nama, this.foto, this.lastChat, this.chat);
}

class ListChatModel {
  List<Chat> listChatModel = <Chat>[];
  ListChatModel({required this.listChatModel});
}

class ListChatCubit extends Cubit<ListChatModel> {
  ListChatCubit() : super(ListChatModel(listChatModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Chat> listChatModel = <Chat>[];
    for (var val in data) {
      var isi_chat = val[0];
      var id_user_penerima = (val[1]).toString();
      var id_user_pengirim = (val[2]).toString();
      listChatModel.add(Chat(
        isi_chat: isi_chat,
        id_user_penerima: id_user_penerima,
        id_user_pengirim: id_user_pengirim,
      ));
    }
    emit(ListChatModel(listChatModel: listChatModel));
  }

  void fetchData(id_user_penerima, id_user_pengirim) async {
    String urlHistoryChat = "http://127.0.0.1:8000/get_chat/";
    final response = await http.get(
        Uri.parse(urlHistoryChat + id_user_penerima + '/' + id_user_pengirim));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  ChatDetailState createState() {
    return ChatDetailState();
  }
}

class ChatDetailState extends State<ChatDetail> {
  String id_user_penerima = "";
  String id_user_pengirim = "";
  late Future<int> respPostAddChat;

  final TextEditingController _messageController = TextEditingController();
  final List<String?> messages = [];

  late Future<int> respPost; //201 artinya berhasil

  Future<int> insertChat(String message) async {
    print("Masuk");
    print(message);
    //data disimpan di body
    DateTime now = DateTime.now();
    String waktuTransaksi = now.toString();
    String add_chat = "http://127.0.0.1:8000/add_chat/";

    final response = await http.post(Uri.parse(add_chat),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"isi_chat": "$message",
      "tanggal_chat": "$now",
      "status": "Terkirim",
      "id_user_pengirim": $id_user_pengirim,
      "id_user_penerima": $id_user_penerima} """);

    return response.statusCode; //sukses kalau 201
  }

  void sendMessage([String? message]) {
    if (message != null && message.isNotEmpty) {
      messages.add(message);
    }
    respPostAddChat = insertChat(_messageController.text);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id_user_penerima = arguments['id_user_penerima'] as String;
    id_user_pengirim = arguments['id_user_pengirim'] as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListChatCubit>(
            create: (BuildContext context) => ListChatCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Detail',
          home: Scaffold(
            body: Stack(
              children: [
                BlocBuilder<ListChatCubit, ListChatModel>(
                  builder: (contextListChat, listChat) {
                    contextListChat
                        .read<ListChatCubit>()
                        .fetchData(id_user_penerima, id_user_pengirim);
                    return SingleChildScrollView(
                      child: Container(
                        width: 360,
                        height: 640,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 61, 38, 69),
                              Color.fromARGB(255, 0, 0, 0),
                            ],
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // start top bar?
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 8, 16, 16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("PESAN",
                                          style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w800)),
                                      IconButton(
                                          iconSize: 42,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/home');
                                          },
                                          icon: const Icon(Icons.home),
                                          color: Colors.white)
                                    ]),
                              ),
                              // end top bar
                              Expanded(
                                // padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                                child: ListView.builder(
                                  itemCount: listChat.listChatModel.length,
                                  itemBuilder: (context, index) {
                                    // return buildChatBubble(messages[index]!, true);
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          26, 0, 26, 0),
                                      child: Align(
                                        alignment: listChat.listChatModel[index]
                                                    .id_user_penerima ==
                                                id_user_penerima
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: listChat.listChatModel[index]
                                                        .id_user_penerima ==
                                                    id_user_penerima
                                                ? const Color.fromARGB(
                                                    255, 131, 33, 79)
                                                : const Color.fromARGB(
                                                    255, 218, 65, 103),
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(16),
                                              topRight:
                                                  const Radius.circular(16),
                                              bottomLeft: listChat
                                                          .listChatModel[index]
                                                          .id_user_penerima ==
                                                      id_user_penerima
                                                  ? const Radius.circular(16)
                                                  : const Radius.circular(0),
                                              bottomRight: listChat
                                                          .listChatModel[index]
                                                          .id_user_penerima ==
                                                      id_user_penerima
                                                  ? const Radius.circular(0)
                                                  : const Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            listChat
                                                .listChatModel[index].isi_chat,
                                            style: GoogleFonts.rubik(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 90,
                              )
                            ]),
                      ),
                    );
                  },
                ),
                // start text field
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 33, 79),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Ketik Pesan..',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  sendMessage(value);
                                  value = '';
                                });
                              },
                            ),
                          ),
                          // const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send_rounded),
                            onPressed: () {
                              setState(() {
                                sendMessage();
                              });
                            },
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // end text field
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildChatBubble(String message, bool isUser) {
  //   return Padding(
  //       padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
  //       child: Align(
  //         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           margin: const EdgeInsets.symmetric(vertical: 8),
  //           decoration: BoxDecoration(
  //             color: isUser
  //                 ? const Color.fromARGB(255, 131, 33, 79)
  //                 : const Color.fromARGB(255, 218, 65, 103),
  //             borderRadius: BorderRadius.only(
  //               topLeft: const Radius.circular(16),
  //               topRight: const Radius.circular(16),
  //               bottomLeft: isUser
  //                   ? const Radius.circular(16)
  //                   : const Radius.circular(0),
  //               bottomRight: isUser
  //                   ? const Radius.circular(0)
  //                   : const Radius.circular(16),
  //             ),
  //           ),
  //           child: Text(
  //             message,
  //             style: GoogleFonts.rubik(color: Colors.white),
  //           ),
  //         ),
  //       ),
  //       );
  // }
}
