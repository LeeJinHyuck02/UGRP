import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/asset.dart';

class CheckScreen extends StatefulWidget {
  final List userorder;
  final String selectedgage;

  const CheckScreen({super.key, required this.userorder, required this.selectedgage});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  Duration _duration = const Duration();
  String currentlocation = '체인지업 그라운드';

  var deliveryprice = 5000;
  double totalOrderPrice = 0;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < widget.userorder.length ~/ 2; i++) {
      totalOrderPrice += widget.userorder[2 * i]['price'] * widget.userorder[2 * i + 1]; 
    } // initState 내에서 계산
  }

  void place() {}
  void backtoselect() {}

  @override
  Widget build(BuildContext context) {
    int minutes = _duration.inMinutes;
    int seconds = _duration.inSeconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    currentlocation = context.watch<UserProvider>().location;
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '세션 생성',
          style: TextStyle(color: Colors.black),
        ),
      ),

      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        height: 45,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            // 주문을 처리하는 로직 추가
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.black, // 아이콘의 색상 설정
          ),
          label: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // 텍스트의 padding 설정
            child: Text(
              '배달 주문하기',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '배달 위치를 확인해주세요',
                  ),
                ],
              ),
              // 주문 상품 목록
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.place,
                            color: Colors.black,
                          ),
                          TextButton(
                            onPressed: backtoselect,
                            child: Text(
                              currentlocation,
                              style: TextStyle(color: secondColor),
                            ),
                          ),
                        ],
                      ),
                      Text('배달팁 $deliveryprice')
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // 주문 상품 목록을 표시하는 ListView 또는 GridView 추가

              // 주문 정보
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.food_bank_outlined),
                          const SizedBox(width: 5,),
                          Text(widget.selectedgage),
                        ],
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
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.black),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                // ... 기존의 메뉴 컨테이너 디자인
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '* 메뉴:  ${widget.userorder[index * 2]["menu"]}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    /*Text(
                                      '* 선택:  ${widget.userorder[index].description}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),*/
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      ' ${widget.userorder[index * 2]["price"] * widget.userorder[index * 2 + 1]}원',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: backtoselect,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            '옵션 추가',
                                          ),
                                        ),
                                      ],
                                    )
                                    // ... 기타 필요한 위젯들
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('   세션 마감 시간'),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(
                              brightness: Brightness.light),
                          child: CupertinoTimerPicker(
                            initialTimerDuration: _duration,
                            mode: CupertinoTimerPickerMode.ms,
                            itemExtent: 100,
                            minuteInterval: 5,
                            secondInterval: 60,
                            onTimerDurationChanged: (Duration newDuration) {
                              setState(() {
                                _duration = newDuration;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$formattedMinutes 분 : $formattedSeconds 초',
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('총 주문금액 '),
                  Text('${totalOrderPrice.round()}원'),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('배달팁 '),
                  Text('$deliveryprice원'),
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '결제예정금액 ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${totalOrderPrice.round() + deliveryprice}원',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
