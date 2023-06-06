import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  ChatDetailState createState() {
    return ChatDetailState();
  }
}

class ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  final List<String?> messages = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Detail',
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
                        padding: const EdgeInsets.fromLTRB(20, 8, 16, 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("PESAN",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800)),
                              IconButton(
                                  iconSize: 42,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/home');
                                  },
                                  icon: const Icon(Icons.home),
                                  color: Colors.white)
                            ]),
                      ),
                      // end top bar
                      Expanded(
                        // padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return buildChatBubble(messages[index]!, true);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
            // start text field
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 33, 79),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Ketik Pesan..',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  sendMessage(value);
                                  value = '';
                                });
                              },
                            ),
                          ),
                          // const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send_rounded),
                            onPressed: () {
                              setState(() {
                                sendMessage();
                              });
                            },
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )))
            // end text field
          ],
        ),
      ),
    );
  }

  void sendMessage([String? message]) {
    if (message != null && message.isNotEmpty) {
      messages.add(message);
    }

    _messageController.clear();
  }

  Widget buildChatBubble(String message, bool isUser) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color.fromARGB(255, 131, 33, 79)
                  : const Color.fromARGB(255, 218, 65, 103),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser
                    ? const Radius.circular(16)
                    : const Radius.circular(0),
                bottomRight: isUser
                    ? const Radius.circular(0)
                    : const Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: GoogleFonts.rubik(color: Colors.white),
            ),
          ),
        ));
  }
}
