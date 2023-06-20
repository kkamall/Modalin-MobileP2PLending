import 'package:flutter/material.dart';
// import 'package:tugas_besar/data.dart';
// import 'package:tugas_besar/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Pinjaman {
  String foto_profile = "";
  String nama = "";
  String judul_pinjaman = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";
  String link_vidio = "";
  String nama_umkm = "";
  String saldo_dana = "";
  String role = "";
  String id_pinjaman = "";
  String id_borrower = "";
  String tanggal_pinjaman = "";
  String kategori = "";
  String kelas = "";

  Pinjaman({
    required this.foto_profile,
    required this.nama,
    required this.judul_pinjaman,
    required this.jumlah_pinjaman,
    required this.return_keuntungan,
    required this.lama_pinjaman,
    required this.link_vidio,
    required this.nama_umkm,
    required this.saldo_dana,
    required this.role,
    required this.id_pinjaman,
    required this.id_borrower,
    required this.tanggal_pinjaman,
    required this.kategori,
    required this.kelas,
  });
}

class ListPinjamanModel {
  List<Pinjaman> listPinjamanModel = <Pinjaman>[];
  ListPinjamanModel({required this.listPinjamanModel});
}

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);
  @override
  ExploreState createState() {
    return ExploreState();
  }
}

class ListPinjamanCubit extends Cubit<ListPinjamanModel> {
  ListPinjamanCubit() : super(ListPinjamanModel(listPinjamanModel: []));

  static Future<String> formatDateTime(String dateTimeString) async {
    DateTime dateTime = DateTime.parse(dateTimeString);

    await initializeDateFormatting('id_ID', null);

    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }

  void setFromJson(Map<String, dynamic> json, String id_user) async {
    var data = json["data"];
    List<Pinjaman> listPinjamanModel = <Pinjaman>[];
    num flag = 0;
    Map<String, dynamic> jsonGetUser = {};

    // GET ID USER
    if (id_user != "0") {
      String urlGetUser = "http://127.0.0.1:8000/get_user/";
      final responseGetUser = await http.get(Uri.parse(urlGetUser + id_user));
      jsonGetUser = jsonDecode(responseGetUser.body);
    }

    for (var val in data) {
      var foto_profile = val[0];
      var nama = val[1];
      var judul_pinjaman = val[2];
      var jumlah_pinjaman = (val[3] / 1000000).toString();
      var return_keuntungan = (val[4]).toString();
      var lama_pinjaman = (val[5]).toString();
      var link_vidio = val[6];

      Uri uri = Uri.parse(link_vidio);
      String? videoId = uri.queryParameters['v'];
      link_vidio = videoId;

      var nama_umkm = val[7];
      var id_pinjaman = val[9].toString();
      var id_borrower = val[10].toString();
      var dateTimeTanggalPengajuan = val[11];
      String tanggal_pinjaman = await formatDateTime(
          dateTimeTanggalPengajuan); // Panggil sebagai method statis

      var kategori = val[12];
      var kelas = val[13];
      var saldo_dana = "0";
      var role = "Guest";
      if (id_user != "0") {
        saldo_dana = jsonGetUser['saldo_dana'].toString();
        role = jsonGetUser['role'];
      }
      listPinjamanModel.add(Pinjaman(
        foto_profile: foto_profile,
        nama: nama,
        judul_pinjaman: judul_pinjaman,
        jumlah_pinjaman: jumlah_pinjaman,
        return_keuntungan: return_keuntungan,
        lama_pinjaman: lama_pinjaman,
        link_vidio: link_vidio,
        nama_umkm: nama_umkm,
        saldo_dana: saldo_dana,
        role: role,
        id_pinjaman: id_pinjaman,
        id_borrower: id_borrower,
        tanggal_pinjaman: tanggal_pinjaman,
        kategori: kategori,
        kelas: kelas,
      ));
    }
    emit(ListPinjamanModel(listPinjamanModel: listPinjamanModel));
  }

  void fetchData(id_user, cari_umkm) async {
    String urlListPinjaman = "";
    if (cari_umkm != "") {
      urlListPinjaman = "http://127.0.0.1:8000/cari_umkm/" + cari_umkm;
    } else {
      urlListPinjaman = "http://127.0.0.1:8000/list_pinjaman/";
    }
    final response = await http.get(Uri.parse(urlListPinjaman));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body), id_user);
    } else {
      throw Exception('Gagal load');
    }
  }
}

