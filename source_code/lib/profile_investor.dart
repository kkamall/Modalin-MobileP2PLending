import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

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

// class untuk menampung data investasi
class Investasi {
  String foto = "";
  String nama = "";

  String jumlah = "";
  String persentase = "";
  String waktu = "";

  Investasi(this.foto, this.nama, this.jumlah, this.persentase, this.waktu);
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
  String id_user = "";
  String nama = "";

  // list investasi
  List<Investasi> listInvestasi = [
    Investasi('assets/images/formal.png', 'Mang Lewis', '5jt', '5%', '6 bln'),
    Investasi('assets/images/formal.png', 'Super Max', '3jt', '4%', '6 bln'),
    Investasi('assets/images/formal.png', 'Checo', '7jt', '6%', '12 bln'),
  ];

  // list LikedVideo
  List<LikedVideo> listLikedVideo = [
    LikedVideo('Membuat Bata Merah', 'assets/images/thumbnail.png',
        'assets/images/formal.png'),
    LikedVideo('eSports Desa Kami', 'assets/images/thumbnail.png',
        'assets/images/formal.png'),
    // LikedVideo('Update UMKM Kami', 'assets/images/thumbnail.png',
    //     'assets/images/formal.png'),
    // LikedVideo('Penerapan Teknologi', 'assets/images/thumbnail.png',
    //     'assets/images/formal.png'),
  ];

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
    print(_nameController.text);
    if (_nameController.text != "") {
      nama = _nameController.text;
    } else {
      nama = "kosong";
    }

    respPost = updateUser();
  }

  // penanda buat list yang dpilih
  int flag = 0;
  int flagAmbil = 0;

  @override
  Widget build(BuildContext context) {
    id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (BuildContext context) => ProfileCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MODALIN',
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
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 20, 26, 21),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: const Color.fromARGB(255, 131, 33, 97),
                                  borderRadius: BorderRadius.circular(13)),
                            ),
                            // buat nama sama email
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
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
                              padding: const EdgeInsets.fromLTRB(14, 90, 0, 0),
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
                                          backgroundColor: const Color.fromARGB(
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
                                                                    BorderRadius.circular(
                                                                        100),
                                                                border: Border.all(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        61,
                                                                        38,
                                                                        69),
                                                                    width: 2)),
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
                                                      style: GoogleFonts.rubik(
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
                                                                  .circular(26),
                                                        ),
                                                        filled: true,
                                                        fillColor: const Color(
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
                                      borderRadius: BorderRadius.circular(17)),
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
                                      borderRadius: BorderRadius.circular(100),
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
                                  color: const Color.fromARGB(255, 131, 33, 97),
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
                                      child: const Text("Investasi"),
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
                                      child: const Text("Video Disukai"),
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
                        flag == 0
                            // untuk list investasi
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: listInvestasi.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(64, 0, 64, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 61, 38, 69),
                                                        width: 2)),
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    '${listInvestasi[index].foto}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18),
                                              child: Text(
                                                "${listInvestasi[index].nama}",
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
                                          "RP ${listInvestasi[index].jumlah} | ${listInvestasi[index].persentase} | ${listInvestasi[index].waktu}",
                                          style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  );
                                })
                            // untuk video yg disukai
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: listLikedVideo.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: 152,
                                      height: 86,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(52, 0, 52, 16),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                      listLikedVideo[index]
                                                          .thumbnail),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: index <
                                                          listLikedVideo
                                                                  .length -
                                                              1
                                                      ? Image.asset(
                                                          listLikedVideo[
                                                                  index + 1]
                                                              .thumbnail)
                                                      : Image.asset(
                                                          listLikedVideo[index]
                                                              .thumbnail),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                })
                      ]);
                },
              ),
            ),
          )),
        ),
      ),
    );
  }
}
