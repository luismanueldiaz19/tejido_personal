import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({Key? key, required this.title, this.pressCalendar})
      : super(key: key);
  final String title;
  final Function? pressCalendar;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: kToolbarHeight, left: kToolbarHeight / 2),
      child: Row(
        children: [
          const BackButton(),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
