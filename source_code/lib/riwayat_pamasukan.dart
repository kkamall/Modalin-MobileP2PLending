import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Riwayat());
}

class Riwayat extends StatefulWidget {
  @override
  State<Riwayat> createState() => _HomeState();
}

class _HomeState extends State<Riwayat> {
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
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
            margin: EdgeInsets.fromLTRB(26, 20, 26, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("RIWAYAT",
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        IconButton(
                            iconSize: 40,
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            icon: const Icon(Icons.home),
                            color: Colors.white)
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PEMASUKAN",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Rp5.000.000",
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Untung dari Investasi",
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: 10.0),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15.0,
                                child: ClipOval(
                                  child: Image.asset(
                                    '/images/formal.png',
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'RENOVIN',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 9.0),
                          Container(
                            width: double.infinity,
                            child: Text(
                              'RENOVIN - UMKM yang bergerak di bidang properti',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text(
                                'Tanggal Transaksi: 2 Juni 2023',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w200,
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.0),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Lama Pinjaman: 3 bulan',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Jumlah Pinjaman: Rp5.000.000',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Persentase Return: 10%',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Keuntungan: Rp5.000.000',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
