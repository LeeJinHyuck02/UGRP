import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/api.dart';

import 'package:prototype_2/screen/homescreen.dart';

class Part2 extends StatefulWidget {
  final List userorder;
  final String selectedgage;
  final String category;
  final int sessionid;
  final int finalorder;
  final int tip;

  const Part2(
      {super.key,
      required this.userorder,
      required this.selectedgage,
      required this.category,
      required this.sessionid,
      required this.finalorder,
      required this.tip});

  @override
  State<Part2> createState() => _Part2State();
}

class _Part2State extends State<Part2> {
  String currentlocation = '체인지업 그라운드';
  String userid = '';
  int locationid = 1;

  bool insession = false;

  var deliveryprice = 5000;
  double totalOrderPrice = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.userorder.length ~/ 2; i++) {
      totalOrderPrice +=
          widget.userorder[2 * i]['price'] * widget.userorder[2 * i + 1];
    } // initState 내에서 계산
  }

  void place() {}
  void backtoselect() {}

  void dialog() {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: const Column(
            children: <Widget>[
              Text(
                "안내",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "이미 세션에 참여 중이라면, 세션 생성 및 참여가 불가능합니다.",
              ),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              height: 35,
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Background color
                ),
                child: const Text(
                  "확인",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    locationid = context.watch<UserProvider>().locationid;
    userid = context.watch<UserProvider>().userid;
    insession = context.watch<UserProvider>().insession;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '세션 참여',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        height: 45,
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: insession
              ? () {
                  dialog();
                }
              : () {
                  addmember(userid, widget.sessionid, totalOrderPrice.round(),
                      widget.userorder);
                  context.read<UserProvider>().inupdate(userid);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white, // 아이콘의 색상 설정
          ),
          label: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // 텍스트의 padding 설정
            child: Text(
              '배달 주문하기',
              style: TextStyle(
                color: Colors.white,
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
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Text('배달팁 ${widget.tip}')
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

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
                          const SizedBox(
                            width: 5,
                          ),
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
                                          icon: Icon(
                                            Icons.add,
                                            color: primaryColor,
                                          ),
                                          label: Text(
                                            '옵션 추가',
                                            style:
                                                TextStyle(color: primaryColor),
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
                  Text('${widget.tip}원'),
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
                    '${totalOrderPrice.round() + widget.tip}원',
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
