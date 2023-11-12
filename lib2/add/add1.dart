import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/api.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';

import 'package:prototype_2/screen/homescreen.dart';
import 'package:prototype_2/screen/location.dart';

import 'package:prototype_2/add/add2.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List store = [];
  List filteredstore = [];
  String currentlocation = '체인지업 그라운드';

  List menu = [];
  List allmune = [];

  String selectedgage = '';

  double pagewidth = 0;

  String dropdownValue = '전체';
  String search = '';
  TextEditingController searchController = TextEditingController();

  List runFilter(String keyword) {
    List results = [];
    if (keyword == '전체') {
      results = filteredstore;
    } else {
      results = filteredstore
          .where(
            (user) => user["category"].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();
    }

    return results;
  }

  bool _search(List menu, String store, String key) {
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
      setState(() {
        filteredstore = store;
        filteredstore = runFilter(dropdownValue);
      });
      return true;
    }

    filteredstore = store;
    filteredstore = runFilter(dropdownValue);

    for (int i = 0; i < filteredstore.length; i++) {
      if (filteredstore[i]["name"]
              .toString()
              .toLowerCase()
              .contains(key.toLowerCase()) ||
          _search(mmenu, filteredstore[i]["name"], key)) {
        result.add(filteredstore[i]);
      }
    }

    filteredstore = result;

    setState(() {});

    if (filteredstore.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void waitforstores() async {
    store = await loadstore();
    filteredstore = store;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    waitforstores();
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    menu = context.watch<Menu>().menu;
    pagewidth = MediaQuery.of(context).size.width - 15;

    filteredstore = runFilter(dropdownValue);
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
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(30),
                              underline: Container(),
                              dropdownColor: Colors.white,
                              focusColor: Colors.transparent,
                              value: dropdownValue,
                              items: <String>[
                                '전체',
                                '한식',
                                '중식',
                                '일식',
                                '양식',
                                '분식',
                                '야식',
                                '아시안',
                                '디저트'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        // color: Color.fromARGB(200, 200, 1, 80),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  searching(store, menu, search);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 45,
                        width: pagewidth - 110,
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
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            onChanged: (Search) {
                              setState(() {
                                search = searchController.text;
                              });
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
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print('Horizontal Container $index clicked');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 6.0), // 버튼 간격 조절
                            child: ElevatedButton(
                              onPressed: () {
                                print('Horizontal Container $index clicked');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 55.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Item $index'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            if (store.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height - 240,
                child: const Center(
                  child: SpinKitFadingCircle(
                    color: Color.fromARGB(200, 200, 1, 80), // 색상 설정
                    size: 50.0, // 크기 설정
                    duration: Duration(seconds: 2), //속도 설정
                  ),
                ),
              )
            else
              searching(store, menu, searchController.text)
                  ? RefreshIndicator(
                      color: primaryColor,
                      onRefresh: () async {
                        setState(() {
                          searchController.text = '';
                          waitforstores();
                        });
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredstore.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                height: 85,
                                width: pagewidth + 25,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: SizedBox(
                                    width: 240,
                                    child: Text(
                                      filteredstore[index]["name"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () async {
                                    selectedgage = filteredstore[index]["name"];
                                    menu = await loadmenu(selectedgage);
                                    Navigator.of(context).push(
                                      SwipeablePageRoute(
                                        canOnlySwipeFromEdge: true,
                                        builder: (BuildContext context) =>
                                            MenuScreen(
                                                selectedgage: selectedgage,
                                                menu: menu,
                                                category:
                                                    filteredstore[index]
                                                        ["category"],
                                                finalorder: filteredstore[index]
                                                    ["finalorder"],
                                                tip: filteredstore[index]
                                                    ["tip"]),
                                      ),
                                    );
                                  },
                                  subtitle: Text(
                                      '대표 메뉴: ${filteredstore[index]['menu']}',
                                      maxLines: 1),
                                  trailing: Text(
                                    '${filteredstore[index]['category']}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
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
                    )
                  : RefreshIndicator(
                      color: primaryColor,
                      onRefresh: () async {
                        setState(() {
                          searchController.text = '';
                          waitforstores();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height - 240,
                        width: pagewidth,
                        child: const Text('조건에 맞는 세션이 없습니다.'),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
