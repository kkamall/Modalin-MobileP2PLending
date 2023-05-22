import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _verifikasiKodeController =
      TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      String verifikasiKode = _verifikasiKodeController.text;
      // Process the input data or perform other operations
      print('Submitted Kode: $verifikasiKode');
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
                    "MODALIN",
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
                        margin: EdgeInsets.only(bottom: 56.0),
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
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => LoginPage(),
                                    //   ),
                                    // );
                                    print("Login button clicked!");
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
