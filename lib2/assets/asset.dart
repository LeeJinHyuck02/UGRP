import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:prototype_2/part/part1.dart';
import 'package:prototype_2/screen/mysessionscreen.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/api.dart';

Color primaryColor = const Color.fromARGB(255, 72, 209, 204);
Color secondColor = const Color.fromARGB(255, 72, 209, 205);
Color third = const Color.fromARGB(255, 255, 255, 255);

// const Color.fromARGB(240, 102, 102, 92);

String server = 'http://172.20.10.3:3000';
String websocket = 'ws://172.20.10.3:3000';

class _Session {
  String store_name;
  int location_id;
  int current_order;
  int fianl_order;
  int final_time;
  DateTime create_time;

  _Session(this.store_name, this.create_time, this.current_order,
      this.fianl_order, this.final_time, this.location_id);
}

class chat {
  DateTime create_time;
  String userid;
  String message;

  chat(this.create_time, this.userid, this.message);
}

class session_info extends StatefulWidget {
  final int sessionid;
  final String store_name;
  final int location_id;
  final int current_order;
  final int fianl_order;
  final int final_time;
  final DateTime create_time;
  final int membernum;

  session_info(
      {super.key,
      required this.sessionid,
      required this.store_name,
      required this.location_id,
      required this.current_order,
      required this.fianl_order,
      required this.final_time,
      required this.create_time,
      required this.membernum});

  @override
  State<session_info> createState() => _session_infoState();
}

class _session_infoState extends State<session_info> {
  double infowidth = 170;
  List menu = [];

  List<String> tags = ['이진혁 추천 맛집'];
  String location = '';

  @override
  Widget build(BuildContext context) {
    infowidth = MediaQuery.of(context).size.width - 30;
    location =
        context.watch<Spots>().spots[widget.location_id - 1]["name"].toString();
    return GestureDetector(
      onTap: () async {
        menu = await loadmenu(widget.store_name);

        Navigator.of(context).push(
          SwipeablePageRoute(
            canOnlySwipeFromEdge: true,
            builder: (BuildContext context) => Part1(
              sessionid: widget.sessionid,
              store_name: widget.store_name,
              location_id: widget.location_id,
              current_order: widget.current_order,
              fianl_order: widget.fianl_order,
              final_time: widget.final_time,
              create_time: widget.create_time,
              membernum: widget.membernum,
              menu: menu,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        width: infowidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.gps_fixed,
                        size: 18,
                      ),
                      Text(
                        ' $location',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < widget.membernum; i++)
                        const Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.black,
                        ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              '#${widget.sessionid} ${widget.store_name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            '주문 성사 까지 ${widget.fianl_order - widget.current_order} 원!',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TimerScreen(
                        final_time: widget.final_time,
                        create_time: widget.create_time,
                      )
                    ],
                  )
                ],
              ),
              tags.isEmpty
                  ? const SizedBox(
                      height: 0,
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            for (int i = 0; i < tags.length; i++)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '#${tags[i]}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
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
    );
  }
}

class TimerScreen extends StatefulWidget {
  final int final_time;
  final DateTime create_time;

  const TimerScreen(
      {super.key, required this.final_time, required this.create_time});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _duration = 50;
  int _initialduration = 15;

  DateTime now = DateTime.now();

  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    _duration = widget.final_time;
    _initialduration = now.difference(widget.create_time).inSeconds;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      height: 65,
      width: 65,
      child: Center(
        child: CircularCountDownTimer(
          duration: _duration * 60,
          initialDuration: _initialduration,
          controller: _controller,
          width: 80,
          height: 80,
          fillColor: primaryColor,
          ringColor: Colors.white,
          isReverse: true,
          isReverseAnimation: true,
          textFormat: CountdownTextFormat.MM_SS,
        ),
      ),
    );
  }
}

class Mysession extends StatefulWidget {
  final int sessionid;
  final String storename;
  final int locationid;
  final int currentorder;
  final int fianlorder;
  final int finaltime;
  final DateTime createtime;
  final int membernum;
  final List userorder;
  final List info;

