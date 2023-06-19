import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Pendanaan {
  String foto_profile = "";
  String nama_umkm = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";
  String waktu_transaksi = "";
  String judul_pinjaman = "";

  Pendanaan({
    required this.foto_profile,
    required this.nama_umkm,
    required this.jumlah_pinjaman,
    required this.return_keuntungan,
    required this.lama_pinjaman,
    required this.waktu_transaksi,
    required this.judul_pinjaman,
  });
}

class ListPendanaanModel {
  List<Pendanaan> listPendanaanModel = <Pendanaan>[];
  String total_pengeluaran = "";
  ListPendanaanModel(
      {required this.listPendanaanModel, required this.total_pengeluaran});
}

class ListPendanaanCubit extends Cubit<ListPendanaanModel> {
  ListPendanaanCubit()
      : super(
            ListPendanaanModel(listPendanaanModel: [], total_pengeluaran: ""));

  static Future<String> formatDateTime(String dateTimeString) async {
    DateTime dateTime = DateTime.parse(dateTimeString);

    await initializeDateFormatting('id_ID', null);

    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }

  void setFromJson(Map<String, dynamic> json) async {
    var data = json["data"];
    List<Pendanaan> listPendanaanModel = <Pendanaan>[];
    num total_pengeluaran_int = 0;

    for (var val in data) {
      // Tanggal Pengajuan
      String dateTimeWaktuTransaksi = val[5];
      String stringWaktuTransaksi = await formatDateTime(
          dateTimeWaktuTransaksi); // Panggil sebagai method statis
      total_pengeluaran_int += val[2].toInt();

      var foto_profile = val[0];
      var nama_umkm = val[1];
      var jumlah_pinjaman = (val[2]).toString();
      var return_keuntungan = (val[3]).toString();
      var lama_pinjaman = (val[4]).toString();
      var waktu_transaksi = stringWaktuTransaksi;
      var judul_pinjaman = val[6].toString();
      listPendanaanModel.add(Pendanaan(
        foto_profile: foto_profile,
        nama_umkm: nama_umkm,
        jumlah_pinjaman: jumlah_pinjaman,
        return_keuntungan: return_keuntungan,
        lama_pinjaman: lama_pinjaman,
        waktu_transaksi: waktu_transaksi,
        judul_pinjaman: judul_pinjaman,
      ));
    }
    String total_pengeluaran = total_pengeluaran_int.toString();
    emit(ListPendanaanModel(
        listPendanaanModel: listPendanaanModel,
        total_pengeluaran: total_pengeluaran));
  }

  void fetchData(id_user, jenis) async {
    String urlHistoryPendanaan = "";
    if (jenis == "PENGELUARAN") {
      urlHistoryPendanaan = "http://127.0.0.1:8000/history_pengeluaran_lender/";
    } else {
      urlHistoryPendanaan = "http://127.0.0.1:8000/history_pemasukan_lender/";
    }
    final response = await http.get(Uri.parse(urlHistoryPendanaan + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class Riwayat extends StatefulWidget {
  @override
  State<Riwayat> createState() => _HomeState();
}

class _HomeState extends State<Riwayat> {
  int flag = 0;
  String jenis = "";
  String total = "";
  String id_user = "";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id_user = arguments['id_user'] as String;
    jenis = arguments['jenis'] as String;
    total = arguments['total'] as String;
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListPendanaanCubit>(
            create: (BuildContext context) => ListPendanaanCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Hello App',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: BlocBuilder<ListPendanaanCubit, ListPendanaanModel>(
                builder: (contextListPendanaan, listPendanaan) {
              contextListPendanaan
                  .read<ListPendanaanCubit>()
                  .fetchData(id_user, jenis);
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF3D2645),
                        Color(0xFF000000)
                      ], // Replace with your desired colors
                      begin: Alignment
                          .topCenter, // Define the gradient starting point
                      end: Alignment
                          .bottomCenter, // Define the gradient ending point
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(26, 20, 26, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("RIWAYAT",
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700)),
                            Row(
                              children: [
                                IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/home');
                                    },
                                    icon: const Icon(Icons.home),
                                    color: Colors.white)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              jenis,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Rp$total",
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: jenis == "PEMASUKAN"
                              ? Text("Untung dari Investasi",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                              : Text("Investasi",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  listPendanaan.listPendanaanModel.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15.0,
                                            child: ClipOval(
                                              child: Image.asset(
                                                '/images/${listPendanaan.listPendanaanModel[index].foto_profile}',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Text(
                                            'RENOVIN',
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 9.0),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          '${listPendanaan.listPendanaanModel[index].nama_umkm} - ${listPendanaan.listPendanaanModel[index].judul_pinjaman}',
                                          style: GoogleFonts.rubik(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Tanggal Transaksi: ${listPendanaan.listPendanaanModel[index].waktu_transaksi}',
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w200,
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 7.0),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Lama Pinjaman: ${listPendanaan.listPendanaanModel[index].lama_pinjaman} bulan',
                                              style: GoogleFonts.rubik(
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Jumlah Pinjaman: Rp${listPendanaan.listPendanaanModel[index].jumlah_pinjaman}',
                                              style: GoogleFonts.rubik(
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Persentase Return: ${listPendanaan.listPendanaanModel[index].return_keuntungan}%',
                                              style: GoogleFonts.rubik(
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: jenis == "PEMASUKAN"
                                                ? Text(
                                                    'Keuntungan: Rp' +
                                                        (int.parse(listPendanaan
                                                                    .listPendanaanModel[
                                                                        index]
                                                                    .jumlah_pinjaman) *
                                                                int.parse(listPendanaan
                                                                    .listPendanaanModel[
                                                                        index]
                                                                    .return_keuntungan) /
                                                                100)
                                                            .toString(),
                                                    style: GoogleFonts.rubik(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : Text(
                                                    'Pengeluaran: Rp${listPendanaan.listPendanaanModel[index].jumlah_pinjaman}',
                                                    style: GoogleFonts.rubik(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
