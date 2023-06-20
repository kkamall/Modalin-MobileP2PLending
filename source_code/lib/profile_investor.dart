import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// class untuk menampung data user
class Investasi {
  String foto_profile = "";
  String nama_umkm = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";

  Investasi(
      {required this.foto_profile,
      required this.nama_umkm,
      required this.jumlah_pinjaman,
      required this.return_keuntungan,
      required this.lama_pinjaman});
}

class ListInvestasiModel {
  List<Investasi> listInvestasiModel = <Investasi>[];
  ListInvestasiModel({required this.listInvestasiModel});
}

class ListInvestasiCubit extends Cubit<ListInvestasiModel> {
  ListInvestasiCubit() : super(ListInvestasiModel(listInvestasiModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Investasi> listInvestasiModel = <Investasi>[];

    for (var val in data) {
      var foto_profile = val[0];
      var nama_umkm = val[1];
      var jumlah_pinjaman = ((val[2] / 1000000).round()).toString();
      var return_keuntungan = (val[3]).toString();
      var lama_pinjaman = (val[4]).toString();
      listInvestasiModel.add(Investasi(
          foto_profile: foto_profile,
          nama_umkm: nama_umkm,
          jumlah_pinjaman: jumlah_pinjaman,
          return_keuntungan: return_keuntungan,
          lama_pinjaman: lama_pinjaman));
    }
    emit(ListInvestasiModel(listInvestasiModel: listInvestasiModel));
  }

  void fetchData(id_user) async {
    String urlListInvestasi = "http://127.0.0.1:8000/get_list_investasi/";
    final response = await http.get(Uri.parse(urlListInvestasi + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

// class untuk menampung data user
class ProfileModel {
  String nama = "";
  String email = "";
  String saldo_dana = "";
  String foto_profile = "";

  ProfileModel(
      {required this.nama,
      required this.email,
      required this.saldo_dana,
      required this.foto_profile});
}

class ProfileCubit extends Cubit<ProfileModel> {
  String url = "http://127.0.0.1:8000/get_user/";
  ProfileCubit()
      : super(ProfileModel(
            nama: "", email: "", saldo_dana: "", foto_profile: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String nama = json['nama'];
    String email = json['email'];
    String saldo_dana = json['saldo_dana'].toString();
    String foto_profile = json['foto_profile'];

    emit(ProfileModel(
        nama: nama,
        email: email,
        saldo_dana: saldo_dana,
        foto_profile: foto_profile));
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

// class untuk menampung data video yg disukai
class LikedVideo {
  String judul = "";
  String thumbnail = "";
  String profil = "";

  LikedVideo(this.judul, this.thumbnail, this.profil);
}

void main() {
  runApp(ProfileInvestor());
}

class ProfileInvestor extends StatefulWidget {
  const ProfileInvestor({Key? key}) : super(key: key);

  @override
  ProfileInvestorState createState() {
    return ProfileInvestorState();
  }
}

class ProfileInvestorState extends State<ProfileInvestor> {
  // bikin objek user
  // User user = User('Rifqi Fajar', 'rifqi.fajar@upi.edu', 'formal.png');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  String id_user = "";
  String nama = "";
  String jumlahUang = "";

  late Future<int> respPost; //201 artinya berhasil
  String updateProfile = "http://127.0.0.1:8000/update_profile/";

  Future<int> updateUser() async {
    //data disimpan di body
    final response = await http.patch(Uri.parse(updateProfile + id_user),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"nama": "$nama",
      "foto_profile": "kosong"} """);
    return response.statusCode; //sukses kalau 201
  }

  void _submitForm() {
    if (_nameController.text != "") {
      nama = _nameController.text;
    } else {
      nama = "kosong";
    }

    respPost = updateUser();
  }

  void _submitFormJumlahUang() {
    jumlahUang = _loanAmountController.text;
  }

  // penanda buat list yang dpilih
  int flag = 0;
  int flagAmbil = 0;

  String formatAngka(int angka) {
    final formatter = NumberFormat('#,###');
    return formatter.format(angka);
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
          BlocProvider<ListInvestasiCubit>(
            create: (BuildContext context) => ListInvestasiCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MODALIN',
          home: Scaffold(
              body: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(minHeight: 640),
              width: 360,
              // height: 640,
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
              child: BlocBuilder<ProfileCubit, ProfileModel>(
                builder: (contextProfile, profile) {
                  contextProfile.read<ProfileCubit>().fetchData(id_user);
                  return BlocBuilder<ListInvestasiCubit, ListInvestasiModel>(
                      builder: (contextListInvestasi, listInvestasi) {
                    contextListInvestasi
                        .read<ListInvestasiCubit>()
                        .fetchData(id_user);
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(26, 20, 26, 21),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("PROFIL",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700)),
                                  IconButton(
                                      iconSize: 40,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/home',
                                            arguments: id_user);
                                      },
                                      icon: const Icon(Icons.home),
                                      color: Colors.white)
                                ]),
                          ),
                          // profile data
                          Stack(
                            children: [
                              Container(
                                width: 308,
                                height: 76,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 131, 33, 97),
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              // buat nama sama email
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 14, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${profile.nama}",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "${profile.email}",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              // buat button edit profil
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 90, 0, 0),
                                child: ElevatedButton(
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
                                                    BorderRadius.circular(16)),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 131, 33, 79),
                                            content: SizedBox(
                                                width: double.maxFinite,
                                                height: 176,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  // crossAxisAlignment:
                                                  //     CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Edit Profil",
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          32, 16, 32, 16),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            iconSize: 24,
                                                            onPressed: () {},
                                                            icon: const Icon(Icons
                                                                .add_a_photo_rounded),
                                                            color: Colors.white,
                                                          ),
                                                          Container(
                                                              width: 90,
                                                              height: 90,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  border: Border.all(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          61,
                                                                          38,
                                                                          69),
                                                                      width:
                                                                          2)),
                                                              child: ClipOval(
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/${profile.foto_profile}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 32,
                                                      width: 224,
                                                      child: TextFormField(
                                                        controller:
                                                            _nameController,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Masukkan nama';
                                                          }
                                                          return null;
                                                        },
                                                        style:
                                                            GoogleFonts.rubik(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xFFFFFFFF),
                                                          fontSize: 14,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        26),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              const Color(
                                                                  0x7FF0EFF4),
                                                          labelText: 'Nama',
                                                          labelStyle:
                                                              GoogleFonts.rubik(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 13,
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 25,
                                                            horizontal: 18,
                                                          ),
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never, // Remove label animation
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 1),
                                                  ],
                                                )),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _submitForm();
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(const Color
                                                                  .fromARGB(255,
                                                              218, 65, 103))),
                                                  child: Text(
                                                    "Edit",
                                                    style: GoogleFonts.rubik(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                  color: const Color.fromARGB(
                                                      255, 218, 65, 103)),
                                            ]);
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 218, 65, 103),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17)),
                                    minimumSize: const Size(73, 28),
                                  ),
                                  child: Text(
                                    "Edit Profil",
                                    style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              // buat foto profil
                              Positioned(
                                top: 19,
                                left: 197,
                                child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 61, 38, 69),
                                            width: 8)),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/formal.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          // saldo dan top up
                          Stack(
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 30,
                                  ),
                                  width: 240,
                                  height: 95,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 131, 33, 97),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Saldo Rp. " +
                                            formatAngka(int.parse(
                                                    profile.saldo_dana))
                                                .toString(),
                                        style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Jumlah",
                                                                            style: GoogleFonts.rubik(
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 12,
                                                                                color: Colors.white)),
                                                                        Row(
                                                                          children: [
                                                                            Text("Rp",
                                                                                style: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
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
                                                              _submitFormJumlahUang();
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
                                                            style: ButtonStyle(
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
                                                                  fontSize: 13,
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
                                          SizedBox(
                                            width: 37,
                                          ),
                                          Container(
                                            width: 2,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 37,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Withdraw",
                                                style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Jumlah",
                                                                            style: GoogleFonts.rubik(
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 12,
                                                                                color: Colors.white)),
                                                                        Row(
                                                                          children: [
                                                                            Text("Rp",
                                                                                style: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
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
                                                              _submitFormJumlahUang();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                '/withdraw',
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
                                                            style: ButtonStyle(
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
                                                              "Withdraw",
                                                              style: GoogleFonts.rubik(
                                                                  fontSize: 13,
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
                                                    },
                                                  );
                                                },
                                                child: Icon(
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          textStyle: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            flag = 0;
                                          });
                                        },
                                        child: const Text("Investasi"),
                                      ),
                                      Container(
                                        height: 4,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              255, 218, 65, 103),
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  listInvestasi.listInvestasiModel.length,
                              itemBuilder: (context, index) {
                                return listInvestasi.listInvestasiModel.isEmpty
                                    ? Text(
                                        "Nampaknya anda belum melakukan investasi",
                                        style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            32, 0, 32, 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width: 23,
                                                    height: 22,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                61,
                                                                38,
                                                                69),
                                                            width: 2)),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'images/${listInvestasi.listInvestasiModel[index].foto_profile}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                                Container(
                                                  width: 130,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18),
                                                  child: Text(
                                                    "${listInvestasi.listInvestasiModel[index].nama_umkm}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.outfit(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              "Rp ${listInvestasi.listInvestasiModel[index].jumlah_pinjaman} jt | ${listInvestasi.listInvestasiModel[index].return_keuntungan}% | ${listInvestasi.listInvestasiModel[index].lama_pinjaman} bln",
                                              style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      );
                              }),
                          const SizedBox(height: 14),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                "Logout",
                                style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ))
                        ]);
                  });
                },
              ),
            ),
          )),
        ),
      ),
    );
  }
}
