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

class ChatNotif extends StatefulWidget {
  const ChatNotif({Key? key}) : super(key: key);

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<ChatNotif> {
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
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/notifikasi');
                                      },
                                      icon: const Icon(Icons.notifications),
                                      color: Colors.white),
                                  IconButton(
                                      iconSize: 38,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/profile_investor');
                                      },
                                      icon: const Icon(Icons.account_circle),
                                      color: Colors.white)
                                ],
                              ),
                            ]),
                      ),
                      // end top bar
                      // start button filter chat
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        textStyle: GoogleFonts.outfit(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          flag = 0;
                                        });
                                      },
                                      child: const Text("Semua"),
                                    ),
                                    flag == 0
                                        ? Container(
                                            height: 5,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  255, 218, 65, 103),
                                            ),
                                          )
                                        : Container(
                                            height: 5,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  0, 218, 65, 103),
                                            ))
                                  ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        textStyle: GoogleFonts.outfit(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          flag = 1;
                                        });
                                      },
                                      child: const Text("Belum Terbaca"),
                                    ),
                                    flag == 1
                                        ? Container(
                                            height: 5,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  255, 218, 65, 103),
                                            ),
                                          )
                                        : Container(
                                            height: 5,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  0, 218, 65, 103),
                                            ))
                                  ]),
                            ],
                          )),
                      // end button filter chat
                      flag == 0
                          // start listview builder all chat
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: listChat.length,
                              itemBuilder: (contextListChat, index) {
                                return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/chat_detail',
                                            arguments: 1);

                                        // print('pressed');
                                      },
                                      child: Container(
                                          width: 308,
                                          height: 42,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 218, 65, 103),
                                              )),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      14, 0, 14, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: ClipOval(
                                                          child: Image.asset(
                                                            'assets/images/${listChat[index].foto}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )),
                                                  ),
                                                  Text(
                                                    listChat[index].nama,
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 0, 12, 0),
                                                    child: Text(
                                                      listChat[index].lastChat,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                  ),
                                                  listChat[index].chat > 0
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  218,
                                                                  65,
                                                                  103)),
                                                          child: Text(
                                                            listChat[index]
                                                                .chat
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .rubik(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ))
                                                      : const SizedBox()
                                                ],
                                              ))),
                                    ));
                              })
                          // end listview builder all chat
                          // start listview builder unread chat
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: listChat.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 6),
                                    child: listChat[index].chat > 0
                                        ? Container(
                                            width: 308,
                                            height: 42,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromARGB(
                                                      255, 218, 65, 103),
                                                )),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 0, 14, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: SizedBox(
                                                          width: 24,
                                                          height: 24,
                                                          child: ClipOval(
                                                            child: Image.asset(
                                                              'assets/images/${listChat[index].foto}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                    ),
                                                    Text(
                                                      listChat[index].nama,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 0, 12, 0),
                                                      child: Text(
                                                        listChat[index]
                                                            .lastChat,
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                218,
                                                                65,
                                                                103)),
                                                        child: Text(
                                                          listChat[index]
                                                              .chat
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.rubik(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                          ),
                                                        ))
                                                  ],
                                                )))
                                        : const SizedBox());
                              }),
                      // end listview builder unread chat
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/explore');
                      },
                      icon: const Icon(Icons.explore_rounded),
                      color: Colors.white,
                    ),
                    IconButton(
                      iconSize: 24,
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
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
