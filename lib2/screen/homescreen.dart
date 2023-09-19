import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../assets/asset.dart';
import '../assets/provider.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/screen/mapscreen.dart';
import 'package:prototype_2/screen/sessionscreen.dart';
import 'package:prototype_2/screen/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String currentlocation = '체인지업 그라운드'; // TODO: provider로 교체

  TextEditingController searchController = TextEditingController(text: '');
  PageController pageController = PageController(initialPage: 0);
  int currentpage = 0;
  String userid = '';

  List pages = ['a', 'b', 'c']; // TODO: 위젯 리스트로 교체

  double pagewidth = 300;
  double pageheight = 170;

  List sessions = [];

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    userid = context.watch<UserProvider>().userid;
    pagewidth = MediaQuery.of(context).size.width - 30;

    context.read<UserProvider>().inupdate(userid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  child: TextFormField(
                    controller: searchController,
                    onFieldSubmitted: (input) {
                      Navigator.of(context).push(
                        SwipeablePageRoute(
                          canOnlySwipeFromEdge: true,
                          builder: (BuildContext context) =>
                              SessionScreen(input: input),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: '먹고 싶은 메뉴를 검색하세요!',
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
              const SizedBox(height: 16),
              FutureBuilder(
                future: loadmysession(context.watch<UserProvider>().userid),
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
                          session_info(
                            store_name: snapshot.data?[0]["name"],
                            location_id: snapshot.data?[0]["location_id"],
                            current_order: snapshot.data?[0]["currentorder"],
                            fianl_order: snapshot.data?[0]["finalorder"],
                            final_time: snapshot.data?[0]["finaltime"],
                            create_time:
                                DateTime.parse(snapshot.data?[0]["create_time"]),
                            membernum: snapshot.data?[0]["membernum"],
                          ),
                          Text('${snapshot.data[0]["userorder"]}'),
                        ],
                      );
                    }
                  }
                },
              ),
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
                                color: secondColor,
                                width: 1,
                              ),
                            ),
                            child: Center(child: Text('${pages[index]}')),
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
                                      color: i == currentpage
                                          ? Colors.black87
                                          : secondColor,
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
              const SizedBox(height: 16),
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
                            builder: (BuildContext context) =>
                                const SessionScreen(input: ''),
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: pagewidth / 2 - 7.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: secondColor,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                            right: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Text('세션 검색'),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          SwipeablePageRoute(
                            canOnlySwipeFromEdge: true,
                            builder: (BuildContext context) =>
                                const MapScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: pagewidth / 2 - 7.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: secondColor,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                            right: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Text('지도 검색'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                // 추가 기능 버튼이 들어갈 버튼
                height: pageheight - 50,
                width: pagewidth + 10,
                alignment: Alignment.center,
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
                child: const Column(
                  children: [],
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
