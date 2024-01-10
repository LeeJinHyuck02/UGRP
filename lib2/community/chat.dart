import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/screen/location.dart';
import 'package:prototype_2/screen/homescreen.dart';

// import 'package:prototype_2/screen/loginscreen.dart';

class Chatscreen extends StatefulWidget {
  final int chatid;
  final String name;

  const Chatscreen({super.key, required this.chatid, required this.name});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  String currentlocation = '체인지업 그라운드';
  String userid = 'ww';

  TextEditingController con = TextEditingController();

  var userInput;

  List message = [];
  int a = 0;

  // final IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://172.20.10.3:3000');
  IO.Socket? socket;
  int chatID = 1;

  void sendMessage() {
    String message = con.text;
    if (message.isNotEmpty) {
      var body = {
        "message": userInput,
        "userid": userid,
        "chatID": chatID.toString(),
      };
      socket!.emit('send', jsonEncode(body));
      con.clear();
    }
  }

  void waitforchat() async {
    message = await loadbeforechat(widget.chatid);
    setState(() {});
  }

  @override
  void initState() {
    chatID = widget.chatid;
    
    super.initState();

    waitforchat();

    socket = IO.io(server, <String, dynamic>{
      "transports": ["websocket"],
      "autoconnect": false,
    });

    socket!.connect();

    var body = {
      "chatID": chatID.toString(),
    };

    socket!.emit('join', jsonEncode(body));

    socket!.on('get', (data) {
      Map<String,dynamic> jsonData = jsonDecode(data);
      message.add(jsonData);
    });
  }

  Stream<List> loadchat() async* {
    List messages = message;
    setState(() {});
    yield messages;
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    userid = context.watch<UserProvider>().userid;
    userid = 'ww';

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // body 위에 hover할 때의 색깔 지정
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: secondColor,
                            size: 23,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                SwipeablePageRoute(
                                  canOnlySwipeFromEdge: true,
                                  builder: (BuildContext context) =>
                                      const selectlocation(),
                                ),
                              );
                            },
                            child: Text(
                              currentlocation,
                              style: TextStyle(
                                color: secondColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.home_outlined,
                            color: secondColor,
                            size: 23,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            
                          },
                          icon: Icon(
                            Icons.menu,
                            color: secondColor,
                            size: 23,
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
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // message.add(snapshot.data);

              StreamBuilder(
                stream: loadchat(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data!;
                    data = data.reversed.toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              (index == data.length - 1) ||
                                      !(data[index]["userid"] ==
                                          data[index + 1]["userid"])
                                  ? Row(
                                      mainAxisAlignment:
                                          userid == data[index]["userid"]
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 20),
                                        Text(
                                          data[index]["userid"],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              Chatbubble(
                                isEnd: (index == 0) ||
                                    !(data[index]["userid"] ==
                                        data[index - 1]["userid"]),
                                message: data[index]["message"],
                                isSender: userid == data[index]["userid"],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 170,
                      child: Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    );
                  }
                },
              ),
              

              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 68,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: secondColor,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefix: SizedBox(width: 8),
                      ),
                      controller: con,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // sendchat(userid, con.text, 1);
                      userInput = con.text;
                      var body = {
                        "message": userInput,
                        "userid": userid,
                        "chatID": 2,
                      };
                      sendMessage();
                      // channel.sink.add((jsonEncode(body)).toString());

                      con.text = '';
                    },
                    icon: Icon(Icons.send, size: 25, color: primaryColor),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
StreamBuilder(
                stream: loadchat(1),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.reversed.toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              (index == data.length - 1) ||
                                      !(data[index]["userid"] ==
                                          data[index + 1]["userid"])
                                  ? Row(
                                      mainAxisAlignment:
                                          userid == data[index]["userid"]
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 20),
                                        Text(
                                          data[index]["userid"],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              Chatbubble(
                                isEnd: (index == 0) ||
                                    !(data[index]["userid"] ==
                                        data[index - 1]["userid"]),
                                message: data[index]["message"],
                                isSender: userid == data[index]["userid"],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 170,
                      child: Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    );
                  }
                },
              ),
              
              StreamBuilder(
                stream: loadchat(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return Text(snapshot.data![index]);
                        },
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: const Center(child: Text('조용합니다...')),
                    );
                  }
                },
              ),
*/