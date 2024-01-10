import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/screen/location.dart';
import 'package:prototype_2/screen/homescreen.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List boards = [];
  List filteredboard = [];

  String currentlocation = '체인지업 그라운드';

  void waitforboard() async {
    boards = await loadboard('userid');
    filteredboard = boards.reversed.toList();
    setState(() {});
  }

  @override
  void initState() {
    waitforboard();

    super.initState();
  }

  int a = 0;
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MM/dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (a == 100) {
      waitforboard();
      a = 0;
    }
    currentlocation = context.watch<UserProvider>().location;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          a = 100;
          Navigator.of(context).push(
            SwipeablePageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width - 30,
              child: ListView.builder(
                // reverse: true,
                itemCount: filteredboard.length,
                itemBuilder: (context, index) {
                  String a = formatDateTime(
                      DateTime.parse(filteredboard[index]["create_time"]));
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    margin: const EdgeInsets.all(3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 80,
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          filteredboard[index]["title"], // 게시글 제목 부분
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: SizedBox(
                          height: 40,
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredboard[index]["text"],
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                // 게시글 내용 부분
                              ),
                              Text(
                                a,
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            SwipeablePageRoute(
                              canOnlySwipeFromEdge: true,
                              builder: (BuildContext context) => Boarddetail(
                                board_id: filteredboard[index]["id"],
                                board_title: filteredboard[index]["title"],
                                board_text: filteredboard[index]["text"],
                                board_name: filteredboard[index]["name"],
                                create_time: DateTime.parse(
                                    filteredboard[index]["create_time"]),
                                userid: "",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Post {
  String title;
  String content;
  String author;
  DateTime dateTime;

  Post(
      {required this.title,
      required this.content,
      required this.author,
      required this.dateTime});
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  String userid = 'ww';

  @override
  Widget build(BuildContext context) {
    userid = context.watch<UserProvider>().userid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '새글 작성',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: TextField(
                      controller: _titleController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        hintText: '제목을 입력하세요',
                        border: InputBorder.none,
                        counterText:'',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: TextField(
                      maxLength: 10,
                      controller: _authorController,
                      decoration: const InputDecoration(
                        hintText: '이름을 입력하세요',
                        border: InputBorder.none,
                        counterText:'',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: TextField(
                      maxLines: null,
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: '내용을 입력하세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Background color
                  ),
                  onPressed: () {
                    if (_titleController.text != '' &&
                        _contentController.text != '' &&
                        _authorController.text != '') {
                      addtexts(userid, _titleController.text,
                          _contentController.text, _authorController.text);

                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Board(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    '작성 완료',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
