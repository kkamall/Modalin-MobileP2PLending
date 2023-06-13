import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBorrowerDapatPinjaman extends StatefulWidget {
  @override
  State<HomeBorrowerDapatPinjaman> createState() => _HomeState();
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

class _HomeState extends State<HomeBorrowerDapatPinjaman> {
  int flag = 0;
  String? id_user = "";

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

  @override
  Widget build(BuildContext context) {
    id_user = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      title: 'MODALIN',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: 360,
                height: 970,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    Navigator.pushNamed(context, '/notifikasi');
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
                                color: const Color.fromARGB(255, 131, 33, 97),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Saldo Rp. 10.000.000",
                                    style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
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
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print('Icon pressed');
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    const SizedBox(
                                      height:
                                          16, // Jarak antara status pinjaman dan gambar
                                    ),
                                    Container(
                                      width: 202, // Lebar gambar
                                      height: 114, // Tinggi gambar
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .grey, // Warna latar belakang gambar
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      //Tambahkan widget Image di sini untuk menampilkan gambar
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/thumbnail.png'), // Ganti dengan path gambar Anda
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height:
                                  16, // Jarak antara status gambar dan renovin
                            ),
                            Text(
                              "RENOVIN - UMKM yang bergerak di bidang properti",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            //jarak
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "2 Juni 2023",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Jumlah Pinjaman: Rp 5.000.000",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Persentase Return: 10%",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Lama Pinjaman: 3 bulan",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status : Sudah dapat Modal",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Investor : Asep Sutrisna",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "12 Juni 2023",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      width: 70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFDA4167),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Aksi yang ingin dilakukan saat tombol ditekan
                                        },
                                        child: Text(
                                          'chat',
                                          style: GoogleFonts.rubik(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 18),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 131, 33, 97),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Tenggat Waktu: 12 Agustus 2023",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "Rp 5.500.000 ",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 70,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFDA4167),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Aksi yang ingin dilakukan saat tombol ditekan
                                      },
                                      child: Text(
                                        'Bayar',
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ----------------------------------

                            // Stack(
                            //   children: [
                            //     Center(
                            //       child: Container(
                            //         margin: const EdgeInsets.only(
                            //           top: 30,
                            //         ),
                            //         width: 240,
                            //         height: 95,
                            //         decoration: BoxDecoration(
                            //           color: const Color.fromARGB(
                            //               255, 131, 33, 97),
                            //           borderRadius: BorderRadius.circular(13),
                            //         ),
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             const Text(
                            //               "Tenggat Waktu: 12 Agustus 2023",
                            //               style: TextStyle(
                            //                   fontFamily: "Outfit",
                            //                   fontSize: 12,
                            //                   color: Colors.white,
                            //                   fontWeight: FontWeight.w500),
                            //             ),
                            //             const SizedBox(
                            //               height: 7,
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: [
                            //                 Column(
                            //                   children: [
                            //                     const Text(
                            //                       "Rp 5.500.000 ",
                            //                       style: TextStyle(
                            //                         fontFamily: "Outfit",
                            //                         color: Colors.white,
                            //                         fontSize: 12,
                            //                         fontWeight: FontWeight.w500,
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //                 SizedBox(height: 16),
                            //                 SizedBox(
                            //                   height: 32,
                            //                   child: ElevatedButton(
                            //                     style: ElevatedButton.styleFrom(
                            //                       backgroundColor:
                            //                           const Color(0xFFDA4167),
                            //                       shape: RoundedRectangleBorder(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 17.0),
                            //                       ),
                            //                     ),
                            //                     onPressed: () {
                            //                       // Aksi yang ingin dilakukan saat tombol ditekan
                            //                     },
                            //                     child: Text(
                            //                       'bayar',
                            //                       style: TextStyle(
                            //                         fontFamily: "Outfit",
                            //                         fontWeight: FontWeight.w200,
                            //                         color: Color(0xFFFFFFFF),
                            //                         fontSize: 16,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      // end status pinjaman
                      // start pengeluaran
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                        child: Container(
                          width: double.infinity,
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
                            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Pinjaman",
                                  style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/${listPengeluaran[index].foto}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  listPengeluaran[index].nama,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 6, 0, 0),
                                              child: Text(
                                                listPengeluaran[index].jumlah +
                                                    " | " +
                                                    listPengeluaran[index]
                                                        .retur +
                                                    " | " +
                                                    listPengeluaran[index]
                                                        .waktu,
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Lihat Lainnya",
                                      style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // end pengeluaran
                    ],
                  ),
                ),
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
    );
  }
}
