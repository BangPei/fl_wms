import 'package:fl_wms/screen/warehouse/bloc/warehouse_bloc.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_grid/responsive_grid.dart';

class WarehouseFormScreen extends StatefulWidget {
  final int? warehouseId;
  const WarehouseFormScreen({super.key, this.warehouseId});

  @override
  State<WarehouseFormScreen> createState() => _WarehouseFormScreenState();
}

class _WarehouseFormScreenState extends State<WarehouseFormScreen> {
  String title = "";
  bool isActive = true;
  bool readOnly = false;
  final _controller = ValueNotifier<bool>(true);
  final formgroup = FormGroup({
    'code': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'pic': FormControl<String>(
      value: '',
    ),
    'pic_phone': FormControl<String>(
      value: '',
    ),
    'phone': FormControl<String>(
      value: '',
    ),
    'address': FormControl<String>(
      value: '',
    ),
    'is_active': FormControl<bool>(value: true)
  });
  Warehouse warehouse = Warehouse();
  @override
  void initState() {
    title = widget.warehouseId != null ? "Edit Warehouse" : "Warehouse Form";
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });
    isActive = _controller.value;
    formgroup.control('is_active').value = isActive;
    if (widget.warehouseId != null) {
      context.read<WarehouseBloc>().add(GetWarehouseById(widget.warehouseId!));
      readOnly = widget.warehouseId == null ? false : true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultCardTitle(title),
            ),
            const SizedBox(height: 10),
            BlocBuilder<WarehouseBloc, WarehouseState>(
              builder: (context, state) {
                if (state is WarehouseLoadingState) {
                  return const LoadingShimmer();
                } else if (state is WarehouseDataState) {
                  if (widget.warehouseId != null) {
                    formgroup.value = state.warehouse?.toJson();
                    _controller.value = state.warehouse?.isActive ?? false;
                  }
                  return ReactiveForm(
                    formGroup: formgroup,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('Code'),
                                    ),
                                    ReactiveTextField(
                                      formControlName: 'code',
                                      readOnly: readOnly,
                                      onSubmitted: (val) {},
                                      decoration:
                                          const BootstrapInputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('Name'),
                                    ),
                                    ReactiveTextField(
                                      formControlName: 'name',
                                      onSubmitted: (val) {},
                                      decoration:
                                          const BootstrapInputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('PIC'),
                                    ),
                                    ReactiveTextField(
                                      formControlName: 'pic',
                                      onSubmitted: (val) {},
                                      decoration:
                                          const BootstrapInputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('PIC Phone'),
                                    ),
                                    ReactiveTextField(
                                      formControlName: 'pic_phone',
                                      onSubmitted: (val) {},
                                      decoration:
                                          const BootstrapInputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: Column(
                                  children: [
                                    BootstrapFormGroup(
                                      children: [
                                        const BootstrapLabelText(
                                          child: SelectableText('Phone'),
                                        ),
                                        ReactiveTextField(
                                          formControlName: 'phone',
                                          onSubmitted: (val) {},
                                          decoration:
                                              const BootstrapInputDecoration(),
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
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
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('Address'),
                                    ),
                                    ReactiveTextField(
                                      maxLines: 5,
                                      minLines: 5,
                                      formControlName: 'address',
                                      onSubmitted: (val) {},
                                      decoration:
                                          const BootstrapInputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 12,
                              xl: 12,
                              md: 12,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16,
                                  top: 4,
                                  bottom: 8,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 120,
                                    child: BootstrapButton(
                                      size: BootstrapButtonSize.defaults,
                                      type: BootstrapButtonType.primary,
                                      onPressed: () {
                                        warehouse =
                                            Warehouse.fromJson(formgroup.value);
                                        if (widget.warehouseId == null) {
                                          context
                                              .read<WarehouseBloc>()
                                              .add(PostWarehouse(warehouse));
                                        } else {
                                          warehouse.id = widget.warehouseId;
                                          context
                                              .read<WarehouseBloc>()
                                              .add(PutWarehouse(warehouse));
                                        }
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidFloppyDisk,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Save'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Text("Error Page");
              },
            )
          ],
        ),
      ),
    );
  }
}
