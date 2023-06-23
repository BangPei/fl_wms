import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeftListTile extends StatefulWidget {
  final String title;
  final bool? visibility;
  final bool? selected;
  final IconData? icon;
  final GestureTapCallback? onTap;

  const LeftListTile({
    Key? key,
    required this.title,
    this.visibility,
    this.icon,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  State<LeftListTile> createState() => _LeftListTileState();
}

class _LeftListTileState extends State<LeftListTile> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visibility ?? true,
      replacement: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Icon(
          widget.icon,
          color: (isHover || (widget.selected ?? false))
              ? Colors.blue[400]
              : const Color.fromRGBO(238, 182, 172, 1),
          size: 22,
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          isHover = true;
          setState(() {});
        },
        onExit: (event) {
          isHover = false;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.only(left: (widget.icon == null ? 10 : 0)),
          color: (widget.selected ?? false)
              ? const Color.fromARGB(255, 241, 198, 198).withOpacity(0.2)
              : Colors.white,
          child: ListTile(
            onTap: widget.onTap,
            leading: Icon(
              widget.icon ?? FontAwesomeIcons.circleDot,
              color: (isHover || (widget.selected ?? false))
                  ? Colors.blue[400]
                  : const Color.fromRGBO(238, 182, 172, 1),
              size: (widget.icon != null) ? 22 : 15,
            ),
            selectedColor: const Color.fromRGBO(218, 98, 74, 1),
            selected: widget.selected ?? false,
            title: Text(
              widget.title,
              style: TextStyle(
                fontSize: 13,
                color: (isHover || (widget.selected ?? false))
                    ? Colors.blue[400]
                    : const Color.fromARGB(255, 78, 78, 78),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
