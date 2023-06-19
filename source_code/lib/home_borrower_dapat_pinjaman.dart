import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PinjamanModel {
  String judul_pinjaman;
  String tanggal_pengajuan;
  String jumlah_pinjaman;
  String return_keuntungan;
  String lama_pinjaman;
  String status;
  String nama_investor;
  String tanggal_investasi;
  String link_vidio;
  String tenggat_waktu;
  String total_pinjaman;
  String id_investasi;
  String id_investor;
  PinjamanModel({
    required this.judul_pinjaman,
    required this.tanggal_pengajuan,
    required this.jumlah_pinjaman,
    required this.return_keuntungan,
    required this.lama_pinjaman,
    required this.status,
    required this.nama_investor,
    required this.tanggal_investasi,
    required this.link_vidio,
    required this.tenggat_waktu,
    required this.total_pinjaman,
    required this.id_investasi,
    required this.id_investor,
  });
}

class PinjamanCubit extends Cubit<PinjamanModel> {
  String url = "http://127.0.0.1:8000/get_pinjaman/";

  PinjamanCubit()
      : super(PinjamanModel(
          judul_pinjaman: "",
          tanggal_pengajuan: "",
          jumlah_pinjaman: "",
          return_keuntungan: "",
          lama_pinjaman: "",
          status: "",
          nama_investor: "",
          tanggal_investasi: "",
          link_vidio: "",
          tenggat_waktu: "",
          total_pinjaman: "",
          id_investasi: "",
          id_investor: "",
        ));

  static Future<String> formatDateTime(String dateTimeString) async {
    DateTime dateTime = DateTime.parse(dateTimeString);

    await initializeDateFormatting('id_ID', null);

    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }

  //map dari json ke atribut
  void setFromJson(
      Map<String, dynamic> json,
      String nama_investor,
      String tanggal_investasi_dt,
      String id_investasi_dt,
      String id_investor_dt) async {
    // Tanggal Pengajuan
    String dateTimeTanggalPengajuan = json['tanggal_pengajuan'];
    String tanggal_pengajuan = await formatDateTime(
        dateTimeTanggalPengajuan); // Panggil sebagai method statis

    // Tanggal Investasi
    String tanggal_investasi = "";
    String tenggat_waktu = "";
    if (tanggal_investasi_dt != "") {
      String tanggalInvestasiString = tanggal_investasi_dt;
      tanggal_investasi = await formatDateTime(
          tanggalInvestasiString); // Panggil sebagai method statis

      // Perhitungan tenggat waktu
      int lama_pinjaman_int = json['lama_pinjaman'];
      DateTime dateTimeTanggalInvestasi =
          DateTime.parse(tanggalInvestasiString);
      DateTime dateTimeTenggatWaktu = DateTime(
          dateTimeTanggalInvestasi.year,
          dateTimeTanggalInvestasi.month + lama_pinjaman_int,
          dateTimeTanggalInvestasi.day,
          dateTimeTanggalInvestasi.hour,
          dateTimeTanggalInvestasi.minute,
          dateTimeTanggalInvestasi.second,
          dateTimeTanggalInvestasi.millisecond,
          dateTimeTanggalInvestasi.microsecond);
      tenggat_waktu = await formatDateTime(dateTimeTenggatWaktu.toString());
    }

    int return_pinjaman = json['jumlah_pinjaman'] +
        (json['return_keuntungan'] / 100 * json['jumlah_pinjaman']);

    String judul_pinjaman = json['judul_pinjaman'];
    String jumlah_pinjaman = json['jumlah_pinjaman'].toString();
    String return_keuntungan = json['return_keuntungan'].toString();
    String lama_pinjaman = json['lama_pinjaman'].toString();
    String status = json['status'];
    String link_vidio = json['link_vidio'];
    String total_pinjaman = return_pinjaman.toString();
    String id_investasi = id_investasi_dt;
    String id_investor = id_investor_dt;

    emit(PinjamanModel(
        judul_pinjaman: judul_pinjaman,
        tanggal_pengajuan: tanggal_pengajuan,
        jumlah_pinjaman: jumlah_pinjaman,
        return_keuntungan: return_keuntungan,
        lama_pinjaman: lama_pinjaman,
        status: status,
        nama_investor: nama_investor,
        tanggal_investasi: tanggal_investasi,
        tenggat_waktu: tenggat_waktu,
        link_vidio: link_vidio,
        total_pinjaman: total_pinjaman,
        id_investasi: id_investasi,
        id_investor: id_investor));
  }

