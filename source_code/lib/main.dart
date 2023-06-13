import 'package:flutter/material.dart';
import 'login.dart';
import 'registrasi.dart';
import 'profile_borrower.dart';
import 'verifikasi.dart';
import 'add_umkm.dart';
import 'profile_guest.dart';
import 'profile_investor.dart';
import 'home_guest.dart';
import 'chat-guest.dart';
import 'chat.dart';
import 'chat_detail.dart';
import 'home_lender.dart';
import 'home_borrower.dart';
import 'home_borrower_dapat_pinjaman.dart';
import 'notifikasi.dart';
import 'add_pinjaman.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MODALIN",
      routes: {
        "/login": (context) => Login(),
        "/registrasi": (context) => Registrasi(),
        "/profile_borrower": (context) => ProfileBorrower(),
        "/verifikasi": (context) => Verifikasi(),
        "/add_umkm": (context) => AddUmkm(),
        "/profile_guest": (context) => ProfileGuest(),
        "/profile_investor": (context) => ProfileInvestor(),
        "/aktivitas_guest": (context) => AktivitasGuest(),
        "/chat-guest": (context) => ChatGuest(),
        "/chat_guest": (context) => ChatGuest(),
        "/chat": (context) => ChatNotif(),
        "/chat_detail": (context) => ChatDetail(),
        "/notifikasi": (context) => Notifikasi(),
        "/explore": (context) => HomeScreen(),
        "/add_pinjaman": (context) => AddPinjaman(),
        "/home": (context) => Home(),
        "/home_borrower": (context) => HomeBorrower(),
        "/home_borrower_dapat_pinjaman": (context) =>
            HomeBorrowerDapatPinjaman(),
      },
      initialRoute: "/aktivitas_guest",
    );
  }
}
