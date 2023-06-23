import 'package:fl_wms/main_layout/main_layout.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class HomeScreen extends MainLayout {
  HomeScreen({Key? key})
      : super(
          key: key,
          title: "Dashboard",
          menu: "Dashboard",
          showSubtitle: false,
        );

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends MainLayoutState<HomeScreen> {
  @override
  Widget body() {
    return Text(
      "Headline",
      style: Theme.of(context).textTheme.displayLarge,
      overflow: TextOverflow.visible,
      softWrap: false,
    );
  }
}
