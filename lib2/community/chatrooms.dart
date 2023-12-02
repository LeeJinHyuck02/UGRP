import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/screen/homescreen.dart';
import 'package:prototype_2/screen/location.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/api.dart';
import 'package:prototype_2/assets/asset.dart';

import 'package:prototype_2/community/chat.dart';

class Chatrooms extends StatefulWidget {
  const Chatrooms({super.key});

  @override
  State<Chatrooms> createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  String currentlocation = '체인지업 그라운드';
  double pagewidth = 100;

  TextEditingController searchController = TextEditingController(text: '');

  List rooms = [];

  void waitforrooms() async {
    rooms = await loadrooms(); // TODO: userid 변경

    setState(() {});
  }

  @override
  void initState() {
    waitforrooms();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    pagewidth = MediaQuery.of(context).size.width - 30;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
                        onPressed: () {},
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondColor,
        elevation: 15,
        child: Icon(Icons.add, color: Colors.white),
        heroTag: null,
        onPressed: () {},
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
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
                  width: pagewidth,
                  height: 45,
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      hintText: '채팅방의 이름을 입력하세요',
                      hintStyle: TextStyle(
                        color: secondColor,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: secondColor,
                        size: 23,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (rooms.isEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로딩 중이다 인간!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  width: pagewidth + 30,
                  child: ListView.builder(
                    //shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: rooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            height: 85,
                            width: pagewidth + 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: SizedBox(
                                width: 280,
                                child: Text(
                                  rooms[index]["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        Chatscreen(
                                            chatid: rooms[index]["id"],
                                            name: rooms[index]["name"]),
                                  ),
                                );
                              },
                              // subtitle -> 채팅방 설명 기능
                              // trailing -> 인원 수 기능
                            ),
                          ),
                          Divider(
                            height: 0.2,
                            color: secondColor,
                            thickness: 0.7,
                            indent: 15,
                            endIndent: 15,
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
