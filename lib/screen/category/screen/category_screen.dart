import 'package:fl_wms/screen/category/bloc/category_bloc.dart';
import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/screen/category/data/category_source.dart';
import 'package:fl_wms/widget/advance_table.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var categorySource = CategorySource();
  String title = "Category";
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
                onPressed: categorySource.openModal,
                showAddButton: true,
              ),
            ),
            Card(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return const LoadingShimmer();
                  } else if (state is CategoryErrorState) {
                    const Text("Error Page");
                  }
                  return AdvanceTable<ItemCategory>(
                    title: title,
                    source: categorySource,
                    onSearch: (value) => categorySource.filterServerSide(value),
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
