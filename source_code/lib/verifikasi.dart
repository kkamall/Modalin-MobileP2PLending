import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Verifikasi extends StatefulWidget {
  const Verifikasi({Key? key}) : super(key: key);
  @override
  VerifikasiState createState() {
    return VerifikasiState();
  }
}

class VerifikasiState extends State<Verifikasi> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _verifikasiKodeController =
      TextEditingController();

  late Future<int> respPost; //201 artinya berhasil
  String verifikasiEmail = "http://127.0.0.1:8000/verifikasi_email/";
  List hasilValidasi = [];
  String idUser = "";
  String roleUser = "";

  Future<int> validateLogin() async {
    //data disimpan di body
    final response = await http.get(Uri.parse(verifikasiEmail));

    if (response.statusCode == 200) {
      hasilValidasi = jsonDecode(response.body);
      if (hasilValidasi[1] == "Borrower") {
        Navigator.pushNamed(context, '/add_umkm',
            arguments: hasilValidasi[0].toString());
      } else {
        Navigator.pushNamed(context, '/profile_lender',
            arguments: hasilValidasi[0].toString());
      }
    } else {
      throw Exception('Gagal load');
    }
    return response.statusCode;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      String verifikasiKode = _verifikasiKodeController.text;
      verifikasiEmail = verifikasiEmail + idUser + verifikasiKode;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    idUser = arguments['id_user'] as String;
    roleUser = arguments['role_user'] as String;
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "VERIFIKASI",
                    style: GoogleFonts.outfit(
                      color: Color(0xFFFFFFFF),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Menampilkan Logo
                      Container(
                        margin: EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 105,
                            height: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Form Verifikasi Kode User
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Masukkan kode verifikasi",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            // Field Verifikasi Kode User
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _verifikasiKodeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan kode verifikasi';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0x7FF0EFF4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  labelText: 'Verification Code',
                                  labelStyle: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 13,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 18.0,
                                  ), // Adjust vertical value padding
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never, // Remove label animation
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Kami telah mengirimkan\nemail konfirmasi ke email@mai.com\nberisi kode verifikasi",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 59.0),
                            SizedBox(
                              width: 151,
                              height: 27,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF832161),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17.0),
                                  ),
                                ),
                                onPressed: _submitForm,
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Salah email? ',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 11,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the login page
                                    Navigator.pushNamed(context, '/registrasi');
                                  },
                                  child: Text(
                                    'Klik disini!',
                                    style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFDA4167),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
