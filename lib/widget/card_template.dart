import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTemplate extends StatelessWidget {
  final String title;
  final Widget? content;
  final VoidCallback? onPressed;
  final bool? showAddButton;
  const CardTemplate({
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
            DefaultCardTitle(
              title,
              showAddButton: showAddButton,
              onPressed: onPressed,
            ),
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
  final VoidCallback? onPressed;

  const DefaultCardTitle(
    this.title, {
    Key? key,
    this.showAddButton,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          ActionAddButton(onPressed: onPressed, showAddButton: showAddButton),
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
      child: BootstrapButton(
        type: BootstrapButtonType.primary,
        onPressed: onPressed,
        child: const Row(
          children: [
            FaIcon(
              FontAwesomeIcons.circlePlus,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 5),
            Text('Add Data'),
          ],
        ),
        // onLongPress: _onLongPressed,
        // onHover: _onHover,
        // onFocusChange: _onFocusChange,
      ),
    );
  }
}