  void fetchData(id_pinjaman) async {
    final response = await http.get(Uri.parse(url + id_pinjaman));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      // Mendapatkan nama investor & tanggal investasi pinjaman jika sudah dapat
      String nama_investor = "";
      String tanggal_investasi = "";
      String id_investasi = "";
      String id_investor = "";
      if (json['status'] == "Sedang") {
        String urlGetInvestorPinjaman =
            "http://127.0.0.1:8000/get_investor_pinjaman/";
        final response =
            await http.get(Uri.parse(urlGetInvestorPinjaman + id_pinjaman));
        List get_investor_pinjaman = jsonDecode(response.body);
        nama_investor = get_investor_pinjaman[5];
        tanggal_investasi = get_investor_pinjaman[1];
        id_investasi = (get_investor_pinjaman[0]).toString();
        id_investor = (get_investor_pinjaman[3]).toString();
      }

      setFromJson(
          json, nama_investor, tanggal_investasi, id_investasi, id_investor);
    } else {
      throw Exception('Gagal load');
    }
  }
}

// class untuk menampung data user
class Pengembalian {
  String foto_profile = "";
  String nama_umkm = "";
  String jumlah_pinjaman = "";
  String return_keuntungan = "";
  String lama_pinjaman = "";

  Pengembalian(
      {required this.foto_profile,
      required this.nama_umkm,
      required this.jumlah_pinjaman,
      required this.return_keuntungan,
      required this.lama_pinjaman});
}

class ListPengembalianModel {
  List<Pengembalian> listPengembalianModel = <Pengembalian>[];
  ListPengembalianModel({required this.listPengembalianModel});
}

