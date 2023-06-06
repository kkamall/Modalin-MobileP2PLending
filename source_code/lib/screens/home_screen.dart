import 'package:flutter/material.dart';
import 'package:tugas_besar/data.dart';
import 'package:tugas_besar/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 78, 77, 79),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3D2645), Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    SizedBox(
                      height: 19,
                    ),
                    Container(
                      width: 450,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 158, 154, 157),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Cari UMKM',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 24,
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                        ),
                      ]),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '   Kategori',
                            style: GoogleFonts.rubik(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 280,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // Aksi ketika tombol 2 ditekan
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(0, 178, 161, 161),
                              // side: BorderSide(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              'Lainnya',
                              style: GoogleFonts.rubik(
                                color: Color(0xFFDA4167),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 1 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Populer',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 2 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Pertanian',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 1 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Industri',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 2 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Kuliner',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '   Kelas',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 1 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Semua',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 2 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Menengah',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 1 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Mikro',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0), // Atur ukuran jarak di sini
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol 2 ditekan
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Kecil',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = videos[index];
                  return VideoCard(video: video);
                },
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
