import 'package:flutter/material.dart';

class LeftExpantionTile extends StatefulWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? children;
  final bool? expanded;
  final bool? visibility;
  final ValueChanged<bool>? onExpansionChanged;
  const LeftExpantionTile({
    Key? key,
    required this.title,
    this.icon,
    this.children,
    this.expanded,
    this.onExpansionChanged,
    this.visibility,
  }) : super(key: key);

  @override
  State<LeftExpantionTile> createState() => _LeftExpantionTileState();
}

class _LeftExpantionTileState extends State<LeftExpantionTile> {
  IconData iconData = Icons.arrow_right;
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visibility ?? true,
      replacement: MouseRegion(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            widget.icon ?? Icons.card_travel,
            size: 25,
            color: (isHover || (widget.expanded ?? false))
                ? Colors.blue[400]
                : const Color.fromRGBO(238, 182, 172, 1),
          ),
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
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: widget.expanded ?? false,
            title: Text(
              widget.title,
              style: TextStyle(
                fontSize: 13,
                color: (isHover || (widget.expanded ?? false))
                    ? Colors.blue[400]
                    : const Color.fromARGB(255, 78, 78, 78),
              ),
            ),
            leading: Icon(
              widget.icon ?? Icons.card_travel,
              size: 25,
              color: (isHover || (widget.expanded ?? false))
                  ? Colors.blue[400]
                  : const Color.fromRGBO(238, 182, 172, 1),
            ),
            trailing: (widget.children ?? []).isEmpty
                ? const SizedBox.shrink()
                : Icon(
                    iconData,
                    color: (isHover || (widget.expanded ?? false))
                        ? Colors.blue[400]
                        : const Color.fromRGBO(238, 182, 172, 1),
                  ),
            onExpansionChanged: widget.onExpansionChanged ??
                (data) {
                  iconData = data ? Icons.arrow_drop_down : Icons.arrow_right;
                  setState(() {});
                },
            children: widget.children ?? const [],
          ),
        ),
      ),
    );
  }
}
