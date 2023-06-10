import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Registrasi extends StatefulWidget {
  const Registrasi({Key? key}) : super(key: key);
  @override
  RegistrasiState createState() {
    return RegistrasiState();
  }
}

class RegistrasiState extends State<Registrasi> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String email = "";
  String username = "";
  String password = "";
  String confirmPassword = "";

  // Dropdown Role
  List<String> listRoleUser = ['Borrower', 'Lender'];
  String? roleUser;

  late Future<int> respPost; //201 artinya berhasil
  String registrasi = "http://127.0.0.1:8000/registrasi/";

  Future<int> insertDataUser() async {
    //data disimpan di body
    final response = await http.post(Uri.parse(registrasi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"username": "$username",
      "email": "$email",
      "password": "$password",
      "role": "$roleUser",
      "saldo_dana": 0} """);
    return response.statusCode; //sukses kalau 201
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      email = _emailController.text;
      username = _usernameController.text;
      password = _passwordController.text;
      confirmPassword = _confirmPasswordController.text;
      
      respPost = insertDataUser();
      Navigator.pushNamed(context, '/verifikasi');
    }
  }

  @override
  void initState() {
    super.initState();
    respPost = Future.value(0); //init
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
                    "REGISTER",
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
                        margin: EdgeInsets.only(bottom: 20.0),
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
                      // Form penambahan UMKM
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Field Email User
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan email user';
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
                                  labelText: 'Email',
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
                            SizedBox(height: 20.0),
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
                            SizedBox(height: 20.0),
                            // Field Password User
                            Container(
                              height: 32,
                              width: 224,
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
                                    borderRadius: BorderRadius.circular(26),
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
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never, // Remove label animation
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            // Field Confirm Password User
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan password yang sama';
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
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  labelText: 'Confirm Password',
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
                            SizedBox(height: 20.0),
                            // Dropdown Kategori UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: DropdownButtonFormField<String>(
                                value: roleUser,
                                onChanged: (newValue) {
                                  setState(() {
                                    roleUser = newValue;
                                  });
                                },
                                items: listRoleUser.map((roleUser) {
                                  return DropdownMenuItem(
                                    value: roleUser,
                                    child: Text(roleUser),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a role';
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
                                  labelText: 'Role User',
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
                                dropdownColor: Color(0xFF8A828E),
                              ),
                            ),
                            SizedBox(height: 25.0),
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
                                  'Register',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sudah punya akun? ',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 11,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the login page
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Login!',
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
