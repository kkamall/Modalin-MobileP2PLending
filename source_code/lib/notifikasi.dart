import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// class untuk menampung data user
class ChatBelumTerbaca {
  String nama = "";
  String foto = "";
  String isi_chat = "";
  String id_user_pengirim = "";
  String id_user_penerima = "";
  String tanggal_chat = "";

  ChatBelumTerbaca({
    required this.nama,
    required this.foto,
    required this.isi_chat,
    required this.id_user_pengirim,
    required this.id_user_penerima,
    required this.tanggal_chat,
  });
  // Chat(this.nama, this.foto, this.lastChat, this.chat);
}

class ListChatBelumTerbacaModel {
  List<ChatBelumTerbaca> listChatBelumTerbacaModel = <ChatBelumTerbaca>[];
  ListChatBelumTerbacaModel({required this.listChatBelumTerbacaModel});
}

class ListChatBelumTerbacaCubit extends Cubit<ListChatBelumTerbacaModel> {
  Future<String> formatDateTime(String dateTimeString) async {
    initializeDateFormatting();

    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat.yMMMMd('id_ID').format(dateTime);
    String formattedTime = DateFormat.Hm('id_ID').format(dateTime);

    String formattedDateTime = '$formattedDate $formattedTime';

    return formattedDateTime;
  }

  ListChatBelumTerbacaCubit()
      : super(ListChatBelumTerbacaModel(listChatBelumTerbacaModel: []));

  void setFromJson(Map<String, dynamic> json) async {
    var data = json["data"];
    List<ChatBelumTerbaca> listChatBelumTerbacaModel = <ChatBelumTerbaca>[];
    for (var val in data) {
      var nama = val[1];
      var foto = val[0];
      var isi_chat = val[2];
      var id_user_penerima = (val[5]).toString();
      var id_user_pengirim = (val[6]).toString();
      var dateTimeTanggalChat = val[7];

      String tanggal_chat = await formatDateTime(
          dateTimeTanggalChat); // Panggil sebagai method statis

      listChatBelumTerbacaModel.add(ChatBelumTerbaca(
        nama: nama,
        foto: foto,
        isi_chat: isi_chat,
        id_user_penerima: id_user_penerima,
        id_user_pengirim: id_user_pengirim,
        tanggal_chat: tanggal_chat,
      ));
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

class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);
  @override
  NotifikasiState createState() {
    return NotifikasiState();
  }
}

class NotifikasiItem {
  int jenis = 0; // 0 chat 1 video
  String nama = "";
  String foto = "";
  String isi = "";
  int waktu = 0; // 0 hari ini, 1 minggu ini

  NotifikasiItem(this.jenis, this.foto, this.nama, this.isi, this.waktu);
}

class NotifikasiState extends State<Notifikasi> {
  String id_user = "";

  List<NotifikasiItem> dataNotif = [
    NotifikasiItem(0, "formal.png", "RENOVIN", "Jadi gimana pak?", 0),
    NotifikasiItem(1, "thumbnail.png", "RENOVIN",
        "UMKM yang bergerak di bidang properti", 0),
    NotifikasiItem(1, "thumbnail.png", "Thorfinn",
        "Membuka ladang baru di tempat Ketil", 1),
    NotifikasiItem(
        1, "thumbnail.png", "Earen", "Menanam bibit gandung di ladang baru", 1),
  ];

  Future<int> checkUser() async {
    final responseGetUser =
        await http.get(Uri.parse("http://127.0.0.1:8000/get_user/" + id_user));
    Map<String, dynamic> jsonGetUser = jsonDecode(responseGetUser.body);

    final responseCekPinjamanBelumSelesai = await http.get(Uri.parse(
        "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/" + id_user));
    List jsonCekPinjamanBelumSelesai =
        jsonDecode(responseCekPinjamanBelumSelesai.body);

    if (responseGetUser.statusCode == 200) {
      if (jsonGetUser['role'] == "Borrower") {
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
      } else {
        Navigator.pushNamed(context, '/home', arguments: id_user);
      }
    } else {
      throw Exception('Gagal load');
    }
    return responseGetUser.statusCode;
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
        ],
        child: MaterialApp(
          title: 'Hello App',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: BlocBuilder<ListChatBelumTerbacaCubit,
                    ListChatBelumTerbacaModel>(
                builder: (contextListChatBelumTerbaca, listChatBelumTerbaca) {
              contextListChatBelumTerbaca
                  .read<ListChatBelumTerbacaCubit>()
                  .fetchData(id_user);
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D2645),
                      Color(0xFF000000)
                    ], // Replace with your desired colors
                    begin: Alignment
                        .topCenter, // Define the gradient starting point
                    end: Alignment
                        .bottomCenter, // Define the gradient ending point
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(26, 20, 26, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("NOTIFIKASI",
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700)),
                          Row(
                            children: [
                              IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    checkUser();
                                  },
                                  icon: const Icon(Icons.home),
                                  color: Colors.white)
                            ],
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: listChatBelumTerbaca
                            .listChatBelumTerbacaModel.length,
                        itemBuilder: (context, index) {
                          return dataNotif[index].waktu == 0
                              ? Card(
                                  child: ListTile(
                                    title: Row(children: [
                                      Text(
                                        "Pesan Baru: ",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          listChatBelumTerbaca
                                              .listChatBelumTerbacaModel[index]
                                              .isi_chat,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          listChatBelumTerbaca
                                              .listChatBelumTerbacaModel[index]
                                              .nama,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          listChatBelumTerbaca
                                              .listChatBelumTerbacaModel[index]
                                              .tanggal_chat,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/${listChatBelumTerbaca.listChatBelumTerbacaModel[index].foto}',
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    tileColor: const Color(0xFF3D2645),
                                    onTap: () {},
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
