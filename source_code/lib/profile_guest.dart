import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileGuest extends StatefulWidget {
  const ProfileGuest({Key? key}) : super(key: key);
  @override
  ProfileGuestState createState() {
    return ProfileGuestState();
  }
}

class ProfileGuestState extends State<ProfileGuest> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      String username = _usernameController.text;
      String password = _passwordController.text;
      // Process the input data or perform other operations
      print('Submitted Name: $username');
      print('Submitted Name: $password');
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("PROFIL",
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700)),
                    IconButton(
                        iconSize: 42,
                        onPressed: () {},
                        icon: const Icon(Icons.home),
                        color: Colors.white)
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Menampilkan Logo
                      Container(
                        margin: EdgeInsets.only(bottom: 19.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: Image.asset(
                            'assets/images/profil_guest.png',
                            width: 126,
                            height: 126,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        "Oopss..",
                        style: GoogleFonts.rubik(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Text(
                        "Fitur ini dapat diakses jika kamu\nsudah masuk untuk mendaftar",
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: 165,
                        height: 34,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF832161),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                          ),
                          onPressed:() => Navigator.pushNamed(context, '/registrasi'),
                          child: Text(
                            'Daftar Sekarang!',
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                            ),
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
