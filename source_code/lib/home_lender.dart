import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

// class untuk menampung data user
class Pendanaan {
  String foto_profile = "";
  String nama_umkm = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";

  Pendanaan(
      {required this.foto_profile,
      required this.nama_umkm,
      required this.jumlah_pinjaman,
      required this.return_keuntungan,
      required this.lama_pinjaman});
}

class Pengembalian {
  String foto_profile = "";
  String nama_umkm = "";
  String keuntungan = "";

  Pengembalian(
      {required this.foto_profile,
      required this.nama_umkm,
      required this.keuntungan});
}

class ListPendanaanModel {
  List<Pendanaan> listPendanaanModel = <Pendanaan>[];
  String total_pengeluaran = "";
  ListPendanaanModel(
      {required this.listPendanaanModel, required this.total_pengeluaran});
}

class ListPengembalianModel {
  List<Pengembalian> listPengembalianModel = <Pengembalian>[];
  String total_keuntungan = "";
  ListPengembalianModel(
      {required this.listPengembalianModel, required this.total_keuntungan});
}

class ListPendanaanCubit extends Cubit<ListPendanaanModel> {
  ListPendanaanCubit()
      : super(
            ListPendanaanModel(listPendanaanModel: [], total_pengeluaran: ""));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pendanaan> listPendanaanModel = <Pendanaan>[];
    num total_pengeluaran_int = 0;
    num flag = 0;
    for (var val in data) {
      total_pengeluaran_int += val[2].toInt();
      if (flag < 3) {
        var foto_profile = val[0];
        var nama_umkm = val[1];
        var jumlah_pinjaman = (val[2] / 1000000).toString();
        var return_keuntungan = (val[3]).toString();
        var lama_pinjaman = (val[4]).toString();
        listPendanaanModel.add(Pendanaan(
            foto_profile: foto_profile,
            nama_umkm: nama_umkm,
            jumlah_pinjaman: jumlah_pinjaman,
            return_keuntungan: return_keuntungan,
            lama_pinjaman: lama_pinjaman));
        flag += 1;
      }
    }
    String total_pengeluaran = total_pengeluaran_int.toString();
    emit(ListPendanaanModel(
        listPendanaanModel: listPendanaanModel,
        total_pengeluaran: total_pengeluaran));
  }

  void fetchData(id_user) async {
    String urlHistoryPendanaan =
        "http://127.0.0.1:8000/history_pengeluaran_lender/";
    final response = await http.get(Uri.parse(urlHistoryPendanaan + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class ListPengembalianCubit extends Cubit<ListPengembalianModel> {
  ListPengembalianCubit()
      : super(ListPengembalianModel(
            listPengembalianModel: [], total_keuntungan: ""));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pengembalian> listPengembalianModel = <Pengembalian>[];
    num total_keuntungan_int = 0;
    num flag = 0;
    for (var val in data) {
      total_keuntungan_int += val[2].toInt() - val[3].toInt();
      if (flag < 3) {
        var foto_profile = val[0];
        var nama_umkm = val[1];
        var keuntungan = (val[2] - val[3]).toString();
        listPengembalianModel.add(Pengembalian(
            foto_profile: foto_profile,
            nama_umkm: nama_umkm,
            keuntungan: keuntungan));
        flag += 1;
      }
    }
    String total_keuntungan = total_keuntungan_int.toString();
    emit(ListPengembalianModel(
        listPengembalianModel: listPengembalianModel,
        total_keuntungan: total_keuntungan));
  }

  void fetchData(id_user) async {
    String urlHistoryPengembalian =
        "http://127.0.0.1:8000/history_pemasukan_lender/";
    final response =
        await http.get(Uri.parse(urlHistoryPengembalian + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

// class untuk menampung data user
class ProfileModel {
  String saldo_dana = "";

  ProfileModel({required this.saldo_dana});
}

class ProfileCubit extends Cubit<ProfileModel> {
  String url = "http://127.0.0.1:8000/get_user/";
  ProfileCubit() : super(ProfileModel(saldo_dana: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String saldo_dana = json['saldo_dana'].toString();
    emit(ProfileModel(saldo_dana: saldo_dana));
  }

  void fetchData(id_user) async {
    final response = await http.get(Uri.parse(url + id_user));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

// class untuk menampung data pengeluaran
class Pengeluaran {
  String nama = "";
  String foto = "";
  String jumlah = "";
  String retur = "";
  String waktu = "";

  Pengeluaran(this.nama, this.foto, this.jumlah, this.retur, this.waktu);
}

class Pemasukan {
  String nama = "";
  String foto = "";
  String jumlah = "";

  Pemasukan(
    this.nama,
    this.foto,
    this.jumlah,
  );
}

// class untuk menampung data video yg disukai
class HistoryVideo {
  String judul = "";
  String thumbnail = "";

  HistoryVideo(this.judul, this.thumbnail);
}

class _HomeState extends State<Home> {
  int flag = 0;
  String id_user = "";

  final TextEditingController _loanAmountController = TextEditingController();
  String jumlahUang = "";

  List<Pengeluaran> listPengeluaran = [
    Pengeluaran("RENOVIN", "formal.png", "Rp 5jt", "8%", "3 bln"),
    Pengeluaran("KOPIKIRAN", "formal.png", "Rp 10jt", "6%", "6 bln"),
    Pengeluaran("KOKITA", "formal.png", "Rp 7jt", "10%", "1 thn"),
    Pengeluaran("KOKITA", "formal.png", "Rp 7jt", "10%", "1 thn")
  ];

  List<Pemasukan> listPemasukan = [
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
  ];

  // list HistoryVideo
  List<HistoryVideo> listHistoryVideo = [
    HistoryVideo('Membuat Bata Merah', 'assets/images/thumbnail.png'),
    HistoryVideo('eSports Desa Kami', 'assets/images/thumbnail.png'),
    // LikedVideo('Update UMKM Kami', 'assets/images/thumbnail.png',
    //     'assets/images/formal.png'),
    // LikedVideo('Penerapan Teknologi', 'assets/images/thumbnail.png',
    //     'assets/images/formal.png'),
  ];

  void _submitForm() {
    jumlahUang = _loanAmountController.text;
  }

  @override
  Widget build(BuildContext context) {
    id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (BuildContext context) => ProfileCubit(),
          ),
          BlocProvider<ListPendanaanCubit>(
            create: (BuildContext context) => ListPendanaanCubit(),
          ),
          BlocProvider<ListPengembalianCubit>(
            create: (BuildContext context) => ListPengembalianCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'MODALIN',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                BlocBuilder<ProfileCubit, ProfileModel>(
                    builder: (contextProfile, profile) {
                  contextProfile.read<ProfileCubit>().fetchData(id_user);
                  return BlocBuilder<ListPendanaanCubit, ListPendanaanModel>(
                      builder: (contextListPendanaan, modelListPendanaan) {
                    contextListPendanaan
                        .read<ListPendanaanCubit>()
                        .fetchData(id_user);
                    return BlocBuilder<ListPengembalianCubit,
                            ListPengembalianModel>(
                        builder:
                            (contextListPengembalian, modelListPengembalian) {
                      contextListPengembalian
                          .read<ListPengembalianCubit>()
                          .fetchData(id_user);
                      return SingleChildScrollView(
                        child: Container(
                          width: 360,
                          height: 800,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3D2645), Color(0xFF000000)],
                              begin: Alignment
                                  .topCenter, //Define the gradient starting point
                              end: Alignment
                                  .bottomCenter, //Define the gradient ending point
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(26, 20, 26, 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("HOME",
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800)),
                                    Row(
                                      children: [
                                        IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/notifikasi',
                                                  arguments: id_user);
                                            },
                                            icon:
                                                const Icon(Icons.notifications),
                                            color: Colors.white),
                                        IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/profile_investor',
                                                  arguments: id_user);
                                            },
                                            icon: const Icon(Icons.person),
                                            color: Colors.white),
                                      ],
                                    ),
                                  ],
                                ),
                                // start saldo
                                Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 30,
                                        ),
                                        width: 240,
                                        height: 95,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 131, 33, 97),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Saldo Rp. ${profile.saldo_dana}",
                                              style: GoogleFonts.outfit(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Top Up",
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                                // title: Text("Edit Profil"),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        131,
                                                                        33,
                                                                        79),
                                                                content:
                                                                    SizedBox(
                                                                        width: double
                                                                            .maxFinite,
                                                                        height:
                                                                            128,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          // crossAxisAlignment:
                                                                          //     CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Top Up",
                                                                              style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text("Jumlah", style: GoogleFonts.rubik(fontWeight: FontWeight.w200, fontSize: 12, color: Colors.white)),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text("Rp", style: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                                                                        const SizedBox(width: 5),
                                                                                        SizedBox(
                                                                                          height: 32,
                                                                                          width: 196,
                                                                                          child: TextFormField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            inputFormatters: [
                                                                                              FilteringTextInputFormatter.digitsOnly,
                                                                                            ],
                                                                                            controller: _loanAmountController,
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Masukkan Jumlah!';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            style: GoogleFonts.rubik(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: const Color(0xFFFFFFFF),
                                                                                              fontSize: 14,
                                                                                            ),
                                                                                            decoration: InputDecoration(
                                                                                              border: OutlineInputBorder(
                                                                                                borderRadius: BorderRadius.circular(26),
                                                                                              ),
                                                                                              filled: true,
                                                                                              fillColor: const Color(0x7FF0EFF4),
                                                                                              labelText: '3.000.000',
                                                                                              labelStyle: GoogleFonts.rubik(
                                                                                                fontWeight: FontWeight.w200,
                                                                                                color: const Color(0xFFFFFFFF),
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                              contentPadding: const EdgeInsets.symmetric(
                                                                                                vertical: 25,
                                                                                                horizontal: 18,
                                                                                              ),
                                                                                              floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label animation
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        _submitForm();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator
                                                                            .pushNamed(
                                                                          context,
                                                                          '/pembayaran',
                                                                          arguments: {
                                                                            'id_user':
                                                                                int.parse(id_user),
                                                                            'jumlahUang':
                                                                                int.parse(jumlahUang),
                                                                          },
                                                                        );
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
                                                                              255,
                                                                              218,
                                                                              65,
                                                                              103))),
                                                                      child:
                                                                          Text(
                                                                        "Top Up",
                                                                        style: GoogleFonts.rubik(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.white),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .cancel_outlined),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          218,
                                                                          65,
                                                                          103)),
                                                                ]);
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 37,
                                                ),
                                                Container(
                                                  width: 2,
                                                  height: 35,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  width: 37,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Withdraw",
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                                // title: Text("Edit Profil"),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        131,
                                                                        33,
                                                                        79),
                                                                content:
                                                                    SizedBox(
                                                                        width: double
                                                                            .maxFinite,
                                                                        height:
                                                                            128,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          // crossAxisAlignment:
                                                                          //     CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Withdraw",
                                                                              style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text("Jumlah", style: GoogleFonts.rubik(fontWeight: FontWeight.w200, fontSize: 12, color: Colors.white)),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text("Rp", style: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                                                                        const SizedBox(width: 5),
                                                                                        SizedBox(
                                                                                          height: 32,
                                                                                          width: 196,
                                                                                          child: TextFormField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            inputFormatters: [
                                                                                              FilteringTextInputFormatter.digitsOnly,
                                                                                            ],
                                                                                            controller: _loanAmountController,
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Masukkan Jumlah!';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            style: GoogleFonts.rubik(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: const Color(0xFFFFFFFF),
                                                                                              fontSize: 14,
                                                                                            ),
                                                                                            decoration: InputDecoration(
                                                                                              border: OutlineInputBorder(
                                                                                                borderRadius: BorderRadius.circular(26),
                                                                                              ),
                                                                                              filled: true,
                                                                                              fillColor: const Color(0x7FF0EFF4),
                                                                                              labelText: '3.000.000',
                                                                                              labelStyle: GoogleFonts.rubik(
                                                                                                fontWeight: FontWeight.w200,
                                                                                                color: const Color(0xFFFFFFFF),
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                              contentPadding: const EdgeInsets.symmetric(
                                                                                                vertical: 25,
                                                                                                horizontal: 18,
                                                                                              ),
                                                                                              floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label animation
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        _submitForm();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator
                                                                            .pushNamed(
                                                                          context,
                                                                          '/withdraw',
                                                                          arguments: {
                                                                            'id_user':
                                                                                int.parse(id_user),
                                                                            'jumlahUang':
                                                                                int.parse(jumlahUang),
                                                                          },
                                                                        );
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
                                                                              255,
                                                                              218,
                                                                              65,
                                                                              103))),
                                                                      child:
                                                                          Text(
                                                                        "Withdraw",
                                                                        style: GoogleFonts.rubik(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.white),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .cancel_outlined),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          218,
                                                                          65,
                                                                          103)),
                                                                ]);
                                                          },
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.wallet_rounded,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // end saldo
                                // start button select
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 24, 0, 0),
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
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  flag = 0;
                                                });
                                              },
                                              child: const Text(
                                                  "Riwayat Transaksi"),
                                            ),
                                            flag == 0
                                                ? Container(
                                                    height: 4,
                                                    width: 80,
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
                                                    height: 4,
                                                    width: 80,
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
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  flag = 1;
                                                });
                                              },
                                              child:
                                                  const Text("Riwayat Video"),
                                            ),
                                            flag == 1
                                                ? Container(
                                                    height: 4,
                                                    width: 80,
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
                                                    height: 4,
                                                    width: 80,
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
                                  ),
                                ),
                                // end button select
                                // start pengeluaran
                                flag == 0
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 24, 0, 0),
                                            child: Container(
                                              width: 308,
                                              height: 190,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                        Color.fromARGB(
                                                            65, 218, 65, 103),
                                                        Color.fromARGB(
                                                            65, 61, 38, 69)
                                                      ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 14, 18, 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "PENGELUARAN",
                                                          style: GoogleFonts
                                                              .outfit(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        if (modelListPendanaan
                                                                .listPendanaanModel
                                                                .length >
                                                            0) ...{
                                                          Text(
                                                            "Rp ${modelListPendanaan.total_pengeluaran}",
                                                            style: GoogleFonts.outfit(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        }
                                                      ],
                                                    ),
                                                    modelListPendanaan
                                                                .listPendanaanModel
                                                                .length ==
                                                            0
                                                        ? Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                "Nampaknya kamu belum memiliki pengeluaran",
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text("Investasi",
                                                                  style: GoogleFonts.outfit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200)),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    modelListPendanaan
                                                                        .listPendanaanModel
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              6,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                                child: SizedBox(
                                                                                    width: 24,
                                                                                    height: 24,
                                                                                    child: ClipOval(
                                                                                      child: Image.asset(
                                                                                        'assets/images/${modelListPendanaan.listPendanaanModel[index].foto_profile}',
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 9,
                                                                              ),
                                                                              Text(
                                                                                "${modelListPendanaan.listPendanaanModel[index].nama_umkm}",
                                                                                style: GoogleFonts.rubik(
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                6,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              "Rp ${modelListPendanaan.listPendanaanModel[index].jumlah_pinjaman}Jt | ${modelListPendanaan.listPendanaanModel[index].return_keuntungan}% | ${modelListPendanaan.listPendanaanModel[index].lama_pinjaman} bln",
                                                                              style: GoogleFonts.rubik(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w100,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ));
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              if (modelListPendanaan
                                                                      .listPendanaanModel
                                                                      .length >
                                                                  3) ...{
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child: Text(
                                                                    "Lihat Lainnya",
                                                                    style: GoogleFonts.outfit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              }
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // end pengeluaran
                                          //start pemasukan
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 24, 0, 0),
                                            child: Container(
                                              width: 308,
                                              height: 190,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                        Color.fromARGB(
                                                            65, 13, 133, 201),
                                                        Color.fromARGB(
                                                            65, 61, 38, 69)
                                                      ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 14, 18, 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "PEMASUKAN",
                                                          style: GoogleFonts
                                                              .outfit(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        if (modelListPengembalian
                                                                .listPengembalianModel
                                                                .length >
                                                            0) ...{
                                                          Text(
                                                            "Rp ${modelListPengembalian.total_keuntungan}",
                                                            style: GoogleFonts.outfit(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        }
                                                      ],
                                                    ),
                                                    modelListPengembalian
                                                                .listPengembalianModel
                                                                .length ==
                                                            0
                                                        ? Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                "Nampaknya kamu belum menyelesaikan transaksi",
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                  "Untung dari Investasi",
                                                                  style: GoogleFonts.outfit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200)),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    modelListPengembalian
                                                                        .listPengembalianModel
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              6,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                                child: SizedBox(
                                                                                    width: 24,
                                                                                    height: 24,
                                                                                    child: ClipOval(
                                                                                      child: Image.asset(
                                                                                        'assets/images/${modelListPengembalian.listPengembalianModel[index].foto_profile}',
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 9,
                                                                              ),
                                                                              Text(
                                                                                listPemasukan[index].nama,
                                                                                style: GoogleFonts.rubik(
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                6,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              "Rp ${modelListPengembalian.listPengembalianModel[index].keuntungan}",
                                                                              style: GoogleFonts.rubik(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w100,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ));
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              if (modelListPengembalian
                                                                      .listPengembalianModel
                                                                      .length >
                                                                  3) ...{
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child: Text(
                                                                      "Lihat Lainnya",
                                                                      style: GoogleFonts.outfit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                )
                                                              }
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listHistoryVideo.length,
                                        itemBuilder:
                                            (contextListHistoryVideo, index) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Image.asset(
                                                      '${listHistoryVideo[index].thumbnail}',
                                                      width: 153,
                                                      height: 86,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "${listHistoryVideo[index].judul}",
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Rp 5jt | 10% | 3 bln",
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "716K ditonton",
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "219 disukai",
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                //end pemasukan
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
                }),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child:
                      //box bawah
                      Container(
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
                          iconSize: 24,
                          onPressed: () {
                            Navigator.pushNamed(context, '/explore');
                          },
                          icon: const Icon(Icons.explore_rounded),
                          color: Colors.white,
                        ),
                        Stack(
                          children: [
                            IconButton(
                              iconSize: 24,
                              onPressed: () {},
                              icon: const Icon(Icons.home),
                              color: Colors.white,
                            ),
                            Positioned(
                              top: 33,
                              right: 10,
                              left: 10,
                              bottom: 3,
                              child: Container(
                                width: 20,
                                height: 4,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat',
                                arguments: id_user);
                          },
                          icon: const Icon(Icons.mark_chat_unread),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: Stack(
              children: [
                Positioned(
                  bottom: 45,
                  right: 0,
                  child: Container(
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
          ),
        ),
      ),
    );
  }
}
