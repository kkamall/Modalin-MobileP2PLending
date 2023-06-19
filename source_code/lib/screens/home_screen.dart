import 'package:flutter/material.dart';
// import 'package:tugas_besar/data.dart';
// import 'package:tugas_besar/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pinjaman> listPinjamanModel = <Pinjaman>[];
    num flag = 0;
    for (var val in data) {
      if (flag < 3) {
        var foto_profile = val[0];
        var nama = val[1];
        var judul_pinjaman = val[2];
        var jumlah_pinjaman = (val[3] / 1000000).toString();
        ;
        var return_keuntungan = (val[4]).toString();
        var lama_pinjaman = (val[5]).toString();
        var link_vidio = val[6];
        var nama_umkm = val[7];
        var saldo_dana = val[8].toString();
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
        ));
        flag += 1;
      } else {
        break;
      }
    }
    emit(ListPinjamanModel(listPinjamanModel: listPinjamanModel));
  }

  void fetchData() async {
    String urlListPinjaman = "http://127.0.0.1:8000/list_pinjaman/";
    final response = await http.get(Uri.parse(urlListPinjaman));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
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
  // list objek Video
  // List<Video> listVideo = [
  //   Video("RENOVIN - UMKM Yang Bergerak di Bidang Properti", "Mas Maman",
  //       "formal.png", "thumbnail.png", "Rp 5jt", "10%", "3 bln", "10:00"),
  //   Video("Alur Cerita GTA Dalam 20 menit", "Asep Gaming", "formal.png",
  //       "thumbnail.png", "Rp 5jt", "10%", "3 bln", "2:00"),
  //   Video("STOIKISME - Wifi Kosan Bintang", "BTG TV", "formal.png",
  //       "thumbnail.png", "Rp 5jt", "10%", "3 bln", "48:59"),
  // ];

  String id_user = "";

  Future<int> checkUser() async {
    String get_user = "http://127.0.0.1:8000/get_user/";
    String cek_pinjaman_belum_selesai =
        "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/";

    final responseUser = await http.get(Uri.parse(get_user + id_user));
    Map<String, dynamic> user = jsonDecode(responseUser.body);

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
                contextListPinjaman.read<ListPinjamanCubit>().fetchData();
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
                                        onPressed: () {},
                                        icon: const Icon(Icons.notifications),
                                        color: Colors.white),
                                    IconButton(
                                        iconSize: 30,
                                        onPressed: () {},
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
                                    onPressed: () {},
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
                            // start kategori lainnya
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kategori',
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Aksi ketika tombol 2 ditekan
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    // side: BorderSide(color: Colors.white, width: 2),
                                  ),
                                  child: Text(
                                    'Lainnya',
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xFFDA4167),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // end kategori lainnya
                            const SizedBox(height: 6),
                            // start bubble kategori
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 1 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Populer',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 2 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Pertanian',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 1 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Industri',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 2 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Kuliner',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // end bubble kategori
                            const SizedBox(height: 10),
                            Text(
                              'Kelas',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // start bubble kelas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 1 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Semua',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 2 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Menengah',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 1 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Kecil',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol 2 ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Mikro',
                                      style: GoogleFonts.rubik(
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // end bubble kelas
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
                              Navigator.pushNamed(context, '/chat_guest');
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

// list objek Video
  List<Video> listVideo = [
    Video("RENOVIN - UMKM Yang Bergerak di Bidang Properti", "Mas Maman",
        "formal.png", "thumbnail.png", "Rp 5jt", "10%", "3 bln", "10:00"),
    Video("Alur Cerita GTA Dalam 20 menit", "Asep Gaming", "formal.png",
        "thumbnail.png", "Rp 5jt", "10%", "3 bln", "2:00"),
    Video("STOIKISME - Wifi Kosan Bintang", "BTG TV", "formal.png",
        "thumbnail.png", "Rp 5jt", "10%", "3 bln", "48:59"),
  ];

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
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListPinjamanCubit>(
            create: (BuildContext context) => ListPinjamanCubit(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BlocBuilder<ListPinjamanCubit, ListPinjamanModel>(
                builder: (contextListPinjaman, listPinjaman) {
              contextListPinjaman.read<ListPinjamanCubit>().fetchData();
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
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffd9d9d9),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/thumbnail.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // tombol back ke home
                                  Positioned(
                                      left: 0,
                                      top: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.arrow_back),
                                        color: const Color(0xffffffff),
                                      )),
                                ],
                              ),
                            ),
                            // container kategori, data user dan video, komen
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // bubble kategori
                                  SizedBox(
                                    height: 24,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xffffffff)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Properti',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xffffffff)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Mikro',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffffffff),
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
                                    '716K ditonton • 3 hari yang lalu',
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
                                    margin:
                                        const EdgeInsets.fromLTRB(8, 5, 8, 11),
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
                                                    BorderRadius.circular(16),
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
                                                '$nama_borrower',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.rubik(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xffffffff),
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
                                            const Icon(
                                              Icons.star,
                                              color: Color(0xFFDA4167),
                                              size: 12.0,
                                            ),
                                            Text(
                                              '4.5',
                                              style: GoogleFonts.rubik(
                                                fontSize: 12,
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            // chat button (belum ada gesture detector)
                                            Container(
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffda4167),
                                                borderRadius:
                                                    BorderRadius.circular(17),
                                              ),
                                              child: Center(
                                                child: Center(
                                                  child: Text(
                                                    'Chat',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.rubik(
                                                      fontSize: 12,
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
                                    ),
                                  ),
                                  // komentar
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        11, 8, 12, 14),
                                    width: 308,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: const Color(0x7fd9d9d9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // autogroupm6hcwT4 (HT2yCyJiwgTTYHbeGXm6Hc)
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 0),
                                          height: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                child: Text(
                                                  'Komentar',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Anonim',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 2, 72, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                child: Text(
                                                  '32',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Keren banget ide nya🤩',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 12, 20, 104),
                              child: // listView Builder Video
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          listPinjaman.listPinjamanModel.length,
                                      itemBuilder: (contextListVideo, index) {
                                        return // start thumbnail video
                                            Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (listPinjaman
                                                    .listPinjamanModel[index]
                                                    .judul_pinjaman !=
                                                judul_pinjaman) ...{
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/detail_video',
                                                      arguments: {
                                                        'nama_umkm': listPinjaman
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
                                                      });
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x3fffffff),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
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
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                          ),
                                                          color:
                                                              Color(0xffd9d9d9),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
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
                                                                height: 16,
                                                                child: Text(
                                                                  'Rp ${listPinjaman.listPinjamanModel[index].jumlah_pinjaman} jt | ${listPinjaman.listPinjamanModel[index].return_keuntungan}% | ${listPinjaman.listPinjamanModel[index].lama_pinjaman} bln',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    fontSize:
                                                                        12,
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
                                                            const EdgeInsets
                                                                    .fromLTRB(
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
                                                                  margin: const EdgeInsets
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
                                                                        BorderRadius.circular(
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
                                                                      fontSize:
                                                                          12,
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
                                                                      44,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                listPinjaman
                                                                    .listPinjamanModel[
                                                                        index]
                                                                    .nama,
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
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
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 131, 33, 79),
                                                content: SizedBox(
                                                    height: 270,
                                                    width: 308,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "Modal Untuk $judul_pinjaman",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.rubik(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
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
                                                                    'assets/images/$foto_profile',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            // nama user
                                                            SizedBox(
                                                              width: 92,
                                                              child: Text(
                                                                nama_borrower,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Properti | Mikro',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Jumlah Pinjaman',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Rp ' +
                                                                  (int.parse(jumlah_pinjaman) *
                                                                          1000000)
                                                                      .toString(),
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Return Investasi',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$return_keuntungan% = Rp ' +
                                                                  ((int.parse(jumlah_pinjaman) *
                                                                              1000000) *
                                                                          int.parse(
                                                                              return_keuntungan) /
                                                                          100)
                                                                      .toString(),
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Waktu Pinjaman',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$lama_pinjaman Bulan',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Biaya Aplikasi',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Rp 2.500',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Total',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Rp ' +
                                                                  (int.parse(jumlah_pinjaman) * 1000000 +
                                                                          2500)
                                                                      .toString(),
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                          child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Saldo Anda',
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Rp $saldo_dana',
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Sisa Saldo',
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Rp ' +
                                                                          (int.parse(saldo_dana) - int.parse(jumlah_pinjaman) - 2500)
                                                                              .toString(),
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ]),
                                                        )
                                                      ],
                                                    )),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        const Color.fromARGB(
                                                            255, 218, 65, 103),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Modalin",
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel_outlined),
                                                    color: const Color.fromARGB(
                                                        255, 218, 65, 103),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffda4167),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Modalin!',
                                            style: GoogleFonts.rubik(
                                              fontSize: 13,
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),

                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 131, 33, 79),
                                                content: SizedBox(
                                                    height: 155,
                                                    width: 308,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "Modal Untuk $judul_pinjaman",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.rubik(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
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
                                                                    'assets/images/$foto_profile',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            // nama user
                                                            SizedBox(
                                                              width: 92,
                                                              child: Text(
                                                                nama_borrower,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Properti | Mikro',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Jumlah Pinjaman',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Rp ' + (int.parse(jumlah_pinjaman) * 1000000).toString(),
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  (Icons.lock),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Return Investasi',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '$return_keuntungan%',
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  (Icons.edit),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Waktu Pinjaman',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffffff),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '$lama_pinjaman Bulan',
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  (Icons.edit),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        const Color.fromARGB(
                                                            255, 218, 65, 103),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Nego",
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel_outlined),
                                                    color: const Color.fromARGB(
                                                        255, 218, 65, 103),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffda4167),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Nego',
                                            style: GoogleFonts.rubik(
                                              fontSize: 13,
                                              color: const Color(0xffffffff),
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
                  // end bottom nav
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
