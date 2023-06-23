import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTemplate extends StatelessWidget {
  final String title;
  final Color? color;
  final Widget? content;
  final VoidCallback? onPressed;
  final bool? showAddButton;
  const CardTemplate({
    this.color,
    required this.title,
    this.content,
    Key? key,
    this.onPressed,
    this.showAddButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultCardTitle(title, showAddButton: showAddButton),
            content ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class DefaultCardTitle extends StatelessWidget {
  final String title;
  final bool? showAddButton;

  const DefaultCardTitle(this.title, {Key? key, this.showAddButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          ActionAddButton(onPressed: () {}, showAddButton: showAddButton),
        ],
      ),
    );
  }
}

class ActionAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool? showAddButton;
  const ActionAddButton({Key? key, this.onPressed, this.showAddButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showAddButton ?? false,
      child: MaterialButton(
        minWidth: 100,
        height: 40,
        onPressed: onPressed,
        color: const Color.fromARGB(255, 84, 106, 230),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Row(
          children: [
            FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 15),
            SizedBox(width: 1),
            Text(
              "Add Data",
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
