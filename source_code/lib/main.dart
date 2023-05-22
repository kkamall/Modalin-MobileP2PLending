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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tahunBerdiriController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _linkVideoYoutubeController =
      TextEditingController();

  // Dropdown Kategori
  List<String> listKategori = ['Properti', 'Makanan', 'Saham'];
  String? kategori;

  // Dropdown Kelas
  List<String> listKelas = ['Mikro', 'Makro'];
  String? kelas;

  // Upload Video
  // String? filePath;
  // FilePickerResult? result;
  // String? fileName;
  // PlatformFile? pickedFile;
  // bool isLoading = false;
  // File? fileToDisplay;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      String name = _nameController.text;
      String tahunBerdiri = _tahunBerdiriController.text;
      String lokasi = _lokasiController.text;
      String deskripsi = _deskripsiController.text;
      String linkVideoYoutube = _linkVideoYoutubeController.text;
      // Process the input data or perform other operations
      print('Submitted Name: $name');
      print('Submitted Name: $tahunBerdiri');
      print('Submitted Name: $lokasi');
      print('Submitted Name: $deskripsi');
      print('Selected Kategori: $kategori');
      print('Selected Kelas: $kelas');
      print('Submitted Link YT: $linkVideoYoutube');
    }
  }

  // Future<void> _openFileExplorer() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     result = await FilePicker.platform.pickFiles(
  //       type: FileType.any,
  //       allowMultiple: false,
  //     );

  //     if (result != null) {
  //       // fileName = result!.files.first.name;
  //       // pickedFile = result!.files.first;
  //       fileToDisplay = File(result!.files.first.path!);

  //       final fileName2 = path.basename(fileToDisplay!.path);
  //       final destination = 'assets/video/$fileName2';

  //       try {
  //         final savedFile = await fileToDisplay!.copy(destination);
  //         print('File Saved!');
  //       } catch (e) {
  //         print(e);
  //       }

  //       // // Destination directory in assets
  //       // String destinationDirectory = 'assets/videos';

  //       // // Create a File instance for the destination path
  //       // File destinationFile = File('$destinationDirectory/$fileName');

  //       // // Copy the file to the destination path
  //       // await fileToDisplay!.copy(destinationFile.path);

  //       // setState(() {
  //       //   // Update the fileToDisplay with the copied file
  //       //   fileToDisplay = destinationFile;
  //       // });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
                      color: Color(0xFFF0EFF4),
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
                        margin: EdgeInsets.only(bottom: 25.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 105,
                          height: 105,
                        ),
                      ),
                      // Form penambahan UMKM
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Field Nama UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan nama UMKM';
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
                                  labelText: 'Nama UMKM',
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
                            // Field Tahun Berdiri UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _tahunBerdiriController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan tahun berdiri UMKM';
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
                                  labelText: 'Tahun Berdiri',
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
                            // Field Lokasi UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _lokasiController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan lokasi UMKM';
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
                                  labelText: 'Lokasi UMKM',
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
                            // Field Deskripsi UMKM
                            Container(
                              height: 44,
                              width: 224,
                              child: TextFormField(
                                controller: _deskripsiController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan Deskripsi UMKM';
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
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  labelText: 'Deskripsi UMKM',
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
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            // Dropdown Kategori UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: DropdownButtonFormField<String>(
                                value: kategori,
                                onChanged: (newValue) {
                                  setState(() {
                                    kategori = newValue;
                                  });
                                },
                                items: listKategori.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: Text(location),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a location';
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
                                  labelText: 'Kategori UMKM',
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
                            SizedBox(height: 20.0),
                            // Dropdown Kelas UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: DropdownButtonFormField<String>(
                                value: kelas,
                                onChanged: (newValue) {
                                  setState(() {
                                    kelas = newValue;
                                  });
                                },
                                items: listKelas.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pilih salah satu kelas UMKM';
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
                                  labelText: 'Kelas UMKM',
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
                            SizedBox(height: 20.0),
                            // Field Link Video Youtube UMKM
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _linkVideoYoutubeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan link video Youtube';
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
                                  labelText: 'Link Video Youtube',
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
                            // Container(
                            //   height: 32,
                            //   width: 224,
                            //   child: ElevatedButton(
                            //     onPressed: _openFileExplorer,
                            //     child: Text(
                            //       'Upload Video',
                            //       style: GoogleFonts.rubik(
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: 13,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
                                child: Text('Submit'),
                              ),
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
