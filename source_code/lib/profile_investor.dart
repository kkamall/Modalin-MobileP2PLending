import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class untuk menampung data user
class User {
  String nama = "";
  String email = "";
  String foto = "";

  User(this.nama, this.email, this.foto);
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
  ProfileBorrowerState createState() {
    return ProfileBorrowerState();
  }
}

class ProfileBorrowerState extends State<ProfileInvestor> {
  // bikin objek user
  User user = User('Rifqi Fajar', 'rifqi.fajar@upi.edu', 'formal.png');

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
    LikedVideo('Update UMKM Kami', 'assets/images/thumbnail.png',
        'assets/images/formal.png'),
    LikedVideo('Penerapan Teknologi', 'assets/images/thumbnail.png',
        'assets/images/formal.png'),
  ];

  // penanda buat list yang dpilih
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                        onPressed: () {},
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
                        "Rifqi Fajar",
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "rifqi.fajar@upi.edu",
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 218, 65, 103),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17)),
                      minimumSize: const Size(73, 28),
                    ),
                    child: Text(
                      "Edit Profil",
                      style: GoogleFonts.outfit(
                          fontSize: 10, fontWeight: FontWeight.w500),
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
                              color: const Color.fromARGB(255, 61, 38, 69),
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
                          "Saldo Rp. 5.000.000",
                          style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              decoration:
                                  const BoxDecoration(color: Colors.white),
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
                                fontSize: 14, fontWeight: FontWeight.w500),
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
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 218, 65, 103),
                                ),
                              )
                            : Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(0, 218, 65, 103),
                                ))
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.outfit(
                                fontSize: 14, fontWeight: FontWeight.w500),
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
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 218, 65, 103),
                                ),
                              )
                            : Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(0, 218, 65, 103),
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
                        padding: const EdgeInsets.fromLTRB(64, 0, 64, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 61, 38, 69),
                                            width: 2)),
                                    child: ClipOval(
                                      child: Image.asset(
                                        '${listInvestasi[index].foto}',
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Text(
                                    "${listInvestasi[index].nama}",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
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
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(52, 0, 52, 16),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                          listLikedVideo[index].thumbnail),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: index < listLikedVideo.length - 1
                                          ? Image.asset(
                                              listLikedVideo[index + 1]
                                                  .thumbnail)
                                          : Image.asset(
                                              listLikedVideo[index].thumbnail),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ));
                    })
          ]),
        ),
      )),
    );
  }
}
