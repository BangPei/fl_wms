import 'package:fl_wms/widget/default_title.dart';
import 'package:flutter/material.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            const DefaultTitle(
              "Brand",
              menu: "Master",
            ),
            const Divider(height: 1),
            Card(
              child: DataTable(columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Brand")),
              ], rows: const []),
            )
          ],
        ),
      ),
    );
  }
}
