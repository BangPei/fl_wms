import 'package:fl_wms/widget/card_template.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    title = widget.warehouseId != null ? "Edit Warehouse" : "Add Warehouse";
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
            ReactiveForm(
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
                              horizontal: 16.0, vertical: 4),
                          child: BootstrapFormGroup(
                            children: [
                              const BootstrapLabelText(
                                child: SelectableText('Code'),
                              ),
                              ReactiveTextField(
                                formControlName: 'code',
                                onSubmitted: (val) {},
                                decoration: const BootstrapInputDecoration(),
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
                              horizontal: 16.0, vertical: 4),
                          child: BootstrapFormGroup(
                            children: [
                              const BootstrapLabelText(
                                child: SelectableText('Name'),
                              ),
                              ReactiveTextField(
                                formControlName: 'name',
                                onSubmitted: (val) {},
                                decoration: const BootstrapInputDecoration(),
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
                              horizontal: 16.0, vertical: 4),
                          child: BootstrapFormGroup(
                            children: [
                              const BootstrapLabelText(
                                child: SelectableText('PIC'),
                              ),
                              ReactiveTextField(
                                formControlName: 'pic',
                                onSubmitted: (val) {},
                                decoration: const BootstrapInputDecoration(),
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
                              horizontal: 16.0, vertical: 4),
                          child: BootstrapFormGroup(
                            children: [
                              const BootstrapLabelText(
                                child: SelectableText('Phone'),
                              ),
                              ReactiveTextField(
                                formControlName: 'pic_phone',
                                onSubmitted: (val) {},
                                decoration: const BootstrapInputDecoration(),
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
                              horizontal: 16.0, vertical: 4),
                          child: Column(
                            children: [
                              BootstrapFormGroup(
                                children: [
                                  const BootstrapLabelText(
                                    child: SelectableText('Phone'),
                                  ),
                                  ReactiveTextField(
                                    formControlName: 'pic_phone',
                                    onSubmitted: (val) {},
                                    decoration:
                                        const BootstrapInputDecoration(),
                                  ),
                                ],
                              ),
                              BootstrapFormGroup(
                                children: [
                                  const BootstrapLabelText(
                                    child: SelectableText('Phone'),
                                  ),
                                  ReactiveTextField(
                                    formControlName: 'pic_phone',
                                    onSubmitted: (val) {},
                                    decoration:
                                        const BootstrapInputDecoration(),
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
                              horizontal: 16.0, vertical: 4),
                          child: BootstrapFormGroup(
                            children: [
                              const BootstrapLabelText(
                                child: SelectableText('Address'),
                              ),
                              ReactiveTextField(
                                maxLines: 6,
                                minLines: 6,
                                formControlName: 'address',
                                onSubmitted: (val) {},
                                decoration: const BootstrapInputDecoration(),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4),
                          child: Center(
                            child: SizedBox(
                              width: 120,
                              child: BootstrapButton(
                                size: BootstrapButtonSize.defaults,
                                type: BootstrapButtonType.primary,
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ],
        ),
      ),
    );
  }
}
