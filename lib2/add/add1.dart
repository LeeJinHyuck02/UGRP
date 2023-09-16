import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:prototype_2/assets/api.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';

import 'package:prototype_2/screen/homescreen.dart';
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

  String selectedgage = '';

  String dropdownValue = '전체';
  String search = '';
  TextEditingController searchController = TextEditingController();

  void runFilter(String keyword) {
    List results = [];
    if (keyword == '전체') {
      results = store;
    } else {
      results = store
          .where(
            (user) => user["category"].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();
    }

    setState(() {
      filteredstore = results;
    });
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
                          onPressed: () {},
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
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
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
                            runFilter(dropdownValue);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (Search) {
                        setState(() {
                          search = searchController.text;
                          // Call a function to filter the data based on the search text
                          // runSearch(search);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: '먹고 싶은 메뉴를 검색하세요!',
                        prefixIcon: Icon(Icons.search),
                        //prefixIconColor: Color.fromARGB(200, 200, 1, 80),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 104, 104, 104),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          /*borderSide: BorderSide(
                                color: Color.fromARGB(200, 200, 1, 80),
                            ),*/
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (store.isEmpty)
            const Expanded(
              child: Center(
                child: SpinKitFadingCircle(
                  // FadingCube 모양 사용
                  color: Color.fromARGB(200, 200, 1, 80), // 색상 설정
                  size: 50.0, // 크기 설정
                  duration: Duration(seconds: 2), //속도 설정
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                // items 변수에 저장되어 있는 모든 값 출력
                itemCount: filteredstore.length,
                itemBuilder: (BuildContext context, int index) {
                  // 검색 기능, 검색어가 있을 경우
                  if (search.isNotEmpty &&
                      (!filteredstore[index]["menu"]
                              .toString()
                              .toLowerCase()
                              .contains(search.toLowerCase()) &&
                          !filteredstore[index]["name"]
                              .toString()
                              .toLowerCase()
                              .contains(search.toLowerCase()))) {
                    return const SizedBox.shrink();
                  }
                  // 검색어가 없을 경우, 모든 항목 표시
                  else {
                    return Container(
                      height: 85,
                      width: 180,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: secondColor,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(20, 20))),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: SizedBox(
                            width: 240,
                            child: Text(
                              filteredstore[index]["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
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
                                builder: (BuildContext context) => MenuScreen(
                                    selectedgage: selectedgage, menu: menu),
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
                    );
                  }
                },
              ),
            )
        ],
      ),
    );
  }
}
