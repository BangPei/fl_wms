import 'package:fl_wms/main_layout/main_layout.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class BrandScreen extends MainLayout {
  BrandScreen({Key? key})
      : super(
          key: key,
          title: "Brand",
          menu: "Master",
          showSubtitle: false,
        );

  @override
  BrandScreenState createState() => BrandScreenState();
}

class BrandScreenState extends MainLayoutState<BrandScreen> {
  @override
  Widget body() {
    return Text(
      "Brand",
      style: Theme.of(context).textTheme.displayLarge,
      overflow: TextOverflow.visible,
      softWrap: false,
    );
  }
}