class Video {
  String judul = "";
  String nama = "";
  String foto = "";
  String thumbnail = "";
  String durasi = "";
  String jumlah = "";
  String retur = "";
  String waktu = "";

  Video(this.judul, this.nama, this.foto, this.thumbnail, this.jumlah,
      this.retur, this.waktu, this.durasi);
}

class ExploreState extends State<Explore> {
  String id_user = "";
  String cari_umkm = "";
  final TextEditingController _cariUmkmController = TextEditingController();

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
            BlocProvider<ListPinjamanCubit>(
              create: (BuildContext context) => ListPinjamanCubit(),
            ),
          ],
          child: MaterialApp(
            title: 'Explore',
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: BlocBuilder<ListPinjamanCubit, ListPinjamanModel>(
                  builder: (contextListPinjaman, listPinjaman) {
                contextListPinjaman
                    .read<ListPinjamanCubit>()
                    .fetchData(id_user, cari_umkm);
                return Stack(children: [
                  SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 640),
                      // height: 640, // TODO
                      width: 360,
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
                        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // start header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("EXPLORE",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  children: [
                                    IconButton(
                                        iconSize: 30,
                                        onPressed: () {
                                          if (id_user == "0") {
                                            Navigator.pushNamed(
                                                context, '/notifikasi_guest');
                                          } else {
                                            Navigator.pushNamed(
                                                context, '/notifikasi',
                                                arguments: id_user);
                                          }
                                        },
                                        icon: const Icon(Icons.notifications),
                                        color: Colors.white),
                                    IconButton(
                                        iconSize: 30,
                                        onPressed: () {
                                          if (id_user == "0") {
                                            Navigator.pushNamed(
                                                context, '/profile_guest');
                                          } else {
                                            checkUserProfile();
                                          }
                                        },
                                        icon: const Icon(Icons.person),
                                        color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                            // end header
                            const SizedBox(
                              height: 12,
                            ),
                            // start search box
                            Container(
                              width: 450,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 158, 154, 157),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cariUmkmController,
                                      style: GoogleFonts.rubik(
                                          color: Colors.white),
                                      decoration: InputDecoration(
                                          hintText: 'Cari UMKM',
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 12)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    iconSize: 24,
                                    onPressed: () {
                                      cari_umkm = _cariUmkmController.text;
                                    },
                                    icon: const Icon(Icons.search),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            // end search box
                            const SizedBox(
                              height: 12,
                            ),
                            const SizedBox(height: 16),
                            // listView Builder Video
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    listPinjaman.listPinjamanModel.length,
                                itemBuilder: (contextListVideo, index) {
                                  return
                                    // start thumbnail video
                                      Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/detail_video',
                                                arguments: {
                                                  'nama_umkm': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .nama_umkm,
                                                  'judul_pinjaman': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .judul_pinjaman,
                                                  'nama_borrower': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .nama,
                                                  'jumlah_pinjaman':
                                                      listPinjaman
                                                          .listPinjamanModel[
                                                              index]
                                                          .jumlah_pinjaman,
                                                  'return_keuntungan':
                                                      listPinjaman
                                                          .listPinjamanModel[
                                                              index]
                                                          .return_keuntungan,
                                                  'lama_pinjaman': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .lama_pinjaman,
                                                  'foto_profile': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .foto_profile,
                                                  'saldo_dana': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .saldo_dana,
                                                  'id_pinjaman': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .id_pinjaman,
                                                  'id_user': id_user,
                                                  'id_borrower': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .id_borrower,
                                                  'role': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .role,
                                                  'link_vidio': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .link_vidio,
                                                  'tanggal_pinjaman':
                                                      listPinjaman
                                                          .listPinjamanModel[
                                                              index]
                                                          .tanggal_pinjaman,
                                                  'kategori': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .kategori,
                                                  'kelas': listPinjaman
                                                      .listPinjamanModel[index]
                                                      .kelas,
                                                });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color(0x3fffffff),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 320,
                                                  height: 174,
                                                  // thumbnail video
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      topRight:
                                                          Radius.circular(16),
                                                    ),
                                                    color: Color(0xffd9d9d9),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/images/thumbnail.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        12, 142, 12, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        // durasi video
                                                        // Container(
                                                        //   decoration:
                                                        //       const BoxDecoration(
                                                        //     color: Color(
                                                        //         0x7f000000),
                                                        //   ),
                                                        //   height: 16,
                                                        //   child: Text(
                                                        //     listVideo[index]
                                                        //         .durasi,
                                                        //     textAlign: TextAlign
                                                        //         .center,
                                                        //     style: GoogleFonts
                                                        //         .rubik(
                                                        //       fontSize: 12,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w400,
                                                        //       height: 1,
                                                        //       color: const Color(
                                                        //           0xffffffff),
                                                        //     ),
                                                        //   ),
                                                        // ),

                                                        // detail return
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0x7f000000),
                                                          ),
                                                          height: 16,
                                                          child: Text(
                                                            'Rp ${listPinjaman.listPinjamanModel[index].jumlah_pinjaman} jt | ${listPinjaman.listPinjamanModel[index].return_keuntungan}% | ${listPinjaman.listPinjamanModel[index].lama_pinjaman} bln',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .rubik(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1,
                                                              color: const Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 13, 12),
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // foto profil
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    12,
                                                                    0),
                                                            width: 32,
                                                            height: 32,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'assets/images/${listPinjaman.listPinjamanModel[index].foto_profile}',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // untuk title
                                                          Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        250),
                                                            child: Text(
                                                              "${listPinjaman.listPinjamanModel[index].nama_umkm} - ${listPinjaman.listPinjamanModel[index].judul_pinjaman}",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                44, 0, 0, 0),
                                                        child: Text(
                                                          listPinjaman
                                                              .listPinjamanModel[
                                                                  index]
                                                              .nama,
                                                          style:
                                                              GoogleFonts.rubik(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: const Color(
                                                                0xffffffff),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                  // end thumbnail video
                                }),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                                icon: const Icon(Icons.explore_rounded),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          IconButton(
                            iconSize: 24,
                            onPressed: () {
                              if (id_user != "0") {
                                checkUser();
                              } else {
                                Navigator.pushNamed(
                                    context, '/aktivitas_guest');
                              }
                            },
                            icon: const Icon(Icons.home),
                            color: Colors.white,
                          ),
                          IconButton(
                            iconSize: 24,
                            onPressed: () {
                              if (id_user == "0") {
                                Navigator.pushNamed(context, '/chat_guest');
                              } else {
                                Navigator.pushNamed(context, '/chat',
                                    arguments: id_user);
                              }
                            },
                            icon: const Icon(Icons.mark_chat_unread),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                  // end bottom nav
                ]);
              }),
              floatingActionButton:
                  // start floating button
                  Stack(
                children: [
                  Positioned(
                    bottom: 45,
                    right: 0,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: FloatingActionButton(
                        onPressed: () {
                          // jika ditap
                        },
                        backgroundColor: const Color(0xFFDA4167),
                        child: const Icon(Icons.headset_mic),
                      ),
                    ),
                  )
                ],
              ),
              // end floating button
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          )),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String nama_umkm = "";
  String judul_pinjaman = "";
  String nama_borrower = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";
  String foto_profile = "";
  String saldo_dana = "";
  String id_user = "";
  String id_pinjaman = "";
  String id_borrower = "";
  String role = "";
  String link_vidio = "";
  String tanggal_pinjaman = "";
  String kategori = "";
  String kelas = "";

