import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_wms/library/common.dart';
import 'package:fl_wms/library/currency_formater.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/screen/product/bloc/product_bloc.dart';
import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProductFormScreen extends StatefulWidget {
  final int? id;
  const ProductFormScreen({super.key, this.id});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  String title = "";
  bool isActive = true;
  bool readOnly = false;
  ItemCategory category = ItemCategory();
  Brand brand = Brand();
  Product product = Product();
  List<ItemConvertion> convertions = [];
  final _currency = NumberFormat("#,##0", "en_US");
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
    'in_expired_date': FormControl<int>(
      // value: 0,
      validators: [Validators.required],
    ),
    'out_expired_date': FormControl<int>(
      // value: 0,
      validators: [Validators.required],
    ),
    'moving': FormControl<String>(
      value: 'FAST',
    ),
    'reminder_qty': FormControl<int>(
      // value: 0,
      validators: [Validators.required],
    ),
    'is_active': FormControl<bool>(value: true)
  });

  @override
  void initState() {
    title = widget.id != null ? "Edit Product" : "Add Product";
    _controller.addListener(() {
      isActive = _controller.value;
      formgroup.control('is_active').value = isActive;
    });
    isActive = _controller.value;
    formgroup.control('is_active').value = isActive;
    context.read<ProductBloc>().add(ProductStandbyForm(id: widget.id));
    readOnly = widget.id == null ? false : true;
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
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const LoadingShimmer();
                } else if (state is ProductFormState) {
                  if (widget.id != null) {
                    formgroup.value = state.product?.toJson();
                    _controller.value = state.product?.isActive ?? false;
                  }
                  return ReactiveForm(
                    formGroup: formgroup,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: CustomForm(
                                formControlName: "code",
                                title: "Code",
                                readOnly: readOnly,
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 8,
                              xl: 8,
                              md: 8,
                              sm: 12,
                              child: const CustomForm(
                                formControlName: "name",
                                title: "Product Name",
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: CustomDropDown<Brand>(
                                title: "Brand",
                                items: state.brands ?? [],
                                itemAsString: (item) => item.name ?? "",
                                onChanged: (br) => brand = br!,
                                selectedItem: brand,
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: CustomDropDown<ItemCategory>(
                                title: "Category",
                                items: state.categories ?? [],
                                itemAsString: (item) => item.name ?? "",
                                onChanged: (ct) => category = ct!,
                                selectedItem: category,
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: const DropdownMoving(
                                  formControlName: "moving"),
                            ),
                            ResponsiveGridCol(
                              child: ResponsiveGridRow(
                                children: [
                                  ResponsiveGridCol(
                                    lg: 3,
                                    md: 3,
                                    xl: 3,
                                    sm: 12,
                                    xs: 12,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 2),
                                      child: state.product!.image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              child: Image.memory(
                                                base64Decode(
                                                    state.product!.image!),
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(12),
                                              padding: const EdgeInsets.all(6),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                                child: GestureDetector(
                                                  onTap: () => picPicture(),
                                                  child: Container(
                                                    height: 150,
                                                    color: const Color.fromARGB(
                                                        255, 253, 253, 249),
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .picture_in_picture_sharp,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text("Select Picture",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .indigo,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 9,
                                    md: 9,
                                    xl: 9,
                                    sm: 12,
                                    xs: 12,
                                    child: ResponsiveGridRow(
                                      children: [
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: CustomForm(
                                            formControlName: "in_expired_date",
                                            title: "Max ED IN (in month)",
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration:
                                                const BootstrapInputDecoration(
                                              hintText: "0",
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: CustomForm(
                                            formControlName: "out_expired_date",
                                            title: "Max ED OUT (in month)",
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration:
                                                const BootstrapInputDecoration(
                                              hintText: "0",
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: CustomForm(
                                            formControlName: "reminder_qty",
                                            title: "Reminder Qty",
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration:
                                                const BootstrapInputDecoration(
                                              hintText: "0",
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: CustomSwitch(
                                            controller: _controller,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ResponsiveGridCol(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BootstrapPanel(
                                  type: BootstrapPanelType.defaults,
                                  header: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Items Convertion",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                      ButtonSave(
                                        title: "Add Items",
                                        iconData: FontAwesomeIcons.circlePlus,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        onPressed: () {
                                          ItemConvertion item = ItemConvertion(
                                            name: "Test 1",
                                            qty: 2,
                                            salePrice: 20000,
                                            uom: null,
                                            sku: "123456789",
                                          );
                                          convertions.add(item);
                                          setState(() {});
                                        },
                                      )
                                    ],
                                  ),
                                  body: DataTable(
                                      headingRowHeight: 40,
                                      columnSpacing: 5,
                                      columns: const [
                                        DataColumn(label: Text("No")),
                                        DataColumn(label: Text("SKU")),
                                        DataColumn(label: Text("Name")),
                                        DataColumn(label: Text("Convertion")),
                                        DataColumn(label: Text("Sale Price")),
                                        DataColumn(label: Text("UOM")),
                                        DataColumn(label: Text("Action")),
                                      ],
                                      rows: convertions
                                          .asMap()
                                          .map((i, e) {
                                            return MapEntry(
                                                i,
                                                DataRow(cells: [
                                                  DataCell(
                                                      Text((i + 1).toString())),
                                                  DataCell(FormFieldTable(
                                                    value: e.sku,
                                                    hinText: "SKU",
                                                    onChanged: (val) =>
                                                        e.sku = val,
                                                  )),
                                                  DataCell(FormFieldTable(
                                                    value: e.name,
                                                    hinText: "Name",
                                                    onChanged: (val) =>
                                                        e.name = val,
                                                  )),
                                                  DataCell(FormFieldTable(
                                                    value:
                                                        _currency.format(e.qty),
                                                    hinText: "Qty Convertion",
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      CurrencyInputFormatter(),
                                                    ],
                                                    onChanged: (val) {
                                                      int value = (val == "")
                                                          ? int.parse("0")
                                                          : int.parse(
                                                              val.replaceAll(
                                                                  ",", ""));
                                                      e.qty =
                                                          value < 1 ? 0 : value;
                                                    },
                                                  )),
                                                  DataCell(FormFieldTable(
                                                    value: _currency
                                                        .format(e.salePrice),
                                                    hinText: "Sale Price",
                                                    onChanged: (val) {
                                                      double value = (val == "")
                                                          ? double.parse("0")
                                                          : double.parse(
                                                              val.replaceAll(
                                                                  ",", ""));
                                                      e.salePrice =
                                                          value < 1 ? 0 : value;
                                                    },
                                                  )),
                                                  DataCell(
                                                      Text(
                                                        e.uom?.name ??
                                                            "--Select UOM--",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      showEditIcon: true,
                                                      onTap: () {
                                                    Common.modalBootstrapt(
                                                        context,
                                                        BootstrapModalSize
                                                            .small,
                                                        title: "Edit UOM",
                                                        showSaveButton: false,
                                                        content:
                                                            CustomDropDown<Uom>(
                                                          title: "Uom",
                                                          showTitle: false,
                                                          items:
                                                              state.uoms ?? [],
                                                          itemAsString:
                                                              (item) =>
                                                                  item.name ??
                                                                  "",
                                                          onChanged: (uom) {
                                                            e.uom = uom!;
                                                            setState(() {});
                                                          },
                                                          selectedItem: e.uom,
                                                        ));
                                                  }),
                                                  const DataCell(
                                                    InkWell(
                                                        child: Text("Remove",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.indigo,
                                                            ))),
                                                  ),
                                                ]));
                                          })
                                          .values
                                          .toList()),
                                  // footer: const SelectableText('Panel Footer'),
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 12,
                              xl: 12,
                              md: 12,
                              sm: 12,
                              child: ButtonSave(
                                onPressed: () {
                                  product = Product.fromJson(formgroup.value);
                                  product.brand = brand;
                                  product.category = category;
                                  if (widget.id == null) {
                                    context
                                        .read<ProductBloc>()
                                        .add(PostProduct(product));
                                  } else {
                                    product.id = widget.id;
                                    context
                                        .read<ProductBloc>()
                                        .add(PutProduct(product));
                                  }
                                },
                              ),
                            )
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

  picPicture() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? xImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      if (xImage != null) {
        Uint8List? webImage = await xImage.readAsBytes();
        // ignore: use_build_context_synchronously
        context.read<ProductBloc>().add(OnTapPicture(webImage));
        setState(() {});
      }
    } else {
      print('err');
    }
  }
}

class FormFieldTable extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? value;
  final String? hinText;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  const FormFieldTable({
    super.key,
    this.onChanged,
    this.value,
    this.hinText,
    this.inputFormatters,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        textAlign: textAlign ?? TextAlign.start,
        initialValue: value,
        decoration: BootstrapInputDecoration(hintText: hinText),
      ),
    );
  }
}

class ButtonSave extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final IconData? iconData;
  final String? title;
  const ButtonSave(
      {super.key, this.onPressed, this.iconData, this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            left: 16.0,
            right: 16,
            top: 25,
            bottom: 25,
          ),
      child: Center(
        child: SizedBox(
          width: 130,
          child: BootstrapButton(
            size: BootstrapButtonSize.defaults,
            type: BootstrapButtonType.primary,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  iconData ?? FontAwesomeIcons.solidFloppyDisk,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(title ?? "save"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final ValueNotifier<bool> controller;
  const CustomSwitch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
      child: BootstrapFormGroup(
        direction: Axis.horizontal,
        children: [
          const BootstrapLabelText(
            child: SelectableText('Status'),
          ),
          AdvancedSwitch(
            controller: controller,
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
    );
  }
}

class DropdownMoving extends StatelessWidget {
  final String formControlName;
  const DropdownMoving({super.key, required this.formControlName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: BootstrapFormGroup(
        children: [
          const BootstrapLabelText(
            child: SelectableText('Product Moving Flow'),
          ),
          ReactiveDropdownField<String>(
            hint: const Text('Select Moving Flow...'),
            formControlName: formControlName,
            decoration: const BootstrapInputDecoration(),
            items: const [
              DropdownMenuItem(value: "FAST", child: Text("FAST MOVING")),
              DropdownMenuItem(value: "MEDIUM", child: Text("MEDIUM MOVING")),
              DropdownMenuItem(value: "SLOW", child: Text("SLOW MOVING")),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDropDown<T> extends StatelessWidget {
  final String? title;
  final DropdownSearchItemAsString<T>? itemAsString;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final T? selectedItem;
  final bool? showTitle;
  final EdgeInsetsGeometry? padding;
  const CustomDropDown({
    super.key,
    this.itemAsString,
    required this.items,
    this.onChanged,
    this.selectedItem,
    this.title,
    this.showTitle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: BootstrapFormGroup(
        children: [
          Visibility(
            visible: showTitle ?? true,
            child: BootstrapLabelText(
              child: SelectableText(title ?? ""),
            ),
          ),
          DropdownSearch<T>(
            itemAsString: itemAsString,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
            ),
            items: items,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: BootstrapInputDecoration(),
            ),
            onChanged: onChanged,
            selectedItem: selectedItem,
          ),
        ],
      ),
    );
  }
}

class CustomForm extends StatelessWidget {
  final bool? readOnly;
  final String title;
  final String formControlName;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  const CustomForm({
    super.key,
    this.readOnly,
    required this.title,
    required this.formControlName,
    this.textAlign,
    this.keyboardType,
    this.inputFormatters,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: BootstrapFormGroup(
        children: [
          BootstrapLabelText(
            child: SelectableText(title),
          ),
          ReactiveTextField(
            formControlName: formControlName,
            readOnly: readOnly ?? false,
            decoration: decoration ?? const BootstrapInputDecoration(),
            textAlign: textAlign ?? TextAlign.start,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}
