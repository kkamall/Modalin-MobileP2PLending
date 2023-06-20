import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

// class untuk menampung data user
class ChatBelumTerbaca {
  String nama = "";
  String foto = "";
  String lastChat = "";
  String chat = "";
  String id_user_pengirim = "";
  String id_user_penerima = "";

  ChatBelumTerbaca({
    required this.nama,
    required this.foto,
    required this.lastChat,
    required this.chat,
    required this.id_user_pengirim,
    required this.id_user_penerima,
  });
  // Chat(this.nama, this.foto, this.lastChat, this.chat);
}

class ChatSemua {
  String nama = "";
  String foto = "";
  String lastChat = "";
  String id_user_pengirim = "";
  String id_user_penerima = "";

  ChatSemua(
      {required this.nama,
      required this.foto,
      required this.lastChat,
      required this.id_user_pengirim,
      required this.id_user_penerima});
  // Chat(this.nama, this.foto, this.lastChat, this.chat);
}

class ListChatBelumTerbacaModel {
  List<ChatBelumTerbaca> listChatBelumTerbacaModel = <ChatBelumTerbaca>[];
  ListChatBelumTerbacaModel({required this.listChatBelumTerbacaModel});
}

class ListChatSemuaModel {
  List<ChatSemua> listChatSemuaModel = <ChatSemua>[];
  ListChatSemuaModel({required this.listChatSemuaModel});
}

