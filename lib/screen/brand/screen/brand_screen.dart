import 'package:fl_wms/screen/brand/bloc/brand_bloc.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_source.dart';
import 'package:fl_wms/widget/advance_table.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  var brandSource = BrandSource();
  String title = "Brand";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultCardTitle(
                title,
                onPressed: brandSource.openModal,
                showAddButton: true,
              ),
            ),
            Card(
              child: BlocBuilder<BrandBloc, BrandState>(
                builder: (context, state) {
                  if (state is BrandLoadingState) {
                    return const LoadingShimmer();
                  } else if (state is BrandErrorState) {
                    const Text("Error Page");
                  }
                  return AdvanceTable<Brand>(
                    title: title,
                    source: brandSource,
                    onSearch: (value) => brandSource.filterServerSide(value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
