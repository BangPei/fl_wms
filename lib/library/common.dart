import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Common {
  static Future modalBootstrapt(
    context,
    BootstrapModalSize size, {
    required String title,
    Widget? content,
    final VoidCallback? onSave,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BootstrapModal(
          size: size,
          dismissble: true,
          title: Text(title),
          content: content ??
              const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
          actions: [
            BootstrapButton(
              type: BootstrapButtonType.defaults,
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BootstrapButton(
              type: BootstrapButtonType.primary,
              onPressed: onSave,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  static modalInfo(BuildContext context,
      {String? message, required String title, Icon? icon}) {
    showDialog(
      context: context,
      builder: (__) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Divider(height: 2, thickness: 3),
                icon ??
                    const FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
                      size: 50,
                    ),
                Text(
                  message ?? "Message",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
