import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prototype_2/assets/asset.dart';

class FoodSurveyData {
  String foodName;
  double preference;

  FoodSurveyData({required this.foodName, required this.preference});

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'preference': preference,
    };
  }
}

class SurveyScreen extends StatefulWidget {
  SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentFoodIndex = 0;
  List<FoodSurveyData> foodSurveyList = [];

  double _rating = 3.0; // 초기값은 1.0으로 설정

  final List<String> foodList = [
    '낙곱새',
    '음식2',
    '음식3',
    '음식4',
    '음식5',
    '음식6',
    '음식7',
    '음식8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음식 선호도 설문조사'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${foodList[currentFoodIndex]}에 대한 선호도를 표시해주세요.',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Slider(
                        value: _rating,
                        onChanged: (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                        min: 1.0,
                        max: 5.0,
                        divisions: 8, // 수직선을 몇 등분으로 나눌지 설정
                        label: '$_rating',
                        inactiveColor: Colors.grey,
                        activeColor: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
                const Column(
                  children: [
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('매우 싫어함'),
                        Text('매우 좋아함'),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        child: Container(
          // decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // Background color
            ),
            onPressed: () {
              // 설문조사 결과를 저장
              final foodSurveyData = FoodSurveyData(
                foodName: foodList[currentFoodIndex],
                preference: _rating,
              );
              foodSurveyList.add(foodSurveyData);

              // 다음 음식으로 이동 또는 결과 저장 또는 앱 종료
              if (currentFoodIndex < foodList.length - 1) {
                setState(() {
                  currentFoodIndex++;
                  _rating = 3.0; // 다음 음식으로 이동할 때 선호도 초기화
                });
              } else {
                // 모든 음식에 대한 설문조사가 끝났을 때 JSON으로 저장
                saveSurveyResults();
                // 앱 종료
                SystemNavigator.pop();
              }
            },
            child: Text(
              currentFoodIndex < foodList.length - 1 ? '다음' : '제출 및 종료',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveSurveyResults() {
    // foodSurveyList를 JSON 형식으로 변환하여 저장
    final jsonData = foodSurveyList.map((data) => data.toJson()).toList();
    final jsonString = jsonEncode(jsonData);

    // 실제로는 여기에서 저장 로직을 추가해야 합니다.
    // 이 예제에서는 간단하게 출력합니다.
    // print('설문조사 결과(JSON): $jsonString');
  }
}
