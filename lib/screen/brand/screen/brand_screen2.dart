import 'package:flutter/material.dart';

class BrandScreen2 extends StatefulWidget {
  const BrandScreen2({super.key});

  @override
  State<BrandScreen2> createState() => _BrandScreen2State();
}

class _BrandScreen2State extends State<BrandScreen2> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Brand 2",
      style: Theme.of(context).textTheme.displayLarge,
      overflow: TextOverflow.visible,
      softWrap: false,
    );
  }
}
