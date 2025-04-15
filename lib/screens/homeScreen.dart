import 'package:flutter/material.dart';
import 'package:grehuorigehuorge/screens/chatList.dart';
import 'package:grehuorigehuorge/screens/favourite.dart';
import 'package:grehuorigehuorge/screens/welcome.dart';
import './profile.dart';
import '../widgets/bottomNavBar.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUserUid});

  final String currentUserUid;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  var _screens = [];

  @override
  void initState() {
    _screens = [
      SearchPage(currentUserUid: widget.currentUserUid),
      ChatListPage(currentUserUid: widget.currentUserUid),
      FavouritePage(currentUserUid: widget.currentUserUid),
      ProfilePage(
        uid: widget.currentUserUid,
        currentUserUid: widget.currentUserUid,
        allowEdit: true,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _screens[pageIndex],
        Positioned(
          bottom: 0,
          child: Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    navItem(
                      Icons.home_outlined,
                      pageIndex == 0,
                      onTap: () => {
                        setState(() {
                          pageIndex = 0;
                        })
                      },
                    ),
                    navItem(
                      Icons.mode_comment_outlined,
                      pageIndex == 1,
                      onTap: () => {
                        setState(() {
                          pageIndex = 1;
                        })
                      },
                    ),
                    navItem(
                      Icons.favorite_outline_rounded,
                      pageIndex == 2,
                      onTap: () => {
                        setState(() {
                          pageIndex = 2;
                        })
                      },
                    ),
                    navItem(
                      Icons.person_outline,
                      pageIndex == 3,
                      onTap: () => {
                        setState(() {
                          pageIndex = 3;
                        })
                      },
                    ),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}
