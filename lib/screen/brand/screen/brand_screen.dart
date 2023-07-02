import 'package:advanced_datatable/datatable.dart';
import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/screen/brand/bloc/brand_bloc.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_source.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  bool isActive = true;
  int start = 0;
  var sortIndex = 0;
  var sortAsc = true;
  final formgroup = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'is_active': FormControl<bool>(value: true)
  });
  final _controller = ValueNotifier<bool>(true);
  final _searchController = TextEditingController();
  var rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    context
        .read<BrandBloc>()
        .add(GetBrandDataTable(start: start, length: rowsPerPage));
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoadingState) {
          return const LoadingShimmer();
        } else if (state is BrandDataState) {
          return Padding(
            padding: const EdgeInsets.only(top: 13),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultCardTitle(
                      "Brand",
                      onPressed: _openModal,
                      showAddButton: true,
                    ),
                  ),
                  Card(
                    child: AdvancedPaginatedDataTable(
                      loadingWidget: () => const LoadingShimmer(),
                      dataRowHeight: 40,
                      sortAscending: sortAsc,
                      sortColumnIndex: sortIndex,
                      showFirstLastButtons: true,
                      addEmptyRows: false,
                      showCheckboxColumn: false,
                      availableRowsPerPage: const [5, 10, 25, 50, 100],
                      rowsPerPage: rowsPerPage,
                      header: TextFormField(
                        controller: _searchController,
                        onFieldSubmitted: (val) {
                          start = 0;
                          context.read<BrandBloc>().add(GetBrandDataTableExtend(
                                start: start,
                                length: rowsPerPage,
                                searchText: val.toLowerCase(),
                              ));
                        },
                        decoration: const BootstrapInputDecoration(
                          hintText: "Search...",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        ),
                      ),
                      columns: const [
                        DataColumn(label: Text("Brand")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Action")),
                      ],
                      source: BrandSource(
                        state.brands,
                        recordsFiltered: state.dataTable?.recordsFiltered ?? 0,
                        recordsTotal: state.dataTable?.recordsFiltered ?? 0,
                        onTap: (i) => _openModal(brand: i),
                      ),
                      onPageChanged: (value) {
                        start = value;
                        context.read<BrandBloc>().add(GetBrandDataTableExtend(
                            start: value, length: rowsPerPage));
                      },
                      onRowsPerPageChanged: (n) {
                        rowsPerPage = n!;
                        start = 0;
                        context.read<BrandBloc>().add(GetBrandDataTableExtend(
                            start: start, length: rowsPerPage));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text("Error Page");
        }
      },
    );
  }

  // void setSort(int i, bool asc) => setState(() {
  //       sortIndex = i;
  //       context.read<BrandBloc>().add(GetBrandDataTableExtend(
  //             start: start,
  //             length: rowsPerPage,
  //             searchText: _searchController.text,
  //           ));
  //     });

  Future _openModal({Brand? brand}) async {
    if (brand != null) {
      formgroup.control("name").value = brand.name;
      _controller.value = brand.isActive!;
      formgroup.control('is_active').value = brand.isActive;
    }
    await Common.modalBootstrapt(
      context,
      BootstrapModalSize.medium,
      title: "Add Brand",
      onSave: () {
        Brand newBrand = Brand.fromJson(formgroup.value);
        if (brand != null) {
          newBrand.id = brand.id;
          context.read<BrandBloc>().add(PutBrand(newBrand));
        } else {
          context.read<BrandBloc>().add(PostBrand(newBrand));
        }
      },
      content: ReactiveForm(
        formGroup: formgroup,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BootstrapFormGroup(
              children: [
                const BootstrapLabelText(
                  child: SelectableText('Brand'),
                ),
                ReactiveTextField(
                  formControlName: 'name',
                  decoration: const BootstrapInputDecoration(),
                ),
              ],
            ),
            BootstrapFormGroup(
              direction: Axis.horizontal,
              children: [
                const BootstrapLabelText(
                  child: SelectableText('Status'),
                ),
                AdvancedSwitch(
                  controller: _controller,
                  activeColor: BootstrapColors.success,
                  inactiveColor: BootstrapColors.danger,
                  activeChild: const Text('Active'),
                  inactiveChild: const Text('Inactive'),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  width: 90.0,
                  height: 35.0,
                  enabled: true,
                  disabledOpacity: 0.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
