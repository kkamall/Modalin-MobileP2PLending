import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ProfileBorrowerState createState() {
    return ProfileBorrowerState();
  }
}

class ProfileBorrowerState extends State<MyApp> {
  // penanda buat list yang dpilih
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MODALIN',
      home: Scaffold(
        body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("PROFIL",
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800)),
                      IconButton(
                          iconSize: 42,
                          onPressed: () {},
                          icon: const Icon(Icons.home),
                          color: Colors.white)
                    ]),
              ),
              // profile data
              Stack(
                children: [
                  Container(
                    width: 446,
                    height: 114,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 131, 33, 97),
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  // buat nama sama email
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 30, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rifqi Fajar",
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "rifqi.fajar@upi.edu",
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  // buat button edit profil
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 130, 0, 42),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 65, 103),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(132, 40),
                      ),
                      child: Text(
                        "Edit Profil",
                        style: GoogleFonts.outfit(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // buat foto profil
                  Positioned(
                    top: 28,
                    left: 270,
                    child: Container(
                        width: 144,
                        height: 144,
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
                      width: 328,
                      height: 152,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 33, 97),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                            child: Text(
                              "Saldo",
                              style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Rp",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "5.000.000",
                            style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(80, 56, 80, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Top Up",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    iconSize: 52,
                                  )
                                ],
                              )),
                          Container(
                            width: 2,
                            height: 64,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Withdraw",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.wallet_rounded),
                                    color: Colors.white,
                                    iconSize: 52,
                                  )
                                ],
                              )),
                        ],
                      ))
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
                                  fontSize: 20, fontWeight: FontWeight.w500),
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
                                  height: 5,
                                  width: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(255, 218, 65, 103),
                                  ),
                                )
                              : Container(
                                  height: 5,
                                  width: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(0, 218, 65, 103),
                                  ))
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              textStyle: GoogleFonts.outfit(
                                  fontSize: 20, fontWeight: FontWeight.w500),
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
                                  height: 5,
                                  width: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(255, 218, 65, 103),
                                  ),
                                )
                              : Container(
                                  height: 5,
                                  width: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(0, 218, 65, 103),
                                  ))
                        ]),
                  ],
                ),
              ),
              SizedBox(
                height: 21,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 68.0),
                  child: flag == 0
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "RENOVIN",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 218, 65, 103),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    minimumSize: const Size(132, 40),
                                  ),
                                  child: Text(
                                    "Edit Profil",
                                    style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Renovin adalah UMKM yang bergerak dibidang properti.",
                                style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tahun Berdiri",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "2012",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Omset per tahun",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Rp 100jt",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lokasi",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Kota Bandung",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kategori",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Properti",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kelas",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Mikro",
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/thumbnail.png',
                                  width: 203,
                                  height: 136,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "RENOVIN ",
                                      style: GoogleFonts.rubik(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
