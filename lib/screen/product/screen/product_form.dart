import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/screen/product/bloc/product_bloc.dart';
import 'package:fl_wms/screen/product/data/product.dart';
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
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProductForm extends StatefulWidget {
  final int? id;
  const ProductForm({super.key, this.id});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String title = "";
  bool isActive = true;
  bool readOnly = false;
  ItemCategory category = ItemCategory();
  Brand brand = Brand();
  Product product = Product();
  File? image;
  Uint8List webImage = Uint8List(8);
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
                              lg: 8,
                              xl: 8,
                              md: 8,
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
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('Brand'),
                                    ),
                                    DropdownSearch<Brand>(
                                      itemAsString: (item) => item.name ?? "",
                                      popupProps: const PopupProps.menu(
                                        showSearchBox: true,
                                      ),
                                      items: state.brands ?? [],
                                      dropdownBuilder: (c, b) {
                                        return Text(b?.name ?? "");
                                      },
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            BootstrapInputDecoration(),
                                      ),
                                      onChanged: (br) => brand = br!,
                                      selectedItem: brand,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child: SelectableText('Category'),
                                    ),
                                    DropdownSearch<ItemCategory>(
                                      itemAsString: (item) => item.name ?? "",
                                      popupProps: const PopupProps.menu(
                                        showSearchBox: true,
                                      ),
                                      items: state.categories ?? [],
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            BootstrapInputDecoration(),
                                      ),
                                      onChanged: (ct) => category = ct!,
                                      selectedItem: category,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 4,
                              xl: 4,
                              md: 4,
                              sm: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: BootstrapFormGroup(
                                  children: [
                                    const BootstrapLabelText(
                                      child:
                                          SelectableText('Product Moving Flow'),
                                    ),
                                    ReactiveDropdownField<String>(
                                      hint: const Text('Select Moving Flow...'),
                                      formControlName: 'moving',
                                      decoration:
                                          const BootstrapInputDecoration(),
                                      items: const [
                                        DropdownMenuItem(
                                            value: "FAST",
                                            child: Text("FAST MOVING")),
                                        DropdownMenuItem(
                                            value: "MEDIUM",
                                            child: Text("MEDIUM MOVING")),
                                        DropdownMenuItem(
                                            value: "SLOW",
                                            child: Text("SLOW MOVING")),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: GestureDetector(
                                            onTap: () => picPicture(),
                                            child: image != null
                                                ? Image.memory(
                                                    webImage,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Container(
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
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 2),
                                            child: BootstrapFormGroup(
                                              children: [
                                                const BootstrapLabelText(
                                                  child: SelectableText(
                                                      'Max ED IN (in month)'),
                                                ),
                                                ReactiveTextField(
                                                  textAlign: TextAlign.end,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  formControlName:
                                                      'in_expired_date',
                                                  onSubmitted: (val) {},
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                          hintText: "0"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 2),
                                            child: BootstrapFormGroup(
                                              children: [
                                                const BootstrapLabelText(
                                                  child: SelectableText(
                                                      'Max ED OUT (in month)'),
                                                ),
                                                ReactiveTextField(
                                                  textAlign: TextAlign.end,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  formControlName:
                                                      'out_expired_date',
                                                  onSubmitted: (val) {},
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                          hintText: "0"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 2),
                                            child: BootstrapFormGroup(
                                              children: [
                                                const BootstrapLabelText(
                                                  child: SelectableText(
                                                      'Reminder Qty'),
                                                ),
                                                ReactiveTextField(
                                                  textAlign: TextAlign.end,
                                                  formControlName:
                                                      'reminder_qty',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onSubmitted: (val) {},
                                                  decoration:
                                                      const BootstrapInputDecoration(
                                                          hintText: "0"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ResponsiveGridCol(
                                          lg: 4,
                                          xl: 4,
                                          md: 4,
                                          sm: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 25),
                                            child: BootstrapFormGroup(
                                              direction: Axis.horizontal,
                                              children: [
                                                const BootstrapLabelText(
                                                  child:
                                                      SelectableText('Status'),
                                                ),
                                                AdvancedSwitch(
                                                  controller: _controller,
                                                  activeColor:
                                                      BootstrapColors.success,
                                                  inactiveColor:
                                                      BootstrapColors.danger,
                                                  activeChild:
                                                      const Text('Active'),
                                                  inactiveChild:
                                                      const Text('Inactive'),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  width: 90.0,
                                                  height: 35.0,
                                                  enabled: true,
                                                  disabledOpacity: 0.5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                                  top: 25,
                                  bottom: 25,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 120,
                                    child: BootstrapButton(
                                      size: BootstrapButtonSize.defaults,
                                      type: BootstrapButtonType.primary,
                                      onPressed: () {
                                        product =
                                            Product.fromJson(formgroup.value);
                                        product.brand = brand;
                                        product.category = category;
                                        // product.image = base64Encode(webImage);
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

  Future picPicture() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? xImage = await picker.pickImage(source: ImageSource.gallery);
      if (xImage != null) {
        webImage = await xImage.readAsBytes();
        image = File("a");
        setState(() {});
      }
    } else {
      print('err');
    }
  }
}
