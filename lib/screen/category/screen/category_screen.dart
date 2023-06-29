import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/screen/category/bloc/category_bloc.dart';
import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/screen/category/data/category_source.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    context.read<CategoryBloc>().add(const GetCategories());
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return const LoadingShimmer();
        } else if (state is CategoryDataState) {
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
                  "Kategory",
                  onPressed: _openModal,
                  showAddButton: true,
                ),
                columns: const [
                  DataColumn(
                    label: Text("No"),
                  ),
                  DataColumn(
                    label: Text("Kategori"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                source: CategorySource(
                  state.categories,
                  onTap: (i) => _openModal(category: i),
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

  Future _openModal({Category? category}) async {
    if (category != null) {
      formgroup.control("name").value = category.name;
      _controller.value = category.isActive!;
      formgroup.control('is_active').value = category.isActive;
    }
    await Common.modalBootstrapt(
      context,
      BootstrapModalSize.medium,
      title: "Add Category",
      onSave: () {
        Category newCategory = Category.fromJson(formgroup.value);
        if (category != null) {
          newCategory.id = category.id;
          context.read<CategoryBloc>().add(PutCategory(newCategory));
        } else {
          context.read<CategoryBloc>().add(PostCategory(newCategory));
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
                  child: SelectableText('Kategori'),
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
