import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/screen/uom/bloc/uom_bloc.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/screen/uom/data/uom_source.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UomScreen extends StatefulWidget {
  const UomScreen({super.key});

  @override
  State<UomScreen> createState() => _UomScreenState();
}

class _UomScreenState extends State<UomScreen> {
  bool isActive = true;
  final formgroup = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'alias': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'is_active': FormControl<bool>(value: true)
  });
  final _controller = ValueNotifier<bool>(true);
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    context.read<UomBloc>().add(const GetUoms());
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UomBloc, UomState>(
      builder: (context, state) {
        if (state is UomLoadingState) {
          return const LoadingShimmer();
        } else if (state is UomDataState) {
          return Padding(
            padding: const EdgeInsets.only(top: 13),
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                dataRowMaxHeight: 35,
                dataRowMinHeight: 20,
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                availableRowsPerPage: const [10, 20, 50, 100],
                rowsPerPage: rowsPerPage,
                primary: true,
                header: DefaultCardTitle(
                  "Uom",
                  onPressed: _openModal,
                  showAddButton: true,
                ),
                columns: const [
                  DataColumn(
                    label: Text("No"),
                  ),
                  DataColumn(
                    label: Text("Uom"),
                  ),
                  DataColumn(
                    label: Text("Alias"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                source: UomSource(
                  state.uoms,
                  onTap: (i) => _openModal(uom: i),
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

  Future _openModal({Uom? uom}) async {
    if (uom != null) {
      formgroup.control("name").value = uom.name;
      formgroup.control("alias").value = uom.alias;
      _controller.value = uom.isActive!;
      formgroup.control('is_active').value = uom.isActive;
    }
    await Common.modalBootstrapt(
      context,
      BootstrapModalSize.medium,
      title: "Add Uom",
      onSave: () {
        Uom newUom = Uom.fromJson(formgroup.value);
        if (uom != null) {
          newUom.id = uom.id;
          context.read<UomBloc>().add(PutUom(newUom));
        } else {
          context.read<UomBloc>().add(PostUom(newUom));
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
                  child: SelectableText('Uom'),
                ),
                ReactiveTextField(
                  formControlName: 'name',
                  decoration: const BootstrapInputDecoration(),
                ),
              ],
            ),
            BootstrapFormGroup(
              children: [
                const BootstrapLabelText(
                  child: SelectableText('Alias'),
                ),
                ReactiveTextField(
                  formControlName: 'alias',
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