class ListPengembalianCubit extends Cubit<ListPengembalianModel> {
  ListPengembalianCubit()
      : super(ListPengembalianModel(listPengembalianModel: []));

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pengembalian> listPengembalianModel = <Pengembalian>[];
    num flag = 0;
    for (var val in data) {
      if (flag < 3) {
        var foto_profile = val[0];
        var nama_umkm = val[1];
        var jumlah_pinjaman = (val[3] / 1000000).toString();
        var return_keuntungan = (val[4]).toString();
        var lama_pinjaman = (val[5]).toString();
        listPengembalianModel.add(Pengembalian(
            foto_profile: foto_profile,
            nama_umkm: nama_umkm,
            jumlah_pinjaman: jumlah_pinjaman,
            return_keuntungan: return_keuntungan,
            lama_pinjaman: lama_pinjaman));
        flag += 1;
      } else {
        break;
      }
    }
    emit(ListPengembalianModel(listPengembalianModel: listPengembalianModel));
  }

  void fetchData(id_user) async {
    String urlHistoryPengembalian =
        "http://127.0.0.1:8000/history_pengembalian_borrower/";
    final response =
        await http.get(Uri.parse(urlHistoryPengembalian + id_user));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class HomeBorrowerDapatPinjaman extends StatefulWidget {
  @override
  State<HomeBorrowerDapatPinjaman> createState() => _HomeState();
}

// class untuk menampung data pengeluaran
class Pengeluaran {
  String nama = "";
  String foto = "";
  String jumlah = "";
  String retur = "";
  String waktu = "";

  Pengeluaran(this.nama, this.foto, this.jumlah, this.retur, this.waktu);
}

class Pemasukan {
  String nama = "";
  String foto = "";
  String jumlah = "";

  Pemasukan(
    this.nama,
    this.foto,
    this.jumlah,
  );
}

class _HomeState extends State<HomeBorrowerDapatPinjaman> {
  int flag = 0;
  String? id_user = "";
  String id_pinjaman = "";

  List<Pengeluaran> listPengeluaran = [
    Pengeluaran("RENOVIN", "formal.png", "Rp 5jt", "8%", "3 bln"),
    Pengeluaran("KOPIKIRAN", "formal.png", "Rp 10jt", "6%", "6 bln"),
    Pengeluaran("KOKITA", "formal.png", "Rp 7jt", "10%", "1 thn"),
    Pengeluaran("KOKITA", "formal.png", "Rp 7jt", "10%", "1 thn")
  ];

  List<Pemasukan> listPemasukan = [
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
    Pemasukan("RENOVIN", "formal.png", "Rp 500.000"),
  ];

  late Future<int> respPost; //201 artinya berhasil
  String pembayaran = "http://127.0.0.1:8000/pembayaran/";
  String get_user = "http://127.0.0.1:8000/get_user/";
  String add_pengembalian = "http://127.0.0.1:8000/add_pengembalian/";
  String get_last_transaksi = "http://127.0.0.1:8000/getLastTransaksi/";

  Future<int> insertPembayaran(
      int jumlahUang, int id_investasi, int id_investor) async {
    //data disimpan di body
    DateTime now = DateTime.now();
    String waktuTransaksi = now.toString();

    final response = await http.post(
        Uri.parse(pembayaran + id_pinjaman + '/' + (id_investor).toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"jumlah_transaksi": $jumlahUang,
      "waktu_transaksi": "$waktuTransaksi",
      "id_user": $id_user} """);

    final responseGetLastTransaksi =
        await http.get(Uri.parse(get_last_transaksi + id_user.toString()));
    int id_transaksi = jsonDecode(responseGetLastTransaksi.body);

    final responsePengembalian = await http.post(Uri.parse(add_pengembalian),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: """
      {"id_investasi": $id_investasi,
      "id_transaksi": $id_transaksi,
      "id_user_lender": $id_investor,
      "id_user_borrower": $id_user} """);

    Navigator.pushNamed(context, '/home_borrower', arguments: id_user);

    return response.statusCode; //sukses kalau 201
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id_user = arguments['id_user'] as String;
    id_pinjaman = arguments['id_pinjaman'] as String;

    int saldo = 100;

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PinjamanCubit>(
            create: (BuildContext context) => PinjamanCubit(),
          ),
          BlocProvider<ListPengembalianCubit>(
            create: (BuildContext context) => ListPengembalianCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'MODALIN',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                BlocBuilder<PinjamanCubit, PinjamanModel>(
                    builder: (contextPinjaman, pinjaman) {
                  contextPinjaman.read<PinjamanCubit>().fetchData(id_pinjaman);
                  return BlocBuilder<ListPengembalianCubit,
                          ListPengembalianModel>(
                      builder: (contextPengembalian, pengembalian) {
                    contextPengembalian
                        .read<ListPengembalianCubit>()
                        .fetchData(id_user);
                    return SingleChildScrollView(
                      child: Container(
                        width: 360,
                        height: 970,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3D2645), Color(0xFF000000)],
                            begin: Alignment
                                .topCenter, //Define the gradient starting point
                            end: Alignment
                                .bottomCenter, //Define the gradient ending point
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(26, 20, 26, 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "HOME",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/notifikasi');
                                          },
                                          icon: const Icon(Icons.notifications),
                                          color: Colors.white),
                                      IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/profile_borrower',
                                                arguments: id_user);
                                          },
                                          icon: const Icon(Icons.person),
                                          color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                              // start saldo
                              Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 30,
                                      ),
                                      width: 240,
                                      height: 95,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 131, 33, 97),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Saldo Rp. 10.000.000",
                                            style: GoogleFonts.outfit(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Top Up",
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print('Icon pressed');
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 37,
                                              ),
                                              Container(
                                                width: 2,
                                                height: 35,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 37,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Withdraw",
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print('Icon pressed');
                                                    },
                                                    child: const Icon(
                                                      Icons.wallet_rounded,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // end saldo
                              // start status pinjaman
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Status Pinjaman",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height:
                                                  16, // Jarak antara status pinjaman dan gambar
                                            ),
                                            Container(
                                              width: 202, // Lebar gambar
                                              height: 114, // Tinggi gambar
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .grey, // Warna latar belakang gambar
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              //Tambahkan widget Image di sini untuk menampilkan gambar
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/thumbnail.png'), // Ganti dengan path gambar Anda
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height:
                                          16, // Jarak antara status gambar dan renovin
                                    ),
                                    Text(
                                      "${pinjaman.judul_pinjaman}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    //jarak
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "${pinjaman.tanggal_pengajuan}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Jumlah Pinjaman: Rp ${pinjaman.jumlah_pinjaman}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Persentase Return: ${pinjaman.return_keuntungan}%",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Lama Pinjaman: ${pinjaman.lama_pinjaman} bulan",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            pinjaman.status == "Sedang"
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Status : Sudah dapat Modal",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        "Investor : ${pinjaman.nama_investor}",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Status : Belum dapat Modal",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        "Investor : -",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        if (pinjaman.status == "Sedang") ...{
                                          Column(
                                            children: [
                                              Text(
                                                "${pinjaman.tanggal_investasi}",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              SizedBox(
                                                height: 20,
                                                width: 70,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFDA4167),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // Aksi yang ingin dilakukan saat tombol ditekan
                                                  },
                                                  child: Text(
                                                    'chat',
                                                    style: GoogleFonts.rubik(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        }
                                      ],
                                    ),
                                    if (pinjaman.status == "Sedang") ...{
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 18),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 131, 33, 97),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tenggat Waktu: ${pinjaman.tenggat_waktu}",
                                                  style: GoogleFonts.rubik(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  "Rp. ${pinjaman.total_pinjaman}",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                              width: 70,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFFDA4167),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  131,
                                                                  33,
                                                                  79),
                                                          content: SizedBox(
                                                            child: saldo > 100
                                                                ? Text(
                                                                    "Apakah Anda Yakin Ingin Membayar?",
                                                                    style: GoogleFonts.rubik(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )
                                                                : Text(
                                                                    "Oops.. Saldo Anda Tidak Mencukupi :(",
                                                                    style: GoogleFonts.rubik(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                          ),
                                                          actions: [
                                                            saldo > 100
                                                                ? ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      insertPembayaran(
                                                                          int.parse(pinjaman
                                                                              .total_pinjaman),
                                                                          int.parse(pinjaman
                                                                              .id_investasi),
                                                                          int.parse(
                                                                              pinjaman.id_investor));
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<
                                                                              Color>(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            218,
                                                                            65,
                                                                            103),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      "Yakin!",
                                                                      style: GoogleFonts.rubik(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<
                                                                              Color>(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            218,
                                                                            65,
                                                                            103),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      "Baik!",
                                                                      style: GoogleFonts.rubik(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: const Icon(Icons
                                                                  .cancel_outlined),
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  218,
                                                                  65,
                                                                  103),
                                                            ),
                                                          ],
                                                        );
                                                      } // end builder
                                                      ); // end showDialog
                                                },
                                                child: Text(
                                                  'Bayar',
                                                  style: GoogleFonts.rubik(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xFFFFFFFF),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                              ),

                              // end status pinjaman
                              // start pengeluaran
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                child: Container(
                                  width: 308,
                                  height: 190,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(65, 218, 65, 103),
                                            Color.fromARGB(65, 61, 38, 69)
                                          ])),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(18, 14, 18, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   "RIWAYAT TRANSAKSI",
                                        //   style: GoogleFonts.outfit(
                                        //       color: Colors.white,
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.w700),
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "RIWAYAT TRANSAKSI",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        pengembalian.listPengembalianModel
                                                    .length ==
                                                0
                                            ? Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "Nampaknya kamu belum menyelesaikan transaksi",
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Pinjaman",
                                                    style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: pengembalian
                                                        .listPengembalianModel
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 22,
                                                                      height:
                                                                          22,
                                                                      child:
                                                                          ClipOval(
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/${pengembalian.listPengembalianModel[index].foto_profile}',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 9,
                                                                  ),
                                                                  Text(
                                                                    "${pengembalian.listPengembalianModel[index].nama_umkm}",
                                                                    style: GoogleFonts
                                                                        .rubik(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        6,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  "Rp ${pengembalian.listPengembalianModel[index].jumlah_pinjaman}Jt | ${pengembalian.listPengembalianModel[index].return_keuntungan}% | ${pengembalian.listPengembalianModel[index].lama_pinjaman} bln",
                                                                  style:
                                                                      GoogleFonts
                                                                          .rubik(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  if (pengembalian
                                                          .listPengembalianModel
                                                          .length >
                                                      3) ...{
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "Lihat Lainnya",
                                                          style:
                                                              GoogleFonts.rubik(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                    )
                                                  }
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // end pengeluaran
                            ],
                          ),
                        ),
                      ),
                    ); // diem
                  });
                }),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child:
                      //box bawah
                      Container(
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
                          iconSize: 24,
                          onPressed: () {
                            Navigator.pushNamed(context, '/explore');
                          },
                          icon: const Icon(Icons.explore_rounded),
                          color: Colors.white,
                        ),
                        Stack(
                          children: [
                            IconButton(
                              iconSize: 24,
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              icon: const Icon(Icons.home),
                              color: Colors.white,
                            ),
                            Positioned(
                              top: 33,
                              right: 10,
                              left: 10,
                              bottom: 3,
                              child: Container(
                                width: 20,
                                height: 4,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat',
                                arguments: id_user);
                          },
                          icon: const Icon(Icons.mark_chat_unread),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: Stack(
              children: [
                Positioned(
                  bottom: 45,
                  right: 0,
                  child: Container(
                    width: 44,
                    height: 44,
                    child: FloatingActionButton(
                      onPressed: () {
                        // jika ditap
                      },
                      backgroundColor: const Color(0xFFDA4167),
                      child: const Icon(Icons.headset_mic),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
