import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String username = "";
  String password = "";
  List hasilValidasi = [];
  int flagLogin = 0;

  late Future<int> respPost; //201 artinya berhasil
  String login = "http://127.0.0.1:8000/login/";
  String cek_pinjaman_belum_selesai =
      "http://127.0.0.1:8000/cek_pinjaman_belum_selesai/";

  Future<int> validateLogin() async {
    //data disimpan di body
    final response = await http.get(Uri.parse(login));
    hasilValidasi = jsonDecode(response.body);
    final responseCekPinjamanBelumSelesai = await http.get(
        Uri.parse(cek_pinjaman_belum_selesai + hasilValidasi[1].toString()));
    List jsonCekPinjamanBelumSelesai =
        jsonDecode(responseCekPinjamanBelumSelesai.body);

    if (response.statusCode == 200) {
      if (hasilValidasi[0] == "Ada") {
        if (hasilValidasi[2] == "Borrower") {
          if (jsonCekPinjamanBelumSelesai[0] == "Tidak Ada") {
            Navigator.pushNamed(context, '/home_borrower',
                arguments: hasilValidasi[1].toString());
          } else if (jsonCekPinjamanBelumSelesai[0] == "Ada") {
            Navigator.pushNamed(
              context,
              '/home_borrower_dapat_pinjaman',
              arguments: {
                'id_user': hasilValidasi[1].toString(),
                'id_pinjaman': jsonCekPinjamanBelumSelesai[1].toString(),
              },
            );
          }
        } else {
          Navigator.pushNamed(context, '/home',
              arguments: hasilValidasi[1].toString());
        }
      } else {
        setState(() {
          flagLogin = 1;
        });
      }
    } else {
      throw Exception('Gagal load');
    }
    return response.statusCode;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      username = _usernameController.text;
      password = _passwordController.text;
      login = "http://127.0.0.1:8000/login/";
      login = login + username + '/' + password;
      validateLogin();
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
                    "LOGIN",
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
                        margin: EdgeInsets.only(bottom: 35.0),
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
                      if (flagLogin == 1) ...{
                        Text(
                          "Email atau Password Anda salah!",
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      },
                      SizedBox(height: 6.0),
                      // Form penambahan UMKM
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Field Username User
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan username user';
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
                                  labelText: 'Username',
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
                            SizedBox(height: 13.0),
                            // Field Password User
                            Container(
                              height: 55,
                              width: 224,
                              child: Column(
                                children: [
                                  Container(
                                    height: 32,
                                    child: TextFormField(
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan password user';
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0x7FF0EFF4),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                        ),
                                        labelText: 'Password',
                                        labelStyle: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 13,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 18.0,
                                        ), // Adjust vertical value padding
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior
                                                .never, // Remove label animation
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to the login page
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => LoginPage(),
                                        //   ),
                                        // );
                                        print(
                                            "Forgot Password button clicked!");
                                      },
                                      child: Text(
                                        'Lupa Password?',
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFDA4167),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 31.0),
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
                                  'Login',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 11,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the register page
                                    Navigator.pushNamed(context, '/registrasi');
                                  },
                                  child: Text(
                                    'Daftar sekarang!',
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
