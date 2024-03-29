import 'package:flutter/material.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:provider/provider.dart';

import 'package:prototype_2/assets/provider.dart';

class selectlocation extends StatefulWidget {
  const selectlocation({super.key});

  @override
  State<selectlocation> createState() => _selectlocationState();
}

class _selectlocationState extends State<selectlocation> {
  List spots = [];

  @override
  Widget build(BuildContext context) {
    spots = context.watch<Spots>().spots;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '위치 선택',
          style: TextStyle(
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        // elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: spots.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    context.read<UserProvider>().locationupdate(
                        spots[index]["name"], spots[index]["id"]);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                        height: 50,
                        child: Text(
                          spots[index]["name"],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Divider(thickness: 0.5,),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