// list objek Video
  List<Video> listVideo = [
    Video("RENOVIN - UMKM Yang Bergerak di Bidang Properti", "Mas Maman",
        "formal.png", "thumbnail.png", "Rp 5jt", "10%", "3 bln", "10:00"),
    Video("Alur Cerita GTA Dalam 20 menit", "Asep Gaming", "formal.png",
        "thumbnail.png", "Rp 5jt", "10%", "3 bln", "2:00"),
    Video("STOIKISME - Wifi Kosan Bintang", "BTG TV", "formal.png",
        "thumbnail.png", "Rp 5jt", "10%", "3 bln", "48:59"),
  ];

  late Future<int> respPost; //201 artinya berhasil
  String transaksi_modalin = "http://127.0.0.1:8000/transaksi_modalin/";
  String get_user = "http://127.0.0.1:8000/get_user/";
  String add_pendanaan = "http://127.0.0.1:8000/add_pendanaan/";
  String get_last_transaksi = "http://127.0.0.1:8000/getLastTransaksi/";
  String get_last_investasi = "http://127.0.0.1:8000/getLastInvestasi/";
  String modalin = "http://127.0.0.1:8000/modalin/";

  Future<int> insertPendanaan(int jumlahUang, int id_borrower) async {
    print("Masuk Pak Budi");

    //data disimpan di body
    DateTime now = DateTime.now();
    String waktuTransaksi = now.toString();

    final response = await http.post(
        Uri.parse(
            transaksi_modalin + id_pinjaman + '/' + (id_borrower).toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"jumlah_transaksi": $jumlahUang,
      "waktu_transaksi": "$now",
      "id_user": $id_user} """);

    // GET LAST TRANSAKSI
    final responseGetLastTransaksi =
        await http.get(Uri.parse(get_last_transaksi + id_user.toString()));
    int id_transaksi = jsonDecode(responseGetLastTransaksi.body);

    final responseModalin = await http.post(Uri.parse(modalin),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"tanggal_investasi": "$now",
      "id_pinjaman": $id_pinjaman,
      "id_user_lender": $id_user} """);

    // GET LAST INVESTASI
    final responseGetLastInvestasi =
        await http.get(Uri.parse(get_last_investasi + id_user.toString()));
    int id_investasi = jsonDecode(responseGetLastInvestasi.body);

    final responsePendanaan = await http.post(Uri.parse(add_pendanaan),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"id_investasi": $id_investasi,
      "id_transaksi": $id_transaksi,
      "id_user_lender": $id_user,
      "id_user_borrower": $id_borrower} """);

    Navigator.pushNamed(context, '/home', arguments: id_user);

    return response.statusCode; //sukses kalau 201
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    nama_umkm = arguments['nama_umkm'] as String;
    judul_pinjaman = arguments['judul_pinjaman'] as String;
    nama_borrower = arguments['nama_borrower'] as String;
    jumlah_pinjaman = arguments['jumlah_pinjaman'] as String;
    return_keuntungan = arguments['return_keuntungan'] as String;
    lama_pinjaman = arguments['lama_pinjaman'] as String;
    foto_profile = arguments['foto_profile'] as String;
    saldo_dana = arguments['saldo_dana'] as String;
    id_user = arguments['id_user'] as String;
    id_pinjaman = arguments['id_pinjaman'] as String;
    id_borrower = arguments['id_borrower'] as String;
    role = arguments['role'] as String;
    link_vidio = arguments['link_vidio'] as String;
    tanggal_pinjaman = arguments['tanggal_pinjaman'] as String;
    kategori = arguments['kategori'] as String;
    kelas = arguments['kelas'] as String;

    // controller video youtube
    YoutubePlayerController? _videoController = YoutubePlayerController(
        initialVideoId: link_vidio,
        flags: const YoutubePlayerFlags(autoPlay: true, isLive: false));

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListPinjamanCubit>(
            create: (BuildContext context) => ListPinjamanCubit(),
          ),
        ],
        child: MaterialApp(
          home: YoutubePlayerBuilder(
              player: YoutubePlayer(
                  controller: _videoController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor:
                      const Color.fromARGB(255, 131, 33, 79),
                  progressColors: const ProgressBarColors(
                    playedColor: Color.fromARGB(255, 131, 33, 79),
                    handleColor: Color.fromARGB(255, 222, 11, 110),
                  )),
              builder: (contextYoutubePlayer, player) {
                return Scaffold(
                  body: BlocBuilder<ListPinjamanCubit, ListPinjamanModel>(
                      builder: (contextListPinjaman, listPinjaman) {
                    contextListPinjaman
                        .read<ListPinjamanCubit>()
                        .fetchData(id_user, "");
                    return Stack(
                      children: [
                        SingleChildScrollView(
                            child: Container(
                          width: 360,
                          constraints: const BoxConstraints(minHeight: 640),
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
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        // video disini
                                        SizedBox(
                                            width: 360,
                                            height: 204,
                                            child: player
                                            // Container(
                                            //   decoration: const BoxDecoration(
                                            //     color: Color(0xffd9d9d9),
                                            //     image: DecorationImage(
                                            //       fit: BoxFit.cover,
                                            //       image: AssetImage(
                                            //           'assets/images/thumbnail.png'),
                                            //     ),
                                            //   ),
                                            // ),
                                            ),
                                        // tombol back ke home
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/explore',
                                                    arguments: id_user);
                                              },
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              color: const Color(0xffffffff),
                                            )),
                                      ],
                                    ),
                                  ),
                                  // container kategori, data user dan video, komen
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 6, 20, 0),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // bubble kategori
                                        SizedBox(
                                          height: 24,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffffffff)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  '$kategori',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffffffff)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  '$kelas',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // judul video
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 10, 10, 10),
                                          constraints: const BoxConstraints(
                                            maxWidth: 265,
                                          ),
                                          child: Text(
                                            '$nama_umkm - $judul_pinjaman',
                                            style: GoogleFonts.rubik(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        // views dan tanggal
                                        Text(
                                          '$tanggal_pinjaman',
                                          style: GoogleFonts.rubik(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // data user, rating dan chat button
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              8, 5, 8, 11),
                                          width: double.infinity,
                                          height: 32,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // foto dan nama user
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/$foto_profile',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  // nama user
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      nama_borrower,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // rating dan chat button
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  if (role == "Lender") ...{
                                                    // chat button (belum ada gesture detector)
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/chat_detail',
                                                          arguments: {
                                                            'id_user_penerima':
                                                                id_borrower,
                                                            'id_user_pengirim':
                                                                id_user
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xffda4167),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(17),
                                                        ),
                                                        child: Center(
                                                          child: Center(
                                                            child: Text(
                                                              'Chat',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 12,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  }
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 12, 20, 104),
                                    child: // listView Builder Video
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: listPinjaman
                                                .listPinjamanModel.length,
                                            itemBuilder:
                                                (contextListVideo, index) {
                                              return // start thumbnail video
                                                  Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (listPinjaman
                                                          .listPinjamanModel[
                                                              index]
                                                          .judul_pinjaman !=
                                                      judul_pinjaman) ...{
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/detail_video',
                                                            arguments: {
                                                              'nama_umkm':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .nama_umkm,
                                                              'judul_pinjaman':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .judul_pinjaman,
                                                              'nama_borrower':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .nama,
                                                              'jumlah_pinjaman':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .jumlah_pinjaman,
                                                              'return_keuntungan':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .return_keuntungan,
                                                              'lama_pinjaman':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .lama_pinjaman,
                                                              'foto_profile':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .foto_profile,
                                                              'saldo_dana':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .saldo_dana,
                                                              'id_pinjaman':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .id_pinjaman,
                                                              'id_user':
                                                                  id_user,
                                                              'id_borrower':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .id_borrower,
                                                              'role': listPinjaman
                                                                  .listPinjamanModel[
                                                                      index]
                                                                  .role,
                                                              'link_vidio':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .link_vidio,
                                                              'tanggal_pinjaman':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .tanggal_pinjaman,
                                                              'kategori':
                                                                  listPinjaman
                                                                      .listPinjamanModel[
                                                                          index]
                                                                      .kategori,
                                                              'kelas': listPinjaman
                                                                  .listPinjamanModel[
                                                                      index]
                                                                  .kelas,
                                                            });
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0x3fffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 320,
                                                              height: 174,
                                                              // thumbnail video
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          16),
                                                                ),
                                                                color: Color(
                                                                    0xffd9d9d9),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      AssetImage(
                                                                    'assets/images/thumbnail.png',
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        12,
                                                                        142,
                                                                        12,
                                                                        0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    // durasi video
                                                                    // Container(
                                                                    //   decoration:
                                                                    //       const BoxDecoration(
                                                                    //     color: Color(
                                                                    //         0x7f000000),
                                                                    //   ),
                                                                    //   height: 16,
                                                                    //   child: Text(
                                                                    //     listVideo[
                                                                    //             index]
                                                                    //         .durasi,
                                                                    //     textAlign:
                                                                    //         TextAlign
                                                                    //             .center,
                                                                    //     style:
                                                                    //         GoogleFonts
                                                                    //             .rubik(
                                                                    //       fontSize:
                                                                    //           12,
                                                                    //       fontWeight:
                                                                    //           FontWeight
                                                                    //               .w400,
                                                                    //       height: 1,
                                                                    //       color: const Color(
                                                                    //           0xffffffff),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),

                                                                    // detail return
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0x7f000000),
                                                                      ),
                                                                      height:
                                                                          16,
                                                                      child:
                                                                          Text(
                                                                        'Rp ${listPinjaman.listPinjamanModel[index].jumlah_pinjaman} jt | ${listPinjaman.listPinjamanModel[index].return_keuntungan}% | ${listPinjaman.listPinjamanModel[index].lama_pinjaman} bln',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .rubik(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          height:
                                                                              1,
                                                                          color:
                                                                              const Color(0xffffffff),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      10,
                                                                      13,
                                                                      12),
                                                              width: double
                                                                  .infinity,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // foto profil
                                                                      Container(
                                                                        margin: const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            12,
                                                                            0),
                                                                        width:
                                                                            32,
                                                                        height:
                                                                            32,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                AssetImage(
                                                                              'assets/images/${listPinjaman.listPinjamanModel[index].foto_profile}',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // untuk title
                                                                      Container(
                                                                        constraints:
                                                                            const BoxConstraints(maxWidth: 250),
                                                                        child:
                                                                            Text(
                                                                          "${listPinjaman.listPinjamanModel[index].nama_umkm} - ${listPinjaman.listPinjamanModel[index].judul_pinjaman}",
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            44,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      listPinjaman
                                                                          .listPinjamanModel[
                                                                              index]
                                                                          .nama,
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  },
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                              // end thumbnail video
                                            }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                        // start bottom nav
                        if (role == "Lender") ...{
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: 320,
                              height: 88,
                              decoration: BoxDecoration(
                                color: const Color(0xFF832161),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Modal Untuk $judul_pinjaman",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Rp $jumlah_pinjaman jt | $return_keuntungan% | $lama_pinjaman bln",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                        Row(
                                          children: [
                                            // pop up modalin
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                131,
                                                                33,
                                                                79),
                                                        content: int.parse(
                                                                    saldo_dana) <
                                                                int.parse(jumlah_pinjaman) *
                                                                        1000000 +
                                                                    2500
                                                            ? SizedBox(
                                                                child: Text(
                                                                  "Oops.. Saldo Anda Tidak Mencukupi :(",
                                                                  style: GoogleFonts.rubik(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                height: 270,
                                                                width: 308,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        "Modal Untuk $judul_pinjaman",
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w500)),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              32,
                                                                          height:
                                                                              32,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: AssetImage(
                                                                                'assets/images/$foto_profile',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                4),
                                                                        // nama user
                                                                        SizedBox(
                                                                          width:
                                                                              92,
                                                                          child:
                                                                              Text(
                                                                            nama_borrower,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0xffffffff),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Properti | Mikro',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Jumlah Pinjaman',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Rp ' +
                                                                              (int.parse(jumlah_pinjaman) * 1000000).toString(),
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Return Investasi',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '$return_keuntungan% = Rp ' +
                                                                              ((int.parse(jumlah_pinjaman) * 1000000) * int.parse(return_keuntungan) / 100).toString(),
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Waktu Pinjaman',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '$lama_pinjaman Bulan',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Biaya Aplikasi',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Rp 2.500',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Total',
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Rp ' +
                                                                              (int.parse(jumlah_pinjaman) * 1000000 + 2500).toString(),
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                      child: Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Saldo Anda',
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: const Color(0xffffffff),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Rp $saldo_dana',
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: const Color(0xffffffff),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Sisa Saldo',
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: const Color(0xffffffff),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Rp ' + (int.parse(saldo_dana) - int.parse(jumlah_pinjaman) * 1000000 - 2500).toString(),
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: const Color(0xffffffff),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                    )
                                                                  ],
                                                                )),
                                                        actions: [
                                                          int.parse(saldo_dana) <
                                                                  int.parse(jumlah_pinjaman) *
                                                                          1000000 +
                                                                      2500
                                                              ? const SizedBox()
                                                              : ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    insertPendanaan(
                                                                        int.parse(jumlah_pinjaman) *
                                                                                1000000 +
                                                                            2500,
                                                                        int.parse(
                                                                            id_borrower));
                                                                  },
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<
                                                                            Color>(
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          218,
                                                                          65,
                                                                          103),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "Modalin",
                                                                    style: GoogleFonts.rubik(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(Icons
                                                                .cancel_outlined),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                218,
                                                                65,
                                                                103),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffda4167),
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Modalin!',
                                                    style: GoogleFonts.rubik(
                                                      fontSize: 13,
                                                      color: const Color(
                                                          0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        }
                        // end bottom nav
                      ],
                    );
                  }),
                );
              }),
        ),
      ),
    );
  }
}
