import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/library/interceptor/injector.dart';
import 'package:fl_wms/library/interceptor/navigation_service.dart';
import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/uom/bloc/uom_bloc.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:reactive_forms/reactive_forms.dart';

// typedef OnViewRowSelect = void Function(Uom uom);

class UomSource extends AdvancedDataTableSource<Uom> {
  final NavigationService _nav = locator<NavigationService>();
  String searchText = "";
  int _draw = 0;
  bool isActive = true;
  final _controller = ValueNotifier<bool>(true);
  final formgroup = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'alias': FormControl<String>(value: ''),
    'is_active': FormControl<bool>(value: true)
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= lastDetails!.rows.length) {
      return null;
    }
    Uom e = lastDetails!.rows[index];
    if (lastDetails!.rows.isEmpty) {
      return DataRow.byIndex(
        index: index,
        // onSelectChanged: null,
        cells: const [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }
    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.resolveWith((states) {
        if (index % 2 != 0) {
          return Colors.grey.withOpacity(0.1);
        }
        return Colors.white;
      }),
      // onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(SelectableText(e.name ?? "")),
        DataCell(SelectableText(e.alias ?? "")),
        DataCell(badges.Badge(
          badgeContent: Text(
            e.isActive! ? "Active" : "Inactive",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
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
            badgeColor:
                e.isActive! ? BootstrapColors.success : BootstrapColors.danger,
            padding: const EdgeInsets.all(3),
            borderRadius: BorderRadius.circular(9),
            elevation: 0,
          ),
        )),
        DataCell(Row(
          children: [
            GestureDetector(
              onTap: () => openModal(uom: e),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                decoration: BoxDecoration(
                  color: BootstrapColors.primary.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 3),
            // GestureDetector(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
            //     decoration: BoxDecoration(
            //       color: BootstrapColors.danger.withOpacity(0.9),
            //       borderRadius: const BorderRadius.all(
            //         Radius.circular(5),
            //       ),
            //     ),
            //     child: const Row(
            //       children: [
            //         Icon(
            //           Icons.delete,
            //           color: Colors.white,
            //           size: 18,
            //         ),
            //         Text(
            //           "Hapus",
            //           style: TextStyle(color: Colors.white, fontSize: 11),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        )),
      ],
    );
  }

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Uom>> getNextPage(
      NextPageRequest pageRequest) async {
    try {
      _controller.addListener(() {
        isActive = _controller.value;
        formgroup.control('is_active').value = isActive;
      });
      _draw = _draw + 1;
      DataTableModel dataTable = await Api.getDataTable(
        "/api/uom/dataTable",
        start: pageRequest.offset,
        length: pageRequest.pageSize,
        draw: _draw,
        orderColumn: pageRequest.columnSortIndex,
        orderdir: (pageRequest.sortAscending ?? false) ? "asc" : "desc",
        searchText: searchText,
      );
      List<Uom> uoms =
          (dataTable.data ?? []).map((e) => Uom.fromJson(e)).toList();
      return RemoteDataSourceDetails(
        dataTable.recordsTotal ?? 0,
        uoms,
        filteredRows: dataTable.recordsFiltered,
      );
    } catch (e) {
      return RemoteDataSourceDetails(0, [], filteredRows: 0);
    }
  }

  void filterServerSide(String value) {
    searchText = value.toLowerCase().trim();
    setNextView();
  }

  openModal({Uom? uom}) async {
    if (uom != null) {
      formgroup.control("name").value = uom.name;
      _controller.value = uom.isActive!;
      formgroup.control('is_active').value = uom.isActive;
    }
    await Common.modalBootstrapt(
      _nav.navKey.currentContext!,
      BootstrapModalSize.medium,
      title: "Add Uom",
      onSave: () {
        Uom newUom = Uom.fromJson(formgroup.value);
        if (uom != null) {
          newUom.id = uom.id;
          _nav.navKey.currentContext!.read<UomBloc>().add(PutUom(newUom));
        } else {
          _nav.navKey.currentContext!.read<UomBloc>().add(PostUom(newUom));
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
                  onSubmitted: (val) {
                    Uom newUom = Uom.fromJson(formgroup.value);
                    if (uom != null) {
                      newUom.id = uom.id;
                      _nav.navKey.currentContext!
                          .read<UomBloc>()
                          .add(PutUom(newUom));
                    } else {
                      _nav.navKey.currentContext!
                          .read<UomBloc>()
                          .add(PostUom(newUom));
                    }
                    Navigator.of(_nav.navKey.currentContext!).pop();
                  },
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
                  onSubmitted: (val) {
                    Uom newUom = Uom.fromJson(formgroup.value);
                    if (uom != null) {
                      newUom.id = uom.id;
                      _nav.navKey.currentContext!
                          .read<UomBloc>()
                          .add(PutUom(newUom));
                    } else {
                      _nav.navKey.currentContext!
                          .read<UomBloc>()
                          .add(PostUom(newUom));
                    }
                    Navigator.of(_nav.navKey.currentContext!).pop();
                  },
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
    ).then((value) => formgroup.control("name").value = "");
  }
}
