import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:provider/provider.dart';

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
        onPressed: () {
          a = 100;
          Navigator.of(context).push(
            SwipeablePageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
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
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width - 30,
              child: ListView.builder(
                // reverse: true,
                itemCount: filteredboard.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.all(3),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        title: Text(
                          filteredboard[index]["title"], // 게시글 제목 부분
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          filteredboard[index]["text"], // 게시글 내용 부분
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
          'Create a New Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목을 입력하세요'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용을 입력하세요'),
            ),
            /*TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),*/
            ElevatedButton(
              onPressed: () {
                if (_titleController.text != '' &&
                    _contentController.text != '') {
                  addtexts(
                    userid,
                    _titleController.text,
                    _contentController.text,
                  );
                  
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Board(),
                    ),
                  );
                }
              },
              child: const Text('Save Post'),
            ),
          ],
        ),
      ),
    );
  }
}
