import 'package:fl_wms/main_layout/left_menu.dart';
import 'package:fl_wms/main_layout/top_navbar.dart';
import 'package:fl_wms/widget/default_title.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class MainLayout extends StatefulWidget {
  String title;
  String menu;
  bool? showSubtitle;
  MainLayout({
    super.key,
    required this.title,
    required this.menu,
    this.showSubtitle,
  });

  // @override
  // State<MainLayout> createState() => MainLayoutState();
}

abstract class MainLayoutState<T> extends State<MainLayout> {
  double drawerSize = 250;
  bool showMenu = true;
  bool isCloseDrawer = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerScrimColor: Colors.transparent,
      drawer: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: MouseRegion(
          onExit: (e) {
            scaffoldKey.currentState!.closeDrawer();
            drawerSize = isCloseDrawer ? 250 : 60;
            showMenu = true;
            setState(() {});
          },
          child: LeftMenu(
            showMenu: showMenu,
            menuSize: drawerSize,
            onPressed: (size) {
              setState(() {
                Future.delayed(const Duration(milliseconds: 300), () {
                  scaffoldKey.currentState!.closeDrawer();
                });
                drawerSize = 250;
                isCloseDrawer = true;
                showMenu = true;
              });
            },
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(245, 245, 245, 0),
        child: Row(
          children: [
            Visibility(
              visible: showMenu,
              child: MouseRegion(
                onEnter: (e) {
                  if (drawerSize <= 60) {
                    showMenu = false;
                    scaffoldKey.currentState!.openDrawer();
                    drawerSize = 250;
                    isCloseDrawer = false;
                    setState(() {});
                  }
                },
                child: LeftMenu(
                  showMenu: showMenu,
                  menuSize: drawerSize,
                  onPressed: (size) {
                    drawerSize = size;
                    isCloseDrawer = true;
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TopNavbar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultTitle(
                              widget.title,
                              showSubtitle: widget.showSubtitle,
                            ),
                            body(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body();
}
