import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      title: 'Hello App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3D2645),
                Color(0xFF000000)
              ], // Replace with your desired colors
              begin: Alignment.topCenter, // Define the gradient starting point
              end: Alignment.bottomCenter, // Define the gradient ending point
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: //20 pixel ke semua arah
                      Text(
                    "Hari ini",
                    style: GoogleFonts.rubik(
                        fontSize: 14,
                        //fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataNotif.length,
                  itemBuilder: (context, index) {
                    return dataNotif[index].waktu == 0
                        ? Card(
                            child: ListTile(
                              title: Row(children: [
                                dataNotif[index].jenis == 0
                                    ? Text(
                                        "Pesan Baru: ",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "Video Populer: ",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    dataNotif[index].isi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rubik(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                              subtitle: Text(
                                dataNotif[index].nama,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.rubik(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              leading: dataNotif[index].jenis == 0
                                  ? SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/${dataNotif[index].foto}',
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                  : SizedBox(
                                      width: 46,
                                      height: 36,
                                      child: Image.asset(
                                        'assets/images/${dataNotif[index].foto}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              tileColor: const Color(0xFF3D2645),
                              onTap: () {},
                            ),
                          )
                        : const SizedBox();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                  child: //20 pixel ke semua arah
                      Text(
                    "Minggu ini",
                    style: GoogleFonts.rubik(
                        fontSize: 14,
                        //fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataNotif.length,
                  itemBuilder: (context, index) {
                    return dataNotif[index].waktu == 1
                        ? Card(
                            child: ListTile(
                              title: Row(children: [
                                dataNotif[index].jenis == 0
                                    ? Text(
                                        "Pesan Baru: ",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "Video Populer: ",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    dataNotif[index].isi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rubik(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                              subtitle: Text(
                                dataNotif[index].nama,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.rubik(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              leading: dataNotif[index].jenis == 0
                                  ? SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/${dataNotif[index].foto}',
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                  : SizedBox(
                                      width: 46,
                                      height: 36,
                                      child: Image.asset(
                                        'assets/images/${dataNotif[index].foto}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
        ),
      ),
    );
  }
}
