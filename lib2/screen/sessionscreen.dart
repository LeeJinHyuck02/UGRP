import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/api.dart';
import 'package:prototype_2/assets/provider.dart';

import 'homescreen.dart';
import 'location.dart';
import 'package:prototype_2/add/add1.dart';

class SessionScreen extends StatefulWidget {
  final String input;
  final String userid;
  final double latitude;
  final double longitude;

  const SessionScreen({
    Key? key,
    required this.input,
    required this.userid,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  SessionScreenstate createState() => SessionScreenstate();
}

class SessionScreenstate extends State<SessionScreen> {
  String currentlocation = '체인지업 그라운드'; // TODO: provider로 교체
  double pagewidth = 100;

  List menu = [];

  List sessions = [];
  List filteredSessions = [];

  TextEditingController searchController = TextEditingController(text: '');

  bool search(List menu, String store, String key) {
    for (int i = 0; i < menu.length; i++) {
      if (store == menu[i]["name"]) {
        if (menu[i]["menu"]
            .toString()
            .toLowerCase()
            .contains(key.toLowerCase())) {
          return true;
        }
      } else {}
    }
    return false;
  }

  bool searching(List ssesions, List mmenu, String key) {
    List result = [];

    if (key.isEmpty) {
      return true;
    }

    for (int i = 0; i < ssesions.length; i++) {
      if (ssesions[i]["name"]
              .toString()
              .toLowerCase()
              .contains(key.toLowerCase()) ||
          search(mmenu, ssesions[i]["name"], key)) {
        result.add(ssesions[i]);
      }
    }

    filteredSessions = result;

    if (filteredSessions.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void waitforsessions() async {
    sessions = await loadsessions(
      widget.userid,
      widget.latitude,
      widget.longitude,
    );
    filteredSessions = sessions;
    setState(() {});
  }

  @override
  void initState() {
    searchController.text = widget.input;

    waitforsessions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    pagewidth = MediaQuery.of(context).size.width - 30;
    menu = context.watch<Menu>().menu;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
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
                          color: third,
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
                              color: third,
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
                          color: third,
                          size: 23,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu,
                          color: third,
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
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            SwipeablePageRoute(
              canOnlySwipeFromEdge: true,
              builder: (BuildContext context) => const StoreScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    // const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: third,
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
                          onSubmitted: (search) {
                            searchController.text = search;

                            setState(() {
                              waitforsessions();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: '먹고 싶은 메뉴를 검색하세요!',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
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
                      height: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (sessions.isEmpty)
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
                  width: pagewidth,
                  child: searching(sessions, menu, searchController.text)
                      ? RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () async {
                            setState(() {
                              searchController.text = '';
                              waitforsessions();
                            });
                          },
                          child: ListView.builder(
                            //shrinkWrap: true,
                            //physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredSessions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return session_info(
                                sessionid: filteredSessions[index]["id"],
                                store_name: filteredSessions[index]["name"],
                                location_id: filteredSessions[index]
                                    ["location_id"],
                                current_order: filteredSessions[index]
                                    ["currentorder"],
                                fianl_order: filteredSessions[index]
                                    ["finalorder"],
                                final_time: filteredSessions[index]
                                    ["finaltime"],
                                create_time: DateTime.parse(
                                    filteredSessions[index]["create_time"]),
                                membernum: filteredSessions[index]["membernum"],
                              );
                            },
                          ),
                        )
                      : RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () async {
                            setState(() {
                              searchController.text = '';
                              waitforsessions();
                            });
                          },
                          child: ListView(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height - 150,
                                width: pagewidth,
                                child: const Text('조건에 맞는 세션이 없습니다.'),
                              ),
                            ],
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
