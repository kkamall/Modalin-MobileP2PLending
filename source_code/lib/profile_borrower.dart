import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            child: Column(
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
                              Navigator.pushNamed(context, '/home');
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
                          backgroundColor:
                              const Color.fromARGB(255, 218, 65, 103),
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
                              child: const Text("UMKM"),
                            ),
                            flag == 0
                                ? Container(
                                    height: 4,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 218, 65, 103),
                                    ),
                                  )
                                : Container(
                                    height: 4,
                                    width: 80,
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 218, 65, 103),
                                    ),
                                  )
                                : Container(
                                    height: 4,
                                    width: 80,
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
                                    "RENOVIN",
                                    style: GoogleFonts.outfit(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 218, 65, 103),
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
                                    text:
                                        "Renovin adalah UMKM yang bergerak dibidang properti.",
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
                                    "2012",
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
                                    "Rp 100jt",
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
                                    "Kota Bandung",
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
                                    "Properti",
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
                                    "Mikro",
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
                                    margin: EdgeInsets.only(right: 10),
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
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "RENOVIN - UMKM yang bergerak pada bidang...",
                                              style: GoogleFonts.rubik(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Rp 5jt | 10% | 3 bln",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "716K ditonton",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "219 disukai",
                                              style: GoogleFonts.outfit(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
            ),
          ),
        ),
      ),
    );
  }
}
