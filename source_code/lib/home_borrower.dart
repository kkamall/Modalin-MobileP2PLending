import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

// class untuk menampung data user
class Pengembalian {
  String foto_profile = "";
  String nama_umkm = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";

  Pengembalian(
      {required this.foto_profile,
      required this.nama_umkm,
      required this.jumlah_pinjaman,
      required this.return_keuntungan,
      required this.lama_pinjaman});
}

class ListPengembalianModel {
  List<Pengembalian> listPengembalianModel = <Pengembalian>[];
  ListPengembalianModel({required this.listPengembalianModel});
}

class ListPengembalianCubit extends Cubit<ListPengembalianModel> {
  ListPengembalianCubit()
      : super(ListPengembalianModel(listPengembalianModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pengembalian> listPengembalianModel = <Pengembalian>[];
    num flag = 0;
    for (var val in data) {
      if (flag < 3) {
        var foto_profile = val[0];
        var nama_umkm = val[1];
        var jumlah_pinjaman = (val[3] / 1000000).toString();
        var return_keuntungan = (val[4]).toString();
        var lama_pinjaman = (val[5]).toString();
        listPengembalianModel.add(Pengembalian(
            foto_profile: foto_profile,
            nama_umkm: nama_umkm,
            jumlah_pinjaman: jumlah_pinjaman,
            return_keuntungan: return_keuntungan,
            lama_pinjaman: lama_pinjaman));
        flag += 1;
      } else {
        break;
      }
    }
    emit(ListPengembalianModel(listPengembalianModel: listPengembalianModel));
  }

  void fetchData(id_user) async {
    String urlHistoryPengembalian =
        "http://127.0.0.1:8000/history_pengembalian_borrower/";
    final response =
        await http.get(Uri.parse(urlHistoryPengembalian + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class SaldoModel {
  String saldo_dana;
  SaldoModel({required this.saldo_dana});
}

class SaldoCubit extends Cubit<SaldoModel> {
  String url = "http://127.0.0.1:8000/get_user/";
  SaldoCubit() : super(SaldoModel(saldo_dana: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String saldo_dana = json['saldo_dana'].toString();
    emit(SaldoModel(saldo_dana: saldo_dana));
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

class HomeBorrower extends StatefulWidget {
  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
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

class _HomeBorrowerState extends State<HomeBorrower> {
  int flag = 0;
  String id_user = "";

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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _returnPercentageController =
      TextEditingController();
  final TextEditingController _loanDurationController = TextEditingController();
  String jumlahUang = "";

  String judul_pinjaman = "";
  String link_vidio = "";
  int jumlah_pinjaman = 0;
  int return_keuntungan = 0;
  int lama_pinjaman = 0;
  int id_umkm = 0;
  String id_pinjaman = "";
  DateTime? tanggal_pengajuan;

  late Future<int> respPostAddPinjaman; //201 artinya berhasil
  late Future<int> respGetIdPinjaman;
  String addPinjaman = "http://127.0.0.1:8000/add_pinjaman/";
  String get_umkm = "http://127.0.0.1:8000/get_umkm/";

  // Menambakan data pinjaman
  Future<int> insertDataPinjaman() async {
    //data disimpan di body
    final responseIdUmkm = await http.get(Uri.parse(get_umkm + id_user));
    Map<String, dynamic> json = jsonDecode(responseIdUmkm.body);
    id_umkm = json['id_umkm'];

    final response = await http.post(Uri.parse(addPinjaman),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"judul_pinjaman": "$judul_pinjaman",
      "link_vidio": "$link_vidio",
      "jumlah_pinjaman": $jumlah_pinjaman,
      "return_keuntungan": $return_keuntungan,
      "lama_pinjaman": $lama_pinjaman,
      "status": "Belum",
      "tanggal_pengajuan": "$tanggal_pengajuan",
      "id_umkm": "$id_umkm",
      "id_user_borrower": $id_user}""");

    return response.statusCode; //sukses kalau 201
  }

  Future<int> getIdPinjaman() async {
    // Mendapatkan id pinjaman yang terakhir
    String url = "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/" + id_user;
    print(url);
    final responseIdPinjaman = await http.get(Uri.parse(
        "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/" + id_user));
    List hasilResponseIdPinjaman = jsonDecode(responseIdPinjaman.body);
    id_pinjaman = hasilResponseIdPinjaman[1].toString();

    return responseIdPinjaman.statusCode; //sukses kalau 201
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _loanAmountController.dispose();
    _returnPercentageController.dispose();
    _loanDurationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    jumlahUang = _loanAmountController.text;
  }

  void _submitFormAddPinjaman() {
    judul_pinjaman = _titleController.text;
    link_vidio = _linkController.text;
    jumlah_pinjaman = int.parse(_loanAmountController.text);
    return_keuntungan = int.parse(_returnPercentageController.text);
    lama_pinjaman = int.parse(_loanDurationController.text);
    tanggal_pengajuan = DateTime.now();

    respPostAddPinjaman = insertDataPinjaman();
    respGetIdPinjaman = getIdPinjaman();
  }

  @override
  Widget build(BuildContext context) {
    id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SaldoCubit>(
            create: (BuildContext context) => SaldoCubit(),
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
                SingleChildScrollView(
                  child: Container(
                    width: 360,
                    height: 640,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3D2645), Color(0xFF000000)],
                        begin: Alignment
                            .topCenter, //Define the gradient starting point
                        end: Alignment
                            .bottomCenter, //Define the gradient ending point
                      ),
                    ),
                    child: BlocBuilder<SaldoCubit, SaldoModel>(
                        builder: (contextProfile, profile) {
                      contextProfile.read<SaldoCubit>().fetchData(id_user);
                      return BlocBuilder<ListPengembalianCubit,
                              ListPengembalianModel>(
                          builder: (contextPengembalian, pengembalian) {
                        contextPengembalian
                            .read<ListPengembalianCubit>()
                            .fetchData(id_user);
                        return Container(
                          margin: const EdgeInsets.fromLTRB(26, 20, 26, 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "HOME",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/notifikasi');
                                          },
                                          icon: const Icon(Icons.notifications),
                                          color: Colors.white),
                                      IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/profile_borrower',
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
                                        borderRadius: BorderRadius.circular(13),
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
                                                            content: SizedBox(
                                                                width: double
                                                                    .maxFinite,
                                                                height: 128,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  // crossAxisAlignment:
                                                                  //     CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "Top Up",
                                                                      style: GoogleFonts.rubik(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Jumlah",
                                                                                style: GoogleFonts.rubik(fontWeight: FontWeight.w200, fontSize: 12, color: Colors.white)),
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
                                                                onPressed: () {
                                                                  _submitForm();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/pembayaran',
                                                                    arguments: {
                                                                      'id_user':
                                                                          int.parse(
                                                                              id_user),
                                                                      'jumlahUang':
                                                                          int.parse(
                                                                              jumlahUang),
                                                                    },
                                                                  );
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
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
                                                                  "Top Up",
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
                                                                icon: const Icon(
                                                                    Icons
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
                                                decoration: const BoxDecoration(
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
                                                              content: SizedBox(
                                                                  width: double
                                                                      .maxFinite,
                                                                  height: 128,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    // crossAxisAlignment:
                                                                    //     CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "Withdraw",
                                                                        style: GoogleFonts.rubik(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.white),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                      Navigator.of(
                                                                              context)
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
                                                                        backgroundColor: MaterialStateProperty.all<
                                                                            Color>(const Color
                                                                                .fromARGB(
                                                                            255,
                                                                            218,
                                                                            65,
                                                                            103))),
                                                                    child: Text(
                                                                      "Withdraw",
                                                                      style: GoogleFonts.rubik(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
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
                              // start status pinjaman
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Status Pinjaman",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 14),
                                            Container(
                                              width: 280,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                "Nampaknya kamu belum mengajukan pinjaman",
                                                style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      height: 32,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF832161),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  // title: Text("Edit Profil"),
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
                                                      width: double.maxFinite,
                                                      height: 293,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "Pengajuan Pinjaman",
                                                            style: GoogleFonts.rubik(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Judul Video",
                                                                  style: GoogleFonts.rubik(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white)),
                                                              SizedBox(
                                                                height: 32,
                                                                width: 224,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _titleController,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Masukkan Judul!';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                        0xFFFFFFFF),
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              26),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        const Color(
                                                                            0x7FF0EFF4),
                                                                    labelText:
                                                                        'Membuka Lahan Baru',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .rubik(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      color: const Color(
                                                                          0xFFFFFFFF),
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          25,
                                                                      horizontal:
                                                                          18,
                                                                    ),
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .never, // Remove label animation
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Link Video",
                                                                      style: GoogleFonts.rubik(
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white)),
                                                                  SizedBox(
                                                                    height: 32,
                                                                    width: 224,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _linkController,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'Masukkan Link Video!';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: const Color(
                                                                            0xFFFFFFFF),
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(26),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            const Color(0x7FF0EFF4),
                                                                        labelText:
                                                                            'link youtube',
                                                                        labelStyle:
                                                                            GoogleFonts.rubik(
                                                                          fontWeight:
                                                                              FontWeight.w200,
                                                                          color:
                                                                              const Color(0xFFFFFFFF),
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                        contentPadding:
                                                                            const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              25,
                                                                          horizontal:
                                                                              18,
                                                                        ),
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.never, // Remove label animation
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Jumlah Pinjaman",
                                                                      style: GoogleFonts.rubik(
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white)),
                                                                  Row(
                                                                    children: [
                                                                      Text("Rp",
                                                                          style: GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                              color: Colors.white)),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      SizedBox(
                                                                        height:
                                                                            32,
                                                                        width:
                                                                            196,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                          ],
                                                                          controller:
                                                                              _loanAmountController,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Masukkan Jumlah!';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xFFFFFFFF),
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(26),
                                                                            ),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                const Color(0x7FF0EFF4),
                                                                            labelText:
                                                                                '3.000.000',
                                                                            labelStyle:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w200,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 13,
                                                                            ),
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(
                                                                              vertical: 25,
                                                                              horizontal: 18,
                                                                            ),
                                                                            floatingLabelBehavior:
                                                                                FloatingLabelBehavior.never, // Remove label animation
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Persentase Return",
                                                                      style: GoogleFonts.rubik(
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white)),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            32,
                                                                        width:
                                                                            128,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                          ],
                                                                          controller:
                                                                              _returnPercentageController,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Masukkan Persentase!';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xFFFFFFFF),
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(26),
                                                                            ),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                const Color(0x7FF0EFF4),
                                                                            labelText:
                                                                                '10',
                                                                            labelStyle:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w200,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 13,
                                                                            ),
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(
                                                                              vertical: 25,
                                                                              horizontal: 18,
                                                                            ),
                                                                            floatingLabelBehavior:
                                                                                FloatingLabelBehavior.never, // Remove label animation
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text("%",
                                                                          style: GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                              color: Colors.white)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Lama Pinjaman",
                                                                      style: GoogleFonts.rubik(
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white)),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            32,
                                                                        width:
                                                                            128,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                          ],
                                                                          controller:
                                                                              _loanDurationController,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Masukkan Lama Pinjaman!';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style:
                                                                              GoogleFonts.rubik(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xFFFFFFFF),
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(26),
                                                                            ),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                const Color(0x7FF0EFF4),
                                                                            labelText:
                                                                                '6',
                                                                            labelStyle:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w200,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 13,
                                                                            ),
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(
                                                                              vertical: 25,
                                                                              horizontal: 18,
                                                                            ),
                                                                            floatingLabelBehavior:
                                                                                FloatingLabelBehavior.never, // Remove label animation
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                          "Bulan",
                                                                          style: GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                              color: Colors.white)),
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
                                                        onPressed: () {
                                                          _submitFormAddPinjaman();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/home_borrower_dapat_pinjaman',
                                                            arguments: {
                                                              'id_user':
                                                                  id_user,
                                                              'id_pinjaman':
                                                                  id_pinjaman,
                                                            },
                                                          );
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                        Color>(
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        218,
                                                                        65,
                                                                        103))),
                                                        child: Text(
                                                          "Ajukan",
                                                          style:
                                                              GoogleFonts.rubik(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        icon: const Icon(Icons
                                                            .cancel_outlined),
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 218, 65, 103)),
                                                  ]);
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Ajukan Sekarang!',
                                          style: GoogleFonts.rubik(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // end status pinjaman
                              // start pengeluaran
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                child: Container(
                                  width: 308,
                                  height: 190,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(65, 218, 65, 103),
                                            Color.fromARGB(65, 61, 38, 69)
                                          ])),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(18, 14, 18, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   "RIWAYAT TRANSAKSI",
                                        //   style: GoogleFonts.outfit(
                                        //       color: Colors.white,
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.w700),
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "RIWAYAT TRANSAKSI",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        pengembalian.listPengembalianModel
                                                    .length ==
                                                0
                                            ? Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "Nampaknya kamu belum menyelesaikan transaksi",
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Pinjaman",
                                                    style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: pengembalian
                                                        .listPengembalianModel
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 22,
                                                                      height:
                                                                          22,
                                                                      child:
                                                                          ClipOval(
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/${pengembalian.listPengembalianModel[index].foto_profile}',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 9,
                                                                  ),
                                                                  Text(
                                                                    "${pengembalian.listPengembalianModel[index].nama_umkm}",
                                                                    style: GoogleFonts
                                                                        .rubik(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        6,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  "Rp ${pengembalian.listPengembalianModel[index].jumlah_pinjaman}Jt | ${pengembalian.listPengembalianModel[index].return_keuntungan}% | ${pengembalian.listPengembalianModel[index].lama_pinjaman} bln",
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  if (pengembalian
                                                          .listPengembalianModel
                                                          .length >
                                                      3) ...{
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "Lihat Lainnya",
                                                          style:
                                                              GoogleFonts.rubik(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                    )
                                                  }
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // end riwayat transaksi
                            ],
                          ),
                        );
                      });
                    }),
                  ),
                ),
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
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
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
                            Navigator.pushNamed(context, '/chat');
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
