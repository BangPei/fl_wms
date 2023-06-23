import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Dashboard",
      style: Theme.of(context).textTheme.displayLarge,
      overflow: TextOverflow.visible,
      softWrap: false,
    );
  }
}
