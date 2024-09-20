import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

class Loading extends StatelessWidget {
  const Loading(
      {super.key, this.text = 'Verificando ......', this.isLoading = true});
  final String? text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isLoading
              ? ZoomIn(
                  child: Image.asset(logoApp, height: isLoading ? 150 : 50))
              : ZoomOut(
                  duration: const Duration(seconds: 1),
                  child: Image.asset(logoApp, height: 50)),
          isLoading
              ? BounceInDown(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'loadi',
                            style: TextStyle(
                                color: colorsRed,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'ng',
                            style: TextStyle(
                                color: colorsGreenLevel,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 5),
          isLoading
              ? const SizedBox(width: 150, child: LinearProgressIndicator())
              : const SizedBox(),
          const SizedBox(height: 5),
          isLoading
              ? Bounce(
                  child: Text(text ?? 'Verificando ......',
                      style: style.titleMedium))
              : ZoomIn(
                  child: Text(text ?? 'Verificando ......',
                      style: style.titleMedium))
        ],
      ),
    );
  }
}

Future waitingTime(Function ready) async {
  await Future.delayed(const Duration(seconds: 2));
  ready();
}
