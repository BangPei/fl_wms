import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Common {
  static Future modalBootstrapt(
    context,
    BootstrapModalSize size, {
    required String title,
    Widget? content,
    bool? showSaveButton,
    bool? dismissble,
    VoidCallback? onSave,
    VoidCallback? onClose,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BootstrapModal(
          size: size,
          dismissble: dismissble ?? true,
          title: Text(title),
          content: content ??
              const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
          actions: [
            BootstrapButton(
              type: BootstrapButtonType.defaults,
              onPressed: onClose ??
                  () {
                    Navigator.of(context).pop();
                  },
              child: const Text('Close'),
            ),
            Visibility(
              visible: showSaveButton ?? true,
              child: BootstrapButton(
                type: BootstrapButtonType.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                  onSave!();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        );
      },
    );
  }

  static modalLoading(BuildContext context) {
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                // Some text
                Text('Please Wait...')
              ],
            ),
          ),
        );
      },
    );
  }

  static Future modalSuccess(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleCheck,
                  color: BootstrapColors.success,
                  size: 50,
                ),
                SizedBox(height: 30),
                Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
