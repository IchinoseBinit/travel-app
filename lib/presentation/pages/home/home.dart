import 'package:flutter/material.dart';
import 'package:travel_app/presentation/pages/account_details/account_detail.dart';
import 'package:travel_app/presentation/pages/trips/trips_page.dart';
import 'package:travel_app/presentation/widgets/nav_bar_widget.dart';

import '../map/osm_map.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navBarIndex = 0;

  List<Widget> pages = [
    HomePage(),
    MapSample(),
    TripsPage(),
    AccountDetail(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            height: 60,
            child: Row(
              children: [
                BottomNavBarItem(
                  icon: Icons.home_outlined,
                  index: 0,
                  onPressed: () => _onPressed(0),
                  navBarIndex: navBarIndex,
                ),
                BottomNavBarItem(
                  icon: Icons.map_outlined,
                  index: 1,
                  onPressed: () => _onPressed(1),
                  navBarIndex: navBarIndex,
                ),
                BottomNavBarItem(
                  icon: Icons.explore_outlined,
                  index: 2,
                  onPressed: () => _onPressed(2),
                  navBarIndex: navBarIndex,
                ),
                BottomNavBarItem(
                  icon: Icons.person_outline_rounded,
                  index: 3,
                  onPressed: () => _onPressed(3),
                  navBarIndex: navBarIndex,
                ),
              ],
            )),
        body: pages.elementAt(navBarIndex));
  }

  void _onPressed(int index) {
    setState(() {
      navBarIndex = index;
    });
  }
}
