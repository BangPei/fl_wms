import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/screen/brand/bloc/brand_bloc.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final List<PlutoColumn> _columns = [
    PlutoColumn(
      title: 'NO',
      field: 'id',
      type: PlutoColumnType.number(),
      readOnly: true,
      width: 50,
      titleTextAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'Brand',
      field: 'name',
      type: PlutoColumnType.text(),
      readOnly: true,
      titleTextAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'Created',
      field: 'createdAt',
      type: PlutoColumnType.date(format: "dd MMM yyyy HH:mm:ss"),
      readOnly: true,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'Updated',
      field: 'updatedAt',
      type: PlutoColumnType.date(format: "dd MMM yyyy HH:mm:ss"),
      readOnly: true,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'Status',
      field: 'isActive',
      type: PlutoColumnType.text(),
      readOnly: true,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: '',
      field: 'action',
      type: PlutoColumnType.number(),
      readOnly: true,
      width: 80,
      titleTextAlign: PlutoColumnTextAlign.center,
      renderer: (plutoContext) {
        return const Center(child: FaIcon(FontAwesomeIcons.eye));
      },
    ),
  ];

  late PlutoGridStateManager stateManager;
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
            child: CardTemplate(
              title: "Brand",
              showAddButton: true,
              showShimmer: false,
              onPressed: _openModal,
              content: SizedBox(
                height: 400,
                child: PlutoGrid(
                  columns: _columns,
                  rows: state.brands.map((e) {
                    int idx = state.brands.indexOf(e);
                    return PlutoRow(
                      cells: {
                        'id': PlutoCell(value: idx + 1),
                        'name': PlutoCell(value: e.name),
                        'createdAt': PlutoCell(value: e.createdAt),
                        'updatedAt': PlutoCell(value: e.updatedAt),
                        'isActive': PlutoCell(
                            value: (e.isActive ?? false)
                                ? "Aktif"
                                : "Tidak Aktif"),
                        'action': PlutoCell(),
                      },
                    );
                  }).toList(),
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    // ignore: avoid_print
                    print(event);
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    // ignore: avoid_print
                    print(event);
                  },
                  createFooter: (stateManager) {
                    return PlutoPagination(stateManager, pageSizeToMove: 10);
                  },
                  configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(
                      rowHeight: 30,
                      columnHeight: 30,
                      enableGridBorderShadow: true,
                      iconColor: Colors.blue[300]!,
                      borderColor: Colors.grey.withOpacity(0.5),
                      gridBorderRadius: BorderRadius.circular(6),
                      cellTextStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.normal,
                      ),
                      columnTextStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    columnSize: const PlutoGridColumnSizeConfig(
                      autoSizeMode: PlutoAutoSizeMode.scale,
                    ),
                  ),
                ),
              ),
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
