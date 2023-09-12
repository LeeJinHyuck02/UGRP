import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'provider.dart';

Color primaryColor = const Color.fromARGB(200, 200, 1, 80);
Color secondColor = const Color.fromARGB(240, 102, 102, 92);

String server = 'http://172.20.10.3:3000';

class _Session {
  String store_name;
  int location_id;
  int current_order;
  int fianl_order;
  int final_time;
  DateTime create_time;

  _Session(this.store_name, this.create_time, this.current_order, this.fianl_order, this.final_time, this.location_id);
}

class session_info extends StatefulWidget {
  final String store_name;
  final int location_id;
  final int current_order;
  final int fianl_order;
  final int final_time;
  final DateTime create_time;

  session_info(
      {super.key,
      required this.store_name,
      required this.location_id,
      required this.current_order,
      required this.fianl_order,
      required this.final_time,
      required this.create_time});

  @override
  State<session_info> createState() => _session_infoState();
}

class _session_infoState extends State<session_info> {
  double infowidth = 170;

  List<String> tags = ['이진혁 추천 맛집'];
  String location = '';
  int currentmem = 3;

  @override
  Widget build(BuildContext context) {
    infowidth = MediaQuery.of(context).size.width - 30;
    location =
        context.watch<Spots>().spots[widget.location_id - 1]["name"].toString();
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secondColor,
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
                      for (int i = 0; i < currentmem; i++)
                        const Icon(
                          Icons.person,
                          size: 18,
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
                              widget.store_name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
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
      height: 80,
      width: 80,
      child: Center(
        child: CircularCountDownTimer(
          duration: _duration * 60,
          initialDuration: 150,
          controller: _controller,
          width: 80,
          height: 80,
          fillColor: Colors.black,
          ringColor: Colors.white,
          isReverse: true,
          isReverseAnimation: true,
          textFormat: CountdownTextFormat.MM_SS,
        ),
      ),
    );
  }
}
