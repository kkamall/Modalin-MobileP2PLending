import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

// void main() {
//   runApp(const ProfileBorrower());
// }

class ProfileModel {
  String nama;
  String email;
  String saldo_dana;
  String foto_profile;
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

class UmkmModel {
  String nama_umkm;
  String deskripsi;
  String tahun_berdiri;
  String omset;
  String lokasi;
  String kategori;
  String kelas;
  UmkmModel(
      {required this.nama_umkm,
      required this.deskripsi,
      required this.tahun_berdiri,
      required this.omset,
      required this.lokasi,
      required this.kategori,
      required this.kelas});
}

class UmkmCubit extends Cubit<UmkmModel> {
  String url = "http://127.0.0.1:8000/get_umkm/";
  UmkmCubit()
      : super(UmkmModel(
            nama_umkm: "",
            deskripsi: "",
            tahun_berdiri: "",
            omset: "",
            lokasi: "",
            kategori: "",
            kelas: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String nama_umkm = json['nama_umkm'];
    String deskripsi = json['deskripsi'];
    String tahun_berdiri = json['tahun_berdiri'].toString();
    String omset = json['omset'].toString();
    String lokasi = json['lokasi'];
    String kategori = json['kategori'];
    String kelas = json['kelas'];
    emit(UmkmModel(
        nama_umkm: nama_umkm,
        deskripsi: deskripsi,
        lokasi: lokasi,
        tahun_berdiri: tahun_berdiri,
        omset: omset,
        kategori: kategori,
        kelas: kelas));
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

class ProfileBorrower extends StatefulWidget {
  const ProfileBorrower({Key? key}) : super(key: key);

  @override
  ProfileBorrowerState createState() {
    return ProfileBorrowerState();
  }
}

class ProfileBorrowerState extends State<ProfileBorrower> {
  // penanda buat list yang dpilih
  int flag = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _umkmController = TextEditingController();
  final TextEditingController _tahunBerdiriController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _omsetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
        home: MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
        ),
        BlocProvider<UmkmCubit>(
          create: (BuildContext context) => UmkmCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MODALIN - Profile Borrower',
        home: Scaffold(
          body: SingleChildScrollView(
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
              child: BlocBuilder<ProfileCubit, ProfileModel>(
                builder: (contextProfile, profile) {
                  contextProfile.read<ProfileCubit>().fetchData(id_user);
                  return BlocBuilder<UmkmCubit, UmkmModel>(
                    builder: (contextUmkm, umkm) {
                      contextUmkm.read<UmkmCubit>().fetchData(id_user);
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
                                        Navigator.pushNamed(
                                            context, '/home_borrower',
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
                                                        initialValue:
                                                            profile.nama,
                                                        // controller:
                                                        //     _nameController,
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
                                        "Saldo Rp. ${profile.saldo_dana}",
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
                                                  print('Icon pressed');
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
                                                  print('Icon pressed');
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
                                        child: const Text("UMKM"),
                                      ),
                                      flag == 0
                                          ? Container(
                                              height: 4,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromARGB(
                                                    255, 218, 65, 103),
                                              ),
                                            )
                                          : Container(
                                              height: 4,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromARGB(
                                                    0, 218, 65, 103),
                                              ))
                                    ]),
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
                                            flag = 1;
                                          });
                                        },
                                        child: const Text("Video"),
                                      ),
                                      flag == 1
                                          ? Container(
                                              height: 4,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromARGB(
                                                    255, 218, 65, 103),
                                              ),
                                            )
                                          : Container(
                                              height: 4,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromARGB(
                                                    0, 218, 65, 103),
                                              ))
                                    ]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Expanded(
                            child: Container(
                              margin: flag == 0
                                  ? EdgeInsets.symmetric(horizontal: 55.0)
                                  : EdgeInsets.symmetric(horizontal: 28.0),
                              child: flag == 0
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${umkm.nama_umkm}",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
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
                                                            borderRadius: BorderRadius
                                                                .circular(16)),
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
                                                            height: 318,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              // crossAxisAlignment:
                                                              //     CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "Edit Data UMKM",
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
                                                                    Text(
                                                                        "Nama UMKM",
                                                                        style: GoogleFonts.rubik(
                                                                            fontWeight: FontWeight
                                                                                .w200,
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white)),
                                                                    SizedBox(
                                                                      height:
                                                                          32,
                                                                      width:
                                                                          224,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _umkmController,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Masukkan Nama UMKM!';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: GoogleFonts
                                                                            .rubik(
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(26),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              const Color(0x7FF0EFF4),
                                                                          labelText:
                                                                              'Membuka Lahan Baru',
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
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Tahun Berdiri",
                                                                            style: GoogleFonts.rubik(
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 12,
                                                                                color: Colors.white)),
                                                                        SizedBox(
                                                                          height:
                                                                              32,
                                                                          width:
                                                                              224,
                                                                          child:
                                                                              TextFormField(
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            inputFormatters: [
                                                                              FilteringTextInputFormatter.digitsOnly,
                                                                            ],
                                                                            controller:
                                                                                _tahunBerdiriController,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Masukkan Tahun Berdiri!';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 14,
                                                                            ),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(26),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: const Color(0x7FF0EFF4),
                                                                              labelText: '2023',
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
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Lokasi UMKM",
                                                                            style: GoogleFonts.rubik(
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 12,
                                                                                color: Colors.white)),
                                                                        SizedBox(
                                                                          height:
                                                                              32,
                                                                          width:
                                                                              224,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _lokasiController,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Masukkan Lokasi UMKM!';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 14,
                                                                            ),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(26),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: const Color(0x7FF0EFF4),
                                                                              labelText: 'Bandung',
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
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Deskripsi",
                                                                            style: GoogleFonts.rubik(
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 12,
                                                                                color: Colors.white)),
                                                                        SizedBox(
                                                                          height:
                                                                              44,
                                                                          width:
                                                                              224,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _deskripsiController,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Masukkan Deskripsi UMKM!';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFFFFFFFF),
                                                                              fontSize: 14,
                                                                            ),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(26),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: const Color(0x7FF0EFF4),
                                                                              labelText: 'UMKM adalah..',
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
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Omset",
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
                                                                                controller: _omsetController,
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
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                          Color>(const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          218,
                                                                          65,
                                                                          103))),
                                                              child: Text(
                                                                "Edit",
                                                                style: GoogleFonts.rubik(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white),
                                                              )),
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
                                                                  103)),
                                                        ]);
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 218, 65, 103),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17)),
                                                minimumSize: const Size(73, 28),
                                              ),
                                              child: Text(
                                                "Edit UMKM",
                                                style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                              text: "${umkm.deskripsi}",
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tahun Berdiri",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "${umkm.tahun_berdiri}",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Omset per tahun",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "Rp. ${umkm.omset}jt",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Lokasi",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "${umkm.lokasi}",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Kategori",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "${umkm.kategori}",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Kelas",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "${umkm.kelas}",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Image.asset(
                                                'assets/images/thumbnail.png',
                                                width: 153,
                                                height: 86,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "RENOVIN - UMKM yang bergerak pada bidang...",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "Rp 5jt | 10% | 3 bln",
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "716K ditonton",
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "219 disukai",
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
