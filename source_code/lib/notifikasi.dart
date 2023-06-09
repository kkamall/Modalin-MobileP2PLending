import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_besar/add_pinjaman.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);
  @override
  NotifikasiState createState() {
    return NotifikasiState();
  }
}

class NotifikasiState extends State<Notifikasi> {
  final textEditController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> dataList = [
    'data 1',
    'data 2',
    'data 3',
  ];

  // Controller buat text
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired action
      String username = _usernameController.text;
      String password = _passwordController.text;
      // Process the input data or perform other operations
      print('Submitted Name: $username');
      print('Submitted Name: $password');
    }
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("NOTIFIKASI",
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: //20 pixel ke semua arah
                      Text(
                    "Hari ini",
                    style: GoogleFonts.rubik(
                        fontSize: 14,
                        //fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: //20 pixel ke semua arah
                      Text(
                    "Minggu ini",
                    style: GoogleFonts.rubik(
                        fontSize: 14,
                        //fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),
                Card(
                  child: ListTile(
                    //contentPadding: EdgeInsets.all(10),
                    title: Text(
                      "PESAN  BARU: Jadi gimana pak?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "RENOVIN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(),
                    tileColor: Color(0xFF3D2645),
                    trailing: Text("10:00"),
                    isThreeLine: true,
                    dense: true,
                    onTap: () {},
                  ),
                ),

                /*
                Padding(
                padding: EdgeInsets.all(10),
                child: //20 pixel ke semua arah
                Text('Hari ini', textAlign: TextAlign.left,),
                
                ),
                */
                /*
                Text(
                  "Hari ini",
                  style: GoogleFonts.rubik(
                      fontSize: 14,
                      //fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                */
                /*
                Divider(
                  color: Colors.white,
                ),
                ListTile(
                  //contentPadding: EdgeInsets.all(10),
                  title: Text("PESAN  BARU: Jadi gimana pak?",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                                      fontSize: 12, 
                                      color: Colors.white, 
                                    ),
                  ),
                  subtitle: Text("RENOVIN",style: TextStyle(
                                      fontSize: 12, 
                                      color: Colors.white, 
                                    ),),
                  leading: CircleAvatar(),
                  
                  trailing: Text("10:00"),
                  isThreeLine: true,
                  onTap: (){},
                ),
                Divider(
                  color: Colors.white,
                ),
                ListTile(
                  //contentPadding: EdgeInsets.all(10),
                  title: Text("PESAN  BARU: Jadi gimana pak?",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                                      fontSize: 12, 
                                      color: Colors.white, 
                                    ),
                  ),
                  subtitle: Text("RENOVIN",style: TextStyle(
                                    fontSize: 12, 
                                      color: Colors.white, 
                                    ),),
                  leading: CircleAvatar(),
                  trailing: Text("10:00"),
                  isThreeLine: true,
                  onTap: (){},
                ),
                Divider(
                  color: Colors.white,
                ),
                */
              ],
            ),
          ),
        ),

        /*
        ListView.builder(  
          itemCount: dataList.length,
          itemBuilder: (context, index){
            return ListTile(
              //contentPadding: EdgeInsets.all(10),
                title: Text("PESAN  BARU: Jadi gimana pak?",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                                    fontSize: 12, 
                                    color: Colors.white, 
                                  ),
                ),
                subtitle: Text("RENOVIN",style: TextStyle(
                                    fontSize: 12, 
                                    color: Colors.white, 
                                  ),),
                leading: CircleAvatar(),
                tileColor: Color(0xFF3D2645),
                trailing: Text("10:00"),
                isThreeLine: true,
                dense: true,
                onTap: (){},
            );
          },

        ),
        */
      ),
    );
  }
}
