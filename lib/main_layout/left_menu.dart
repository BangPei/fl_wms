import 'package:fl_wms/widget/left_expaxiontile.dart';
import 'package:fl_wms/widget/left_listtile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LeftMenu extends StatelessWidget {
  final double menuSize;
  final bool showMenu;
  final String menu;
  final Function(double) onPressed;
  const LeftMenu({
    super.key,
    required this.menuSize,
    required this.onPressed,
    required this.showMenu,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: menuSize,
      duration: const Duration(milliseconds: 200),
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(236, 236, 236, 1),
            blurRadius: 20,
            spreadRadius: 0.01,
            offset: Offset(1, 3),
          ),
          BoxShadow(
            color: Color.fromRGBO(236, 236, 236, 1),
            blurRadius: 50,
            spreadRadius: 0.01,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          HeaderMenu(size: menuSize),
          const Divider(height: 20, color: Colors.transparent),
          Expanded(
              child: MainMenu(
            size: menuSize,
            menu: menu,
          )),
          Footer(
            showMenu: showMenu,
            size: menuSize,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class HeaderMenu extends StatefulWidget {
  final double size;
  const HeaderMenu({super.key, required this.size});

  @override
  State<HeaderMenu> createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(252, 252, 252, 1),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 235, 233, 233),
              spreadRadius: 1,
            )
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Visibility(
                visible: widget.size > 100,
                replacement: const CircleAvatar(
                  backgroundImage: AssetImage('images/man.png'),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/man.png'),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Company Name",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(218, 98, 74, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final double size;
  final String menu;
  const MainMenu({super.key, required this.size, required this.menu});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Product",
          menu: widget.menu,
          icon: FontAwesomeIcons.productHunt,
          // expanded: true,
          children: widget.size > 60
              ? [
                  const LeftListTile(
                    title: "Management Product",
                    routeName: "product",
                  ),
                  const LeftListTile(
                    title: "Add Product",
                    routeName: "product/form",
                  ),
                  const LeftListTile(
                    title: "Brand",
                    routeName: "brand",
                  ),
                  const LeftListTile(
                    title: "Category",
                    routeName: "category",
                  ),
                  const LeftListTile(
                    title: "UOM",
                    routeName: "uom",
                  ),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Warehouse",
          menu: widget.menu,
          icon: FontAwesomeIcons.buildingShield,
          children: widget.size > 60
              ? [
                  const LeftListTile(
                    title: "Management Warehouse",
                    routeName: "warehouse",
                  ),
                  const LeftListTile(
                    title: "Add Warehouse",
                    routeName: "warehouse/form",
                  ),
                  const LeftListTile(
                    title: "Palette",
                    routeName: "palette",
                  ),
                  const LeftListTile(
                    title: "Rack",
                    routeName: "rack",
                  ),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Order",
          menu: widget.menu,
          icon: FontAwesomeIcons.firstOrderAlt,
          children: widget.size > 60
              ? [
                  const LeftListTile(title: "Purchase"),
                  const LeftListTile(title: "Sales"),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Customer",
          menu: widget.menu,
          icon: FontAwesomeIcons.bullseye,
          // expanded: true,
          children: widget.size > 60
              ? [
                  const LeftListTile(title: "Management Customer"),
                  const LeftListTile(title: "Add Cutomer"),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Supplier",
          menu: widget.menu,
          icon: FontAwesomeIcons.downLeftAndUpRightToCenter,
          // expanded: true,
          children: widget.size > 60
              ? [
                  const LeftListTile(title: "Management Supplier"),
                  const LeftListTile(title: "Add Supplier"),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Stock",
          icon: FontAwesomeIcons.store,
          menu: widget.menu,
          children: widget.size > 60
              ? [
                  const LeftListTile(title: "Inbound"),
                  const LeftListTile(title: "Outbound"),
                  const LeftListTile(title: "Mutation"),
                ]
              : [],
        ),
        LeftExpantionTile(
          visibility: widget.size > 60,
          title: "Report",
          menu: widget.menu,
          icon: FontAwesomeIcons.bookAtlas,
          children: widget.size > 60
              ? [
                  const LeftListTile(title: "Tracking"),
                  const LeftListTile(title: "Product Moving"),
                ]
              : [],
        ),
        LeftListTile(
          visibility: widget.size > 60,
          title: "User",
          icon: FontAwesomeIcons.users,
        ),
        LeftListTile(
          visibility: widget.size > 60,
          title: "Setting",
          icon: FontAwesomeIcons.gears,
        ),
      ],
    );
  }
}

class Footer extends StatefulWidget {
  final double size;
  final bool showMenu;
  final Function(double) onPressed;
  const Footer(
      {super.key,
      required this.onPressed,
      required this.size,
      required this.showMenu});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  double _size = 250;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(252, 252, 252, 1),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(6),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 235, 233, 233),
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.size > 60,
            child: const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "WMS Version. 1.0.0",
                  style: TextStyle(
                    color: Color.fromRGBO(218, 98, 74, 1),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _size = widget.size < 250 ? 250 : 60;
                  widget.onPressed(_size);
                });
              },
              icon: Icon(widget.showMenu
                  ? FontAwesomeIcons.bars
                  : FontAwesomeIcons.xmark),
              color: const Color.fromRGBO(218, 98, 74, 1),
            ),
          ),
        ],
      ),
    );
  }
}
