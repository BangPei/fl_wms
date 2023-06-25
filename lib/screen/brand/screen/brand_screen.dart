import 'package:dio/dio.dart';
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
  bool isLoading = false;

  bool isActive = true;
  final formgroup = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'is_active': FormControl<bool>(value: true)
  });
  final _controller = ValueNotifier<bool>(true);
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    loadServerside();
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });
    context.read<BrandBloc>().add(const GetBrands());
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
              child: PaginatedDataTable(
                dataRowMaxHeight: 35,
                dataRowMinHeight: 20,
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                availableRowsPerPage: const [1, 5, 10, 50],
                rowsPerPage: rowsPerPage,
                primary: true,
                header: DefaultCardTitle(
                  "Brand",
                  onPressed: _openModal,
                  showAddButton: true,
                ),
                columns: const [
                  DataColumn(
                    label: Text("No"),
                  ),
                  DataColumn(
                    label: Text("Brand"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                source: BrandSource(
                  state.brands,
                  onViewRowSelect: (i) => _openModal(brand: i),
                ),
                onPageChanged: (value) {
                  rowsPerPage = value;
                },
                onRowsPerPageChanged: (n) => setState(() {
                  rowsPerPage = n!;
                }),
              ),
            ),
          );
        } else {
          return const Text("Error Page");
        }
      },
    );
  }

  loadServerside() async {
    Map<String, dynamic> param = {
      "draw": 1,
      "columns[0][data]": "name",
      "columns[0][searchable]": true,
      "columns[0][orderable]": true,
      "columns[0][search][value]": "",
      "columns[0][search][regex]": false,
      "columns[1][data]": "is_active",
      "columns[1][searchable]": true,
      "columns[1][orderable]": true,
      "columns[1][search][value]": "",
      "columns[1][search][regex]": false,
      "columns[2][data]": "id",
      "columns[2][searchable]": true,
      "columns[2][orderable]": true,
      "columns[2][search][value]": "",
      "columns[2][search][regex]": false,
      "order[0][column]": 0
    };
    Dio dio = Dio();
    var data = await dio.get(
      "http://192.168.100.11:8000/api/brand/dataTable",
      queryParameters: param,
    );
    print(data);
  }

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
