import 'package:flutter/material.dart';
import 'package:tugas_besar/data.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xFF3D2645),
      floating: true,
      leadingWidth: 200.0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 12.0),
        child: Text("MODALIN",
            style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700)),
      ),
      actions: [
        IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            color: Colors.white),
        IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: const Icon(Icons.person),
            color: Colors.white),
      ],
    );
  }
}