  const Mysession({
    super.key,
    required this.sessionid,
    required this.storename,
    required this.locationid,
    required this.currentorder,
    required this.fianlorder,
    required this.finaltime,
    required this.createtime,
    required this.membernum,
    required this.userorder,
    required this.info,
  });

  @override
  State<Mysession> createState() => _MysessionState();
}

class _MysessionState extends State<Mysession>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  DateTime now = DateTime.now();

  int time = 15;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(minutes: (widget.finaltime * 60 - now.difference(widget.createtime).inSeconds) ~/ 60, seconds: (widget.finaltime * 60 - now.difference(widget.createtime).inSeconds) % 60), // 여기서 시간을 조절.
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.09).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    time = now.difference(widget.createtime).inSeconds; // 추후 작업 필요
    String location =
        context.watch<Spots>().spots[widget.locationid - 1]["name"].toString();
    double width = MediaQuery.of(context).size.width - 30;
    int minutes =
        (((_controller.duration?.inSeconds ?? 0) * (1 - _controller.value))
                    .round() /
                60)
            .floor();
    int seconds =
        ((_controller.duration?.inSeconds ?? 0) * (1 - _controller.value))
                .round() %
            60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SwipeablePageRoute(
            canOnlySwipeFromEdge: true,
            builder: (BuildContext context) => Mysessionscreen(
              info: widget.info,
              sessionid: widget.sessionid,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.7,
          ),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(16),
            right: Radius.circular(16),
          ),
        ),
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.gps_fixed,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                widget.storename,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.userorder.length ~/ 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color: Colors.black),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Text(
                            '  메뉴:  ${widget.userorder[index * 2]["menu"]}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '  가격:  ${widget.userorder[index * 2]["price"] * widget.userorder[index * 2 + 1]}원',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  LinearPercentIndicator(
                    lineHeight: 27.0,
                    width: width - 35,
                    percent: _animation.value,
                    barRadius: const Radius.circular(16),
                    backgroundColor: Colors.white,
                    progressColor: secondColor,
                    center: Text(
                      '$formattedMinutes 분 $formattedSeconds 초',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w300),
                    ),
                  ),
                  if (_animation.value <= 0.09) ...[
                    const Positioned(
                      left: 10, // 체크표시 아이콘의 위치를 조절합니다.
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class Chatbubble extends StatelessWidget {
  final String message;
  final bool isEnd;
  final bool isSender;

  const Chatbubble({
    super.key,
    required this.message,
    required this.isEnd,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      text: message,
      color: isSender ? primaryColor : const Color.fromARGB(83, 133, 133, 133),
      tail: isEnd,
      isSender: isSender,
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }
}

class Boarddetail extends StatefulWidget {
  final int board_id;
  final String board_title;
  final String board_text;
  final String board_name;
  final DateTime create_time;
  final String userid;

  const Boarddetail(
      {super.key,
      required this.board_id,
      required this.board_title,
      required this.board_text,
      required this.board_name,
      required this.create_time,
      required this.userid});

  @override
  State<Boarddetail> createState() => _BoarddetailState();
}

class _BoarddetailState extends State<Boarddetail> {
  final TextEditingController _commentController = TextEditingController();
  List comments = [];

  void waitforcomments() async {
    comments = await loadcomment(widget.board_id);
    setState(() {});
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    waitforcomments();
    super.initState();
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MM/dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "게시판",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 50,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_2_rounded),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.board_name),
                              Text(formatDateTime(widget.create_time)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: Text(
                          widget.board_title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        // width: MediaQuery.of(context).size.width - 50,
                        height: 30 + (widget.board_text.length / 23) * 30,
                        child: Text(
                          widget.board_text,
                          style: const TextStyle(fontSize: 19),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 0.7, color: Colors.black),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          String? a = comments[index]["usertext"];
                          return Card(
                            elevation: 0,
                            color: Colors.grey.shade100,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: 50,
                              height:
                                  a == null ? 80 : 80 + (a!.length / 50) * 20,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      const Icon(Icons.person_2_rounded,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comments[index]['userid'],
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              formatDateTime(
                                                  widget.create_time),
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        child: Text(
                                          comments[index]["usertext"],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Container(
                height: MediaQuery.of(context).size.height - 30,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요!',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          addcomments(
                              widget.board_id, 'qqqq', _commentController.text);
                          waitforcomments();
                          FocusManager.instance.primaryFocus?.unfocus();
                          _commentController.text = '';
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mysession2 extends StatefulWidget {
  final int sessionid;
  final String storename;
  final int locationid;
  final int currentorder;
  final int fianlorder;
  final int finaltime;
  final DateTime createtime;
  final int membernum;
  final List userorder;

  const Mysession2({
    super.key,
    required this.sessionid,
    required this.storename,
    required this.locationid,
    required this.currentorder,
    required this.fianlorder,
    required this.finaltime,
    required this.createtime,
    required this.membernum,
    required this.userorder,
  });

  @override
  State<Mysession2> createState() => _Mysession2State();
}

class _Mysession2State extends State<Mysession2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  DateTime now = DateTime.now();

  int time = 15;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(minutes: (widget.finaltime * 60 - now.difference(widget.createtime).inSeconds) ~/ 60, seconds: (widget.finaltime * 60 - now.difference(widget.createtime).inSeconds) % 60), // 여기서 시간을 조절.
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.09).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    time = now.difference(widget.createtime).inSeconds; // 추후 작업 필요
    String location =
        context.watch<Spots>().spots[widget.locationid - 1]["name"].toString();
    String userid = context.watch<UserProvider>().userid;
    double width = MediaQuery.of(context).size.width - 30;
    int minutes =
        (((_controller.duration?.inSeconds ?? 0) * (1 - _controller.value))
                    .round() /
                60)
            .floor();
    int seconds =
        ((_controller.duration?.inSeconds ?? 0) * (1 - _controller.value))
                .round() %
            60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return Container(
      /*decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.7,
        ),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(16),
        ),
      ),*/
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            '${widget.storename} #${widget.sessionid}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "배달 장소: $location",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "전체 주문 금액: ${widget.currentorder}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "목표 주문 금액: ${widget.fianlorder}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "남은 시간",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              LinearPercentIndicator(
                lineHeight: 27.0,
                width: width - 35,
                percent: _animation.value,
                barRadius: const Radius.circular(16),
                backgroundColor: Colors.white,
                progressColor: secondColor,
                center: Text(
                  '$formattedMinutes 분 $formattedSeconds 초',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w300),
                ),
              ),
              if (_animation.value <= 0.09) ...[
                const Positioned(
                  left: 10, // 체크표시 아이콘의 위치를 조절합니다.
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ' 상세 주문 내역',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '  나의 주문',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.userorder.length ~/ 2,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          '  메뉴:  ${widget.userorder[index * 2]["menu"]}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '  가격:  ${widget.userorder[index * 2]["price"]}원',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          '  수량:  ${widget.userorder[index * 2 + 1]}개',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MapStyle {
  final String aubergine = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8ec3b9"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1a3646"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6878"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#64779e"
          }
        ]
      },
      {
        "featureType": "administrative.province",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6878"
          }
        ]
      },
      {
        "featureType": "landscape.man_made",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#334e87"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6f9ba5"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3C7680"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#304a7d"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2c6675"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#255763"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#b0d5ce"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3a4762"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#0e1626"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#4e6d70"
          }
        ]
      }
    ]""";

  final String sliver = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#eeeeee"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e5e5e5"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dadada"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e5e5e5"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#eeeeee"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#c9c9c9"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      }
    ]""";

  final String retro = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#ebe3cd"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#523735"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#f5f1e6"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#c9b2a6"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#dcd2be"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#ae9e90"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#93817c"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#a5b076"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#447530"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5f1e6"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#fdfcf8"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f8c967"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#e9bc62"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e98d58"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#db8555"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#806b63"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8f7d77"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#ebe3cd"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#b9d3c2"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#92998d"
          }
        ]
      }
    ]""";

  final String dark = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#181818"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1b1b1b"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#2c2c2c"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8a8a8a"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#373737"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3c3c3c"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#4e4e4e"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#000000"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3d3d3d"
          }
        ]
      }
    ]""";

  final String night = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#263c3f"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6b9a76"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#38414e"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#212a37"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9ca5b3"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#1f2835"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#f3d19c"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2f3948"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#515c6d"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      }
    ]""";
}
