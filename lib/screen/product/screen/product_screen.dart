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

  int start = 0;
  int length = 10;
  int orderColumn = 0;
  String orderDir = "asc";
  String search = "";
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    context.read<ProductBloc>().add(GetDataTable(
          length: length,
          start: start,
          orderColumn: orderColumn,
          orderDir: orderDir,
          search: search,
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
                  onPressed: () => context.goNamed("add-warehouse"),
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.products.length,
                          itemBuilder: (ctx, i) {
                            Product product = state.products[i];
                            return ListViewProduct(product: product);
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              // height: 40,
                              width: MediaQuery.of(context).size.width / 2,
                              child: NumberPaginator(
                                numberPages:
                                    ((state.dataTable?.recordsFiltered ?? 0) /
                                            length)
                                        .ceil(),
                                onPageChange: (int index) {
                                  print(index);
                                },
                              ),
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

  void setSort(int i, bool asc) {
    setState(() {
      sortIndex = i;
      sortAsc = asc;
    });
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
                      child: Image(
                        image: NetworkImage((product?.image != "" &&
                                product?.image != null)
                            ? product!.image!
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVYi-GBPwUrFwKpkfGeu9khpg6smHZTIRHFd-5VAtI&s"),
                        height: 60,
                        width: 60,
                        // fit: BoxFit.fill,
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
                        Text(
                          "Code : ${product?.code ?? '--'}",
                          style: style.copyWith(
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Brand",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product?.brand?.name ?? "Brand Name",
                          style: style,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product?.category?.name ?? "Category Name",
                          textAlign: TextAlign.center,
                          style: style,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 3),
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
                        ExpansionTile(
                          title: Text(
                            "Total Item : ${(product?.items ?? []).length.toString()}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                          children: (product?.items ?? []).map((item) {
                            return Text(item.sku ?? "");
                          }).toList(),
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
