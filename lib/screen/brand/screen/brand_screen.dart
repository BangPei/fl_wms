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
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 15),
            child: PaginatedDataTable(
              showCheckboxColumn: false,
              showFirstLastButtons: true,
              availableRowsPerPage: const [1, 5, 10, 50],
              rowsPerPage: (state.brands.length < rowsPerPage)
                  ? state.brands.length
                  : rowsPerPage,
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
                onViewRowSelect: (i) {},
              ),
              onPageChanged: (value) {
                int length = (state.brands).length;
                int result = length - value;
                rowsPerPage = result < rowsPerPage
                    ? result
                    : PaginatedDataTable.defaultRowsPerPage;
                // print(rowsPerPage);
                print(value);
                setState(() {});
              },
            ),
          );
        } else {
          return const Text("Error Page");
        }
      },
    );
  }

  Future<dynamic> _openModal() async {
    await Common.modalBootstrapt(
      context,
      BootstrapModalSize.medium,
      title: "Add Brand",
      onSave: () {
        Brand brand = Brand.fromJson(formgroup.value);
        context.read<BrandBloc>().add(PostBrand(brand));
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
