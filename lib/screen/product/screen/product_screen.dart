import 'dart:convert';

import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/product/bloc/product_bloc.dart';
import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:badges/badges.dart' as badges;
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String title = "Product";
  var sortIndex = 0;
  var sortAsc = true;

  int currIdx = 0;
  int start = 0;
  int length = 10;
  int orderColumn = 0;
  String orderDir = "asc";
  TextEditingController search = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    context.read<ProductBloc>().add(GetDataTable(
          length: length,
          start: start,
          orderColumn: orderColumn,
          orderDir: orderDir,
          search: search.text,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: WebSmoothScroll(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DefaultCardTitle(
                  title,
                  onPressed: () => context.goNamed("add-product"),
                  showAddButton: true,
                ),
              ),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return const LoadingShimmer();
                  } else if (state is ProductDataState) {
                    return Column(
                      children: [
                        FilterRow(
                          initialValueDropdown: length,
                          searchController: search,
                          dropDownChange: (val) {
                            if (val != length) {
                              setState(() {
                                length = val!;
                                context.read<ProductBloc>().add(GetDataTable(
                                      length: length,
                                      start: 0,
                                      orderColumn: orderColumn,
                                      orderDir: orderDir,
                                      search: search.text,
                                    ));
                              });
                            }
                          },
                          onFieldSubmitted: (val) {
                            // context.read<ProductBloc>().add(SearchProduct(val));
                            setState(() {
                              context.read<ProductBloc>().add(GetDataTable(
                                    length: length,
                                    start: 0,
                                    orderColumn: orderColumn,
                                    orderDir: orderDir,
                                    search: val,
                                  ));
                            });
                          },
                        ),
                        const ProductHeader(),
                        itemWidget(state.products),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: NumberPaginator(
                              initialPage: currIdx,
                              numberPages: getPage(state.dataTable!),
                              onPageChange: (int index) {
                                if (state.products.isNotEmpty) {
                                  setState(() {
                                    currIdx = index;
                                    start = length * index;
                                    context
                                        .read<ProductBloc>()
                                        .add(GetDataTable(
                                          length: length,
                                          start: start,
                                          orderColumn: orderColumn,
                                          orderDir: orderDir,
                                          search: search.text,
                                        ));
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("Error Page");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemWidget(List<Product> products) {
    if (products.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Center(
            child: Text(
              "No Data Found !",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          Product product = products[i];
          return ListViewProduct(product: product);
        },
      );
    }
  }

  int getPage(DataTableModel data) {
    int pageLength = 1;
    if ((data.recordsFiltered ?? 0) > length) {
      return pageLength = ((data.recordsFiltered ?? 0) / length).ceil();
    }
    return pageLength;
  }

  void setSort(int i, bool asc) {
    setState(() {
      sortIndex = i;
      sortAsc = asc;
    });
  }
}

class FilterRow extends StatelessWidget {
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<int?>? dropDownChange;
  final int initialValueDropdown;
  final TextEditingController searchController;
  const FilterRow({
    super.key,
    this.onFieldSubmitted,
    this.dropDownChange,
    required this.initialValueDropdown,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<int>(
                decoration: const BootstrapInputDecoration(),
                value: initialValueDropdown,
                items: const [
                  DropdownMenuItem(
                    value: 10,
                    child: Text("10 Items Per Page"),
                  ),
                  DropdownMenuItem(
                    value: 25,
                    child: Text("25 Items Per Page"),
                  ),
                  DropdownMenuItem(
                    value: 50,
                    child: Text("50 Items Per Page"),
                  ),
                  DropdownMenuItem(
                    value: 100,
                    child: Text("100 Items Per Page"),
                  ),
                ],
                onChanged: dropDownChange,
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: searchController,
                onFieldSubmitted: onFieldSubmitted,
                decoration: const BootstrapInputDecoration(
                  labelText: "Search",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontWeight: FontWeight.w600);
    return Card(
      color: const Color.fromARGB(255, 243, 241, 241),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ResponsiveGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveGridCol(
              lg: 4,
              md: 4,
              sm: 12,
              xl: 4,
              xs: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Product",
                  style: style,
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 2,
              md: 2,
              sm: 12,
              xl: 2,
              xs: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Brand",
                  style: style,
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 2,
              md: 2,
              sm: 12,
              xl: 2,
              xs: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Category",
                  style: style,
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 2,
              md: 2,
              sm: 12,
              xl: 2,
              xs: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Status",
                  style: style,
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 2,
              md: 2,
              sm: 12,
              xl: 2,
              xs: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Action",
                  style: style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewProduct extends StatelessWidget {
  final Product? product;
  const ListViewProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    TextStyle textButtonStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            ResponsiveGridRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveGridCol(
                  lg: 1,
                  md: 1,
                  sm: 12,
                  xl: 1,
                  xs: 12,
                  child: InkWell(
                    onTap: () async {
                      // await showDialog(
                      //   context: context,
                      //   builder: (_) {},
                      // );
                    },
                    splashColor: Colors.white10, // Splash color over image
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          ((product!.image == null) || (product!.image == ""))
                              ? const Image(
                                  image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVYi-GBPwUrFwKpkfGeu9khpg6smHZTIRHFd-5VAtI&s"),
                                  height: 60,
                                  width: 60,
                                  // fit: BoxFit.fill,
                                )
                              : Image.memory(
                                  base64Decode(product!.image!),
                                  height: 60,
                                  width: 60,
                                ),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 3,
                  md: 3,
                  sm: 12,
                  xl: 3,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "Code : ${product?.code ?? '--'}",
                          style: style.copyWith(
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 2),
                        SelectableText(
                          (product?.name != "" && product?.name != null)
                              ? product!.name!
                              : "Morinaga Chil go 3+ Vanila 700 gr Susu Pertumbuhan Anak",
                          style: style,
                        ),
                        const SizedBox(height: 2),
                        badges.Badge(
                          badgeContent: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "${product?.moving ?? ""} MOVING",
                              style: style.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          badgeAnimation: const badges.BadgeAnimation.rotation(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.square,
                            badgeColor: product?.moving == "FAST"
                                ? BootstrapColors.success
                                : product?.moving == "MEDIUM"
                                    ? BootstrapColors.primary
                                    : BootstrapColors.danger,
                            padding: const EdgeInsets.all(3),
                            borderRadius: BorderRadius.circular(9),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  md: 2,
                  sm: 12,
                  xl: 2,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(product?.brand?.name ?? "Brand Name"),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  md: 2,
                  sm: 12,
                  xl: 2,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(product?.category?.name ?? "Category Name"),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  md: 2,
                  sm: 12,
                  xl: 2,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        badges.Badge(
                          badgeContent: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              (product?.isActive ?? false)
                                  ? "Active"
                                  : "Inactive",
                              style: style.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          badgeAnimation: const badges.BadgeAnimation.rotation(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.square,
                            badgeColor: (product?.isActive ?? false)
                                ? BootstrapColors.success
                                : BootstrapColors.danger,
                            padding: const EdgeInsets.all(3),
                            borderRadius: BorderRadius.circular(9),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  md: 2,
                  sm: 12,
                  xl: 2,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(child: Text("Edit", style: textButtonStyle)),
                        const SizedBox(height: 5),
                        InkWell(
                            child: Text("Diactivate", style: textButtonStyle)),
                        const SizedBox(height: 5),
                        PopupMenuButton(
                          offset: const Offset(-60, 30),
                          child: Row(
                            children: [
                              Text("More", style: textButtonStyle),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.indigo,
                              ),
                            ],
                          ),
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              PopupMenuItem(
                                  child: Text("Copy", style: textButtonStyle)),
                              PopupMenuItem(
                                child: Text("Remove", style: textButtonStyle),
                              ),
                            ];
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            (product?.items ?? []).isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Divider(color: Colors.grey),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              "Total Item : ${(product?.items ?? []).length.toString()}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: const Icon(Icons.arrow_drop_down),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.indigo.withOpacity(0.8),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () => print("ok"),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10.0),
                                          child: Text(
                                            "Save All",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: (product?.items ?? []).map((item) {
                                  double width =
                                      MediaQuery.of(context).size.width;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(item.sku ?? ""),
                                              Text(
                                                item.name ?? "",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.5,
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 40,
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: TextFormField(
                                                  initialValue:
                                                      item.qty.toString(),
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                    labelText: "Convertion",
                                                    hintText: "Convertion",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: TextFormField(
                                                  initialValue:
                                                      item.salePrice.toString(),
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                    labelText: "Sale Price",
                                                    hintText: "Sale Price",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: TextFormField(
                                                  initialValue:
                                                      item.uom?.name ?? "",
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                    labelText: "Uom",
                                                    hintText: "Uom",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
