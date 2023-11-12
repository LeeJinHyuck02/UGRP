import 'package:flutter/material.dart';
import 'package:prototype_2/part/part2.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/screen/homescreen.dart';
import 'package:prototype_2/screen/location.dart';

class Part1 extends StatefulWidget {
  final int sessionid;
  final String store_name;
  final int location_id;
  final int current_order;
  final int fianl_order;
  final int final_time;
  final DateTime create_time;
  final int membernum;
  final List menu;

  const Part1({
    super.key,
    required this.sessionid,
    required this.store_name,
    required this.location_id,
    required this.current_order,
    required this.fianl_order,
    required this.final_time,
    required this.create_time,
    required this.membernum,
    required this.menu,
  });

  @override
  State<Part1> createState() => _Part1State();
}

class _Part1State extends State<Part1> {
  String currentlocation = '체인지업 그라운드';
  List userorder = [];
  List store = [];

  var menunum = [];

  int calorder2() {
    int a = 0;
    List temp = [];

    userorder = [];

    for (int i = 0; i < widget.menu.length; i++) {
      temp = [];
      if (menunum[i] == 0) {
      } else {
        temp.add(widget.menu[i]);
        temp.add(menunum[i]);

        userorder.addAll(temp);

        a++;
      }
    }

    return a;
  }

  @override
  void initState() {
    menunum = List<int>.filled(widget.menu.length, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            session_info(
              sessionid: widget.sessionid,
              store_name: widget.store_name,
              location_id: widget.location_id,
              current_order: widget.current_order,
              fianl_order: widget.fianl_order,
              final_time: widget.final_time,
              create_time: widget.create_time,
              membernum: widget.membernum,
            ),
            const SizedBox(
              height: 8,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.menu.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 80,
                  width: 20,
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: secondColor,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(20, 20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SizedBox(
                                child: Text(
                                  widget.menu[index]['menu'],
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: secondColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    child: Text(
                                      '${widget.menu[index]['price']} 원',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  if (menunum[index] == 9) {
                                  } else {
                                    setState(() {
                                      menunum[index]++;
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: secondColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 17),
                            Text(
                              '${menunum[index]}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 75, 75, 75),
                              ),
                            ),
                            const SizedBox(width: 17),
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  if (menunum[index] == 0) {
                                  } else {
                                    setState(() {
                                      menunum[index]--;
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: secondColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, backgroundColor: secondColor),
              onPressed: () async {
                int cal = calorder2();

                store = await loadastore(widget.store_name);

                Navigator.of(context).push(
                  SwipeablePageRoute(
                    canOnlySwipeFromEdge: true,
                    builder: (BuildContext context) => Part2(
                      userorder: userorder,
                      selectedgage: widget.store_name,
                      sessionid: widget.sessionid,
                      category: store[0]["category"],
                      finalorder: widget.fianl_order,
                      tip: store[0]["tip"],
                    ),
                  ),
                );
              },
              child: const Text(
                '다음',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