class ListChatBelumTerbacaCubit extends Cubit<ListChatBelumTerbacaModel> {
  ListChatBelumTerbacaCubit()
      : super(ListChatBelumTerbacaModel(listChatBelumTerbacaModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<ChatBelumTerbaca> listChatBelumTerbacaModel = <ChatBelumTerbaca>[];
    for (var val in data) {
      var nama = val[1];
      var foto = val[0];
      var lastChat = val[2];
      var chat = (val[4]).toString();
      var id_user_penerima = (val[5]).toString();
      var id_user_pengirim = (val[6]).toString();
      listChatBelumTerbacaModel.add(ChatBelumTerbaca(
          nama: nama,
          foto: foto,
          lastChat: lastChat,
          chat: chat,
          id_user_penerima: id_user_penerima,
          id_user_pengirim: id_user_pengirim));
    }
    emit(ListChatBelumTerbacaModel(
        listChatBelumTerbacaModel: listChatBelumTerbacaModel));
  }

  void fetchData(id_user) async {
    String urlHistoryChat = "http://127.0.0.1:8000/get_chat_belum_terbaca/";
    final response = await http.get(Uri.parse(urlHistoryChat + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class ListChatSemuaCubit extends Cubit<ListChatSemuaModel> {
  ListChatSemuaCubit() : super(ListChatSemuaModel(listChatSemuaModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<ChatSemua> listChatSemuaModel = <ChatSemua>[];
    for (var val in data) {
      var nama = val[1];
      var foto = val[0];
      var lastChat = val[2];
      var id_user_penerima = (val[4]).toString();
      var id_user_pengirim = (val[5]).toString();
      listChatSemuaModel.add(ChatSemua(
          nama: nama,
          foto: foto,
          lastChat: lastChat,
          id_user_pengirim: id_user_pengirim,
          id_user_penerima: id_user_penerima));
    }
    emit(ListChatSemuaModel(listChatSemuaModel: listChatSemuaModel));
  }

  void fetchData(id_user) async {
    String urlHistoryChat = "http://127.0.0.1:8000/get_chat_semua/";
    final response = await http.get(Uri.parse(urlHistoryChat + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class ChatNotif extends StatefulWidget {
  const ChatNotif({Key? key}) : super(key: key);

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<ChatNotif> {
  // list objek chat
  // List<Chat> listChat = [
  //   Chat("MAKAN2", "formal.png", "Jadi Bagaimana Pak?", "3"),
  //   Chat("RENOVIN", "formal.png", "Jadi Bagaimana Pak?", "1"),
  //   Chat("KOPIKIRAN", "formal.png", "Jadi Bagaimana Pak?", "0"),
  //   Chat("KOKITA", "formal.png", "Jadi Bagaimana Pak?", "0"),
  // ];

  // penanda buat list yang dpilih
  int flag = 0;
  String id_user = "";

  Future<int> updateChatTerbaca(
      String id_user_pengirim, String id_user_penerima) async {
    final responseUpdateChatTerbaca = await http.post(Uri.parse(
        "http://localhost:8000/update_chat_terbaca/" +
            id_user_pengirim +
            '/' +
            id_user_penerima));

    return responseUpdateChatTerbaca.statusCode; //sukses kalau 201
  }

  Future<int> checkUser() async {
    String get_user = "http://127.0.0.1:8000/get_user/";
    String cek_pinjaman_belum_selesai =
        "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/";

    final responseUser = await http.get(Uri.parse(get_user + id_user));
    Map<String, dynamic> user = jsonDecode(responseUser.body);

    if (id_user == "0") {
      Navigator.pushNamed(
        context,
        '/aktivitas_guest',
        arguments: id_user,
      );
    } else {
      // Cek pinjaman (udah mengajukan apa belum)
      final responseCekPinjamanBelumSelesai =
          await http.get(Uri.parse(cek_pinjaman_belum_selesai + id_user));
      List jsonCekPinjamanBelumSelesai =
          jsonDecode(responseCekPinjamanBelumSelesai.body);

      if (user['role'] == "Lender") {
        Navigator.pushNamed(
          context,
          '/home',
          arguments: id_user,
        );
      } else {
        if (jsonCekPinjamanBelumSelesai[0] == "Tidak Ada") {
          Navigator.pushNamed(context, '/home_borrower', arguments: id_user);
        } else if (jsonCekPinjamanBelumSelesai[0] == "Ada") {
          Navigator.pushNamed(
            context,
            '/home_borrower_dapat_pinjaman',
            arguments: {
              'id_user': id_user,
              'id_pinjaman': jsonCekPinjamanBelumSelesai[1].toString(),
            },
          );
        }
      }
    }

    return responseUser.statusCode;
  }

  Future<int> checkUserProfile() async {
    String get_user = "http://127.0.0.1:8000/get_user/";
    String cek_pinjaman_belum_selesai =
        "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/";

    final responseUser = await http.get(Uri.parse(get_user + id_user));
    Map<String, dynamic> user = jsonDecode(responseUser.body);

    if (id_user == "0") {
      Navigator.pushNamed(
        context,
        '/aktivitas_guest',
        arguments: id_user,
      );
    } else {
      if (user['role'] == "Lender") {
        Navigator.pushNamed(
          context,
          '/profile_investor',
          arguments: id_user,
        );
      } else {
        Navigator.pushNamed(
          context,
          '/profile_borrower',
          arguments: id_user,
        );
      }
    }

    return responseUser.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListChatBelumTerbacaCubit>(
            create: (BuildContext context) => ListChatBelumTerbacaCubit(),
          ),
          BlocProvider<ListChatSemuaCubit>(
            create: (BuildContext context) => ListChatSemuaCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MODALIN',
          home: Scaffold(
            body: Stack(
              children: [
                BlocBuilder<ListChatBelumTerbacaCubit,
                        ListChatBelumTerbacaModel>(
                    builder:
                        (contextListChatBelumTerbaca, listChatBelumTerbaca) {
                  contextListChatBelumTerbaca
                      .read<ListChatBelumTerbacaCubit>()
                      .fetchData(id_user);
                  return BlocBuilder<ListChatSemuaCubit, ListChatSemuaModel>(
                      builder: (contextListChatSemua, listChatSemua) {
                    contextListChatSemua
                        .read<ListChatSemuaCubit>()
                        .fetchData(id_user);
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
                                    const EdgeInsets.fromLTRB(20, 8, 20, 16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("PESAN",
                                          style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w800)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              iconSize: 38,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/notifikasi',
                                                    arguments: id_user);
                                              },
                                              icon: const Icon(
                                                  Icons.notifications),
                                              color: Colors.white),
                                          IconButton(
                                              iconSize: 38,
                                              onPressed: () {
                                                checkUserProfile();
                                              },
                                              icon: const Icon(Icons.person),
                                              color: Colors.white)
                                        ],
                                      ),
                                    ]),
                              ),
                              // end top bar
                              // start button filter chat
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                textStyle: GoogleFonts.outfit(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  flag = 0;
                                                });
                                              },
                                              child:
                                                  const Text("Belum Terbaca"),
                                            ),
                                            flag == 0
                                                ? Container(
                                                    height: 5,
                                                    width: 82,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              218,
                                                              65,
                                                              103),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 5,
                                                    width: 82,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              0, 218, 65, 103),
                                                    ))
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                textStyle: GoogleFonts.outfit(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  flag = 1;
                                                });
                                              },
                                              child: const Text("Semua"),
                                            ),
                                            flag == 1
                                                ? Container(
                                                    height: 5,
                                                    width: 82,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              218,
                                                              65,
                                                              103),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 5,
                                                    width: 82,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              0, 218, 65, 103),
                                                    ))
                                          ]),
                                    ],
                                  )),
                              // end button filter chat
                              flag == 1
                                  // start listview builder all chat
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: listChatSemua
                                          .listChatSemuaModel.length,
                                      itemBuilder: (contextListChat, index) {
                                        return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                updateChatTerbaca(
                                                    listChatSemua
                                                        .listChatSemuaModel[
                                                            index]
                                                        .id_user_pengirim,
                                                    listChatSemua
                                                        .listChatSemuaModel[
                                                            index]
                                                        .id_user_penerima);
                                                Navigator.pushNamed(
                                                  context,
                                                  '/chat_detail',
                                                  arguments: {
                                                    'id_user_penerima':
                                                        listChatSemua
                                                            .listChatSemuaModel[
                                                                index]
                                                            .id_user_penerima,
                                                    'id_user_pengirim':
                                                        listChatSemua
                                                            .listChatSemuaModel[
                                                                index]
                                                            .id_user_pengirim
                                                  },
                                                );

                                                // print('pressed');
                                              },
                                              child: Container(
                                                  width: 308,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 218, 65, 103),
                                                      )),
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          14, 0, 14, 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: SizedBox(
                                                                    width: 24,
                                                                    height: 24,
                                                                    child:
                                                                        ClipOval(
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/${listChatSemua.listChatSemuaModel[index].foto}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                listChatSemua
                                                                    .listChatSemuaModel[
                                                                        index]
                                                                    .nama,
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ))),
                                            ));
                                      })
                                  // end listview builder all chat
                                  // start listview builder unread chat
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: listChatBelumTerbaca
                                          .listChatBelumTerbacaModel.length,
                                      itemBuilder:
                                          (contextListChatBelumTerbaca, index) {
                                        return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                updateChatTerbaca(
                                                    listChatBelumTerbaca
                                                        .listChatBelumTerbacaModel[
                                                            index]
                                                        .id_user_penerima,
                                                    listChatBelumTerbaca
                                                        .listChatBelumTerbacaModel[
                                                            index]
                                                        .id_user_pengirim);
                                                Navigator.pushNamed(
                                                  context,
                                                  '/chat_detail',
                                                  arguments: {
                                                    'id_user_penerima':
                                                        listChatBelumTerbaca
                                                            .listChatBelumTerbacaModel[
                                                                index]
                                                            .id_user_pengirim,
                                                    'id_user_pengirim':
                                                        listChatBelumTerbaca
                                                            .listChatBelumTerbacaModel[
                                                                index]
                                                            .id_user_penerima
                                                  },
                                                );
                                              },
                                              child: Container(
                                                  width: 308,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 218, 65, 103),
                                                      )),
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          14, 0, 14, 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: SizedBox(
                                                                    width: 24,
                                                                    height: 24,
                                                                    child:
                                                                        ClipOval(
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/${listChatBelumTerbaca.listChatBelumTerbacaModel[index].foto}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                listChatBelumTerbaca
                                                                    .listChatBelumTerbacaModel[
                                                                        index]
                                                                    .nama,
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    12,
                                                                    0,
                                                                    12,
                                                                    0),
                                                            child: Text(
                                                              listChatBelumTerbaca
                                                                  .listChatBelumTerbacaModel[
                                                                      index]
                                                                  .lastChat,
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      218,
                                                                      65,
                                                                      103)),
                                                              child: Text(
                                                                listChatBelumTerbaca
                                                                    .listChatBelumTerbacaModel[
                                                                        index]
                                                                    .chat
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100,
                                                                ),
                                                              ))
                                                        ],
                                                      ))),
                                            ));
                                      }),
                              // end listview builder unread chat
                            ]),
                      ),
                    );
                  });
                }),
                // start bottom nav
                Positioned(
                  bottom: 20,
                  left: 90,
                  child: Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF832161),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: 26,
                          onPressed: () {
                            Navigator.pushNamed(context, '/explore',
                                arguments: id_user);
                          },
                          icon: const Icon(Icons.explore_rounded),
                          color: Colors.white,
                        ),
                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            checkUser();
                          },
                          icon: const Icon(Icons.home),
                          color: Colors.white,
                        ),
                        Stack(
                          children: [
                            Positioned(
                              right: 10,
                              bottom: 3,
                              child: Container(
                                width: 20,
                                height: 4,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 24,
                              onPressed: () {},
                              icon: const Icon(Icons.mark_chat_unread),
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
                // end bottom nav
              ],
            ),
            floatingActionButton:
                // start floating button
                Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 218, 65, 103),
                child: const Icon(Icons.headset_mic),
              ),
            ),
            // end floating button
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }
}
