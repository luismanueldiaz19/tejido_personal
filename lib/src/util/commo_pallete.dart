import 'package:flutter/material.dart';

const Color colorsAd = Color(0xff2A2638);
const Color colorsRed = Color(0xffB0040C);
const Color colorsRedVino = Color(0xff7A0104);
const Color colorsRedVinoHard = Color(0xff62070C);
const Color colorsRedOpaco = Color(0xff953234);
const Color colorsBlueTurquesa = Color(0xff0E79F2);
const Color colorsBlueDeepHigh = Color(0xff2D71A3);
const Color colorsPuppleOpaco = Color(0xff6D386B);
const Color colorsGreenLevel = Color(0xff3A7A40);
const Color colorsGreyWhite = Color(0xffE0DFE5);
const Color colorsGreyGrey = Color.fromARGB(255, 194, 184, 241);
const Color colorsOrange = Color.fromARGB(255, 209, 154, 82);

const Color ktejidoblue = Color(0xff8282ff);
const Color ktejidoblueOpaco = Color(0xff9a9abe);
const Color ktejidoBlueOcuro = Color(0xff34004d);

const Color ktejidogrey = Color.fromARGB(255, 99, 103, 124);

ButtonStyle styleButton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.resolveWith((states) => ktejidoBlueOcuro),
    shape: MaterialStateProperty.resolveWith((states) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))));
