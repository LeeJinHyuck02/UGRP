import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';

import 'package:prototype_2/screen/homescreen.dart';
import 'package:prototype_2/screen/location.dart';

import 'package:prototype_2/add/add3.dart';

class MenuScreen extends StatefulWidget {
  final String selectedgage;
  final List menu;
  final String category;
  final int finalorder;
  final int tip;

  MenuScreen(
      {super.key,
      required this.selectedgage,
      required this.menu,
      required this.category,
      required this.finalorder,
      required this.tip});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List userorder = [];

  String currentlocation = '체인지업 그라운드';
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

    print(userorder);

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
      backgroundColor: third,
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
            Container(
              child: Stack(
                children: <Widget>[
                  Card(
                    elevation: 0.5,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 75,
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 250,
                          height: 100,
                          child: Center(
                            child: Text(
                              widget.selectedgage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0 , 15, 0),
              child: ListView.builder(
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
                      elevation: 0.7,
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
                                  width: MediaQuery.of(context).size.width - 200,
                                  child: Text(
                                    widget.menu[index]['menu'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
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
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
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
                              const SizedBox(width: 12),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, backgroundColor: secondColor),
              onPressed: () {
                int cal = calorder2();
                Navigator.of(context).push(
                  SwipeablePageRoute(
                    canOnlySwipeFromEdge: true,
                    builder: (BuildContext context) => CheckScreen(
                        userorder: userorder,
                        selectedgage: widget.selectedgage,
                        category: widget.category,
                        finalorder: widget.finalorder,
                        tip: widget.tip),
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
