import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class untuk menampung data user
class Chat {
  String nama = "";
  String foto = "";
  String lastChat = "";
  int chat = 0;

  Chat(this.nama, this.foto, this.lastChat, this.chat);
}

class ChatGuest extends StatefulWidget {
  const ChatGuest({Key? key}) : super(key: key);

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<ChatGuest> {
  // list objek chat
  List<Chat> listChat = [
    Chat("MAKAN2", "formal.png", "Jadi Bagaimana Pak?", 3),
    Chat("RENOVIN", "formal.png", "Jadi Bagaimana Pak?", 1),
    Chat("KOPIKIRAN", "formal.png", "Jadi Bagaimana Pak?", 0),
    Chat("KOKITA", "formal.png", "Jadi Bagaimana Pak?", 0),
  ];

  // penanda buat list yang dpilih
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MODALIN',
      home: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: 360,
                height: 640,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 61, 38, 69),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // start top bar?
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("PESAN",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                      iconSize: 38,
                                      onPressed: () {},
                                      icon: const Icon(Icons.notifications),
                                      color: Colors.white),
                                  IconButton(
                                      iconSize: 38,
                                      onPressed: () {},
                                      icon: const Icon(Icons.account_circle),
                                      color: Colors.white)
                                ],
                              ),
                            ]),
                      ),
                      // end top bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 95, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Menampilkan Logo
                            Container(
                              margin: const EdgeInsets.only(bottom: 19.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14.0),
                                child: Image.asset(
                                  'images/chat_guest.png',
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
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            Text(
                              "Fitur ini dapat diakses jika kamu\nsudah masuk untuk mendaftar",
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            SizedBox(
                              width: 165,
                              height: 34,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF832161),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17.0),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/registrasi'),
                                child: Text(
                                  'Daftar Sekarang!',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            // start bottom nav
            Positioned(
              bottom: 20,
              left: 90,
              child: Container(
                width: 180,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF832161),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 26,
                      onPressed: () {},
                      icon: const Icon(Icons.explore_rounded),
                      color: Colors.white,
                    ),
                    IconButton(
                      iconSize: 24,
                      onPressed: () {},
                      icon: const Icon(Icons.home),
                      color: Colors.white,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          right: 10,
                          bottom: 3,
                          child: Container(
                            width: 20,
                            height: 4,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          iconSize: 24,
                          onPressed: () {},
                          icon: const Icon(Icons.mark_chat_unread),
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
            // end bottom nav
          ],
        ),
        floatingActionButton:
            // start floating button
            Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 218, 65, 103),
            child: const Icon(Icons.headset_mic),
          ),
        ),
        // end floating button
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
