import 'package:flutter/material.dart';

class DefaultTitle extends StatelessWidget {
  final String title;
  final bool? showSubtitle;
  const DefaultTitle(this.title, {Key? key, this.showSubtitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
          Visibility(
            visible: showSubtitle!,
            child: Text("Home / $title"),
          ),
        ],
      ),
    );
  }
}
