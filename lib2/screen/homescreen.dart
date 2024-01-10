import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/community/board.dart';
import 'package:prototype_2/community/chatrooms.dart';

import 'package:prototype_2/screen/mapscreen.dart';
import 'package:prototype_2/screen/sessionscreen.dart';
import 'package:prototype_2/screen/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String currentlocation = '체인지업 그라운드'; //

  TextEditingController searchController = TextEditingController(text: '');
  PageController pageController = PageController(initialPage: 0);
  int currentpage = 0;
  String userid = '';

  double pagewidth = 300;
  double pageheight = 170;

  double latitude = 0;
  double longitude = 0;

  List sessions = [];
  List spots = [];
  int locationid = 0;

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    locationid = context.watch<UserProvider>().locationid - 1;
    userid = context.watch<UserProvider>().userid;
    pagewidth = MediaQuery.of(context).size.width - 30;

    context.read<UserProvider>().inupdate(userid);
    spots = context.watch<Spots>().spots;

    latitude = spots[locationid]["latitude"];
    longitude = spots[locationid]["longitude"];

    List<Widget> pages = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: SizedBox(
          height: pagewidth - 90,
          width: pagewidth - 40,
          child: Image.asset(
            'images/official.png',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: SizedBox(
          height: pagewidth - 90,
          width: pagewidth - 40,
          child: Image.asset(
            'images/event.png',
          ),
        ),
      ),
      SizedBox(
        height: pagewidth / 2 - 20,
        width: pagewidth / 2 - 7.5,
        child: Image.asset(
          'images/official.png',
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                            color: third,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(30),
                            right: Radius.circular(30),
                          ),
                        ),
                        width: pagewidth,
                        height: 45,
                        child: TextFormField(
                          controller: searchController,
                          onFieldSubmitted: (input) {
                            Navigator.of(context).push(
                              SwipeablePageRoute(
                                canOnlySwipeFromEdge: true,
                                builder: (BuildContext context) =>
                                    SessionScreen(
                                  input: input,
                                  userid: userid,
                                  latitude: latitude,
                                  longitude: longitude,
                                ),
                              ),
                            );
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
              const SizedBox(height: 8),
              FutureBuilder(
                future: loadmysession(userid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 0,
                    );
                  } else {
                    List a = snapshot.data as List;
                    if (a.isEmpty) {
                      return const SizedBox(
                        height: 0,
                      );
                    } else {
                      return Column(
                        children: [
                          Mysession(
                            sessionid: snapshot.data?[0]["id"],
                            storename: snapshot.data?[0]["name"],
                            locationid: snapshot.data?[0]["location_id"],
                            currentorder: snapshot.data?[0]["currentorder"],
                            fianlorder: snapshot.data?[0]["finalorder"],
                            finaltime: snapshot.data?[0]["finaltime"],
                            createtime: DateTime.parse(
                                snapshot.data?[0]["create_time"]),
                            membernum: snapshot.data?[0]["membernum"],
                            userorder: snapshot.data[1]["userorder"],
                            info: snapshot.data,
                          )
                        ],
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                // 이미지나 추천 세션 보여주는 container
                height: pageheight,
                width: pagewidth + 10,
                alignment: Alignment.center,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: pages.length,
                  onPageChanged: (page) {
                    setState(() {
                      currentpage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Stack(
                        children: [
                          Container(
                            height: pageheight,
                            width: pagewidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Center(child: pages[index]),
                          ),
                          SizedBox(
                            // 점으로 된 페이지 표시 기능
                            height: pageheight,
                            width: pagewidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (num i = 0; i < pages.length; i++)
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(3, 0, 3, 8),
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 0.7,
                                      ),
                                      color: i == currentpage
                                          ? secondColor
                                          : Colors.white,
                                    ),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          SwipeablePageRoute(
                            canOnlySwipeFromEdge: true,
                            builder: (BuildContext context) => SessionScreen(
                              input: '',
                              userid: userid,
                              latitude: latitude,
                              longitude: longitude,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: pagewidth / 2 - 20,
                        width: pagewidth / 2 - 7.5,
                        child: Image.asset(
                          'images/map.png',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          SwipeablePageRoute(
                            canOnlySwipeFromEdge: true,
                            builder: (BuildContext context) =>
                                MapScreen(userid: userid),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: pagewidth / 2 - 20,
                        width: pagewidth / 2 - 7.5,
                        child: Image.asset(
                          'images/search.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  // 추가 기능 버튼이 들어갈 버튼
                  height: pageheight - 50,
                  width: pagewidth + 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                      right: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        const Chatrooms(),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Image(
                                  image: AssetImage('images/chat.png'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) => Board(),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Image(
                                  image: AssetImage('images/board.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 500,
              )
            ],
          ),
        ),
      ),
    );
  }
}
