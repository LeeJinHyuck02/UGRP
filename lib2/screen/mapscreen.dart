import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:prototype_2/assets/api.dart';
import 'package:prototype_2/assets/asset.dart';
import 'package:prototype_2/assets/provider.dart';

import 'homescreen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenstate();
}

class MapScreenstate extends State<MapScreen> with TickerProviderStateMixin {
  String currentlocation = '체인지업 그라운드'; // TODO: provider로 교체

  late GoogleMapController _controller;
  late AnimationController bottomcontroller;
  late Position position;
  late LatLng initiallocation = const LatLng(36.012151, 129.323573);

  final _markers = <Marker>{};

  List spots = [];

  Future<void> beforestart() async {
    spots = await loadspots();

    _markers.addAll(
      spots.map(
        (e) => Marker(
          markerId: MarkerId(e["name"] as String),
          infoWindow: InfoWindow(title: e["name"] as String, snippet: '으악!'),
          position: LatLng(
            e['latitude'] as double,
            e['longitude'] as double,
          ),
          onTap: () {
            _controller.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(e['latitude'] as double, e['longitude'] as double),
              ),
            );
            showModalBottomSheet(
              context: context,
              transitionAnimationController: bottomcontroller,
              builder: (context) {
                return MyBottomSheet(location_id: e["id"]);
              },
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            );
          },
        ),
      ),
    );
    bottomcontroller = BottomSheet.createAnimationController(this);

    LocationPermission permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    initiallocation = LatLng(position.latitude, position.longitude);
    
    if(mounted) if(mounted) setState(() {});
  }

  @override
  void initState() {
    beforestart().then((value) {});

    super.initState();
  }

  @override
  void dispose() {
    bottomcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentlocation = context.watch<UserProvider>().location;
    return Scaffold(
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
          initiallocation == const LatLng(36.012151, 129.323573)
              ? const Expanded(
                  child: Center(
                    child: Text(
                      '로딩 중이다 인간!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: initiallocation, zoom: 17),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    markers: _markers,
                    onMapCreated: (controller) {
                      if(mounted) setState(() {
                        _controller = controller;
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  final int location_id;

  MyBottomSheet({Key? key, required this.location_id});

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List sessions = [];
  List filteredSessions = [];

  void waitforsessions() async {
    sessions = await loadsessions('qqqq');
    filteredSessions = sessions;
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitforsessions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width - 30,
      decoration: const BoxDecoration(
        color: Colors.white, // 모달 배경색
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8), // 모달 좌상단 라운딩 처리
          topRight: Radius.circular(8), // 모달 우상단 라운딩 처리
        ),
      ),
      child: sessions.isEmpty
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '로딩 중이다 인간!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                )
              ],
            )
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSessions.length,
                itemBuilder: (BuildContext context, int index) {
                  if (filteredSessions[index]["location_id"] ==
                      widget.location_id) {
                    return session_info(
                      store_name: filteredSessions[index]["name"],
                      location_id: filteredSessions[index]["location_id"],
                      current_order: filteredSessions[index]["currentorder"],
                      fianl_order: filteredSessions[index]["finalorder"],
                      final_time: filteredSessions[index]["finaltime"],
                      create_time: DateTime.parse(
                          filteredSessions[index]["create_time"]),
                    );
                  } else {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
            ),
    );
  }
}
