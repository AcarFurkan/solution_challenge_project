import 'package:flutter/material.dart';

enum ImageConstants {
  microphone('microphone'),
  appIcon('nutrition_app'),
  missedDay('nutrition_missed_day'),
  upcomingNutrition('upcoming_nutrition'),
  ;

  final String value;
  // ignore: sort_constructors_first
  const ImageConstants(this.value);

  String get toPng => 'assets/images/$value.png';
  Image get toImage => Image.asset(toPng);
}
