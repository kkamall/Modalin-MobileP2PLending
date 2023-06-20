import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddUmkm extends StatefulWidget {
  const AddUmkm({Key? key}) : super(key: key);
  @override
  AddUmkmState createState() {
    return AddUmkmState();
  }
}

class AddUmkmState extends State<AddUmkm> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller buat text
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tahunBerdiriController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _omsetController = TextEditingController();

  String nama_umkm = "";
  String deskripsi = "";
  int omset = 0;
  String lokasi = "";
  int tahun_berdiri = 0;
  String id_user_borrower = "";

  // Dropdown Kategori
  List<String> listKategori = [
    'Properti',
    'Food & Beverages',
    'Fashion',
    'Handcraft',
    'Produk Digital'
  ];
  String? kategori;

  // Dropdown Kelas
  List<String> listKelas = ['Menengah', 'Kecil', 'Mikro'];
  String? kelas;

  late Future<int> respPost; //201 artinya berhasil
  String addUmkm = "http://127.0.0.1:8000/add_umkm/";

  Future<int> insertDataUmkm() async {
    //data disimpan di body
    final response = await http.post(Uri.parse(addUmkm),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"nama_umkm": "$nama_umkm",
      "deskripsi": "$deskripsi",
      "omset": $omset,
      "lokasi": "$lokasi",
      "kategori": "$kategori",
      "kelas": "$kelas",
      "tahun_berdiri": $tahun_berdiri,
      "id_user_borrower": $id_user_borrower} """);
    return response.statusCode; //sukses kalau 201
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      nama_umkm = _nameController.text;
      tahun_berdiri = int.parse(_tahunBerdiriController.text);
      lokasi = _lokasiController.text;
      deskripsi = _deskripsiController.text;
      omset = int.parse(_omsetController.text);

      respPost = insertDataUmkm();
      Navigator.pushNamed(context, '/home_borrower',
          arguments: id_user_borrower);
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
    id_user_borrower = ModalRoute.of(context)!.settings.arguments as String;
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
                    "UMKM",
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
                        margin: EdgeInsets.only(bottom: 25.0),
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
                            // Field Omset UMKM Per Tahun
                            Container(
                              height: 32,
                              width: 224,
                              child: TextFormField(
                                controller: _omsetController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan omset UMKM per tahun';
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
                                  labelText: 'Omset Per Tahun',
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
                                  'Submit',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 13,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
