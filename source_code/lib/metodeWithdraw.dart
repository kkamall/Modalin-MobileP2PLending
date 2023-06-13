import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  MetodePembayaran createState() {
    return MetodePembayaran();
  }
}

// ini buat metode pembayarannya
enum methodType { gopay, dana, shopeepay }

class MetodePembayaran extends State<Withdraw> {
  // penanda buat list yang dpilih
  methodType? jenisMetode;

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
                SizedBox(height: 30.0),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Color(0xFFDA4167)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Menampilkan Lambang S
                      Container(
                        margin: EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: Image.asset(
                            "/images/metode.png",
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),

                      Text(
                        "REKENING TUJUAN",
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(height: 12.0),
                      Text(
                        "Pilih rekening tujuan untuk melanjutkan proses withdraw",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                        ),
                      ),

                      // ini buat pilihan metode nya
                      SizedBox(height: 12.0),
                      Theme(
                        data:
                            ThemeData(unselectedWidgetColor: Color(0xFFDA4167)),
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),

                            // pilihan gopay
                            Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDA4167)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: RadioListTile<methodType>(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.0,
                                      child: ClipOval(
                                        child: Image.asset(
                                          '/images/Gopay.png',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.0),
                                    Text(
                                      'Gopay',
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                value: methodType.gopay,
                                groupValue: jenisMetode,
                                onChanged: (methodType? value) {
                                  setState(() {
                                    jenisMetode = value;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Color(0xFFDA4167),
                              ),
                            ),

                            // pilihan dana
                            SizedBox(height: 10.0),
                            Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDA4167)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: RadioListTile<methodType>(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.0,
                                      child: ClipOval(
                                        child: Image.asset(
                                          '/images/Dana.png',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.0),
                                    Text(
                                      'DANA',
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                value: methodType.dana,
                                groupValue: jenisMetode,
                                onChanged: (methodType? value) {
                                  setState(() {
                                    jenisMetode = value;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Color(0xFFDA4167),
                              ),
                            ),

                            // pilihan shopee
                            SizedBox(height: 10.0),
                            Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDA4167)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: RadioListTile<methodType>(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.0,
                                      child: ClipOval(
                                        child: Image.asset(
                                          '/images/Shopeepay.png',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.0),
                                    Text(
                                      'Shopeepay',
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                value: methodType.shopeepay,
                                groupValue: jenisMetode,
                                onChanged: (methodType? value) {
                                  setState(() {
                                    jenisMetode = value;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Color(0xFFDA4167),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ini buat nampilin total
                      SizedBox(height: 65.0),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 131, 33, 97)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromARGB(255, 131, 33, 97)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            'Total',
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w200,
                              color: Color(0xFFFFFFFF),
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            'Rp1.000.000',
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                            ),
                          ),
                          tileColor: Color.fromARGB(255, 131, 33, 97),
                          dense: true,
                          trailing: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              // tombol bayar
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/home_borrower');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 218, 65, 103),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17)),
                                  ),
                                  child: Text(
                                    "Withdraw",
                                    style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              // tombol cancel
                              IconButton(
                                iconSize: 10,
                                splashRadius: 12.5,
                                icon: Image.asset('/images/Cancel.png'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
