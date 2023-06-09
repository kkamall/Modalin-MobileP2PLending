import 'package:flutter/material.dart';
import 'login.dart';
import 'registrasi.dart';
import 'profile_borrower.dart';
import 'verifikasi.dart';
import 'add_umkm.dart';
import 'profile_guest.dart';
import 'profile_investor.dart';
import 'aktivitas_guest.dart';
import 'chat-guest.dart';

void main() {
  runApp(MainRouting());
}

class MainRouting extends StatelessWidget {
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
      },
      initialRoute: "/chat_guest",
    );
  }
}
