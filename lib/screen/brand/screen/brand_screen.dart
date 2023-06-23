import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_api.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
      titleTextAlign: PlutoColumnTextAlign.center,
      renderer: (plutoContext) {
        return const FaIcon(FontAwesomeIcons.eye);
      },
    ),
  ];

  late PlutoGridStateManager stateManager;
  List<Brand> brands = [];
  bool isLoading = false;

  getBrand() async {
    try {
      isLoading = true;
      BrandApi.getBrands().then((value) {
        setState(() {
          brands = value;
          isLoading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getBrand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: CardTemplate(
              title: "Brand",
              showAddButton: true,
              content: SizedBox(
                height: 200,
                child: PlutoGrid(
                  columns: _columns,
                  rows: brands.map((e) {
                    int idx = brands.indexOf(e);
                    return PlutoRow(
                      cells: {
                        'id': PlutoCell(value: idx + 1),
                        'name': PlutoCell(value: e.name),
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
                    return PlutoPagination(stateManager);
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
  }
}
