import 'package:flutter/material.dart';

const gapW4 = SizedBox(width: 4);
const gapW8 = SizedBox(width: 8);
const gapW12 = SizedBox(width: 12);
const gapW16 = SizedBox(width: 16);
const gapW24 = SizedBox(width: 24);
const gapW32 = SizedBox(width: 32);
const gapW40 = SizedBox(width: 40);
const gapW48 = SizedBox(width: 48);
const gapW56 = SizedBox(width: 56);
const gapW64 = SizedBox(width: 6);
const gapH8 = SizedBox(height: 8);
const gapH16 = SizedBox(height: 16);
const gapH24 = SizedBox(height: 24);
const gapH32 = SizedBox(height: 32);
const gapH40 = SizedBox(height: 40);
const gapH48 = SizedBox(height: 48);
const gapH56 = SizedBox(height: 56);
const gapH64 = SizedBox(height: 64);

extension StringUtils on String {
  String get capitalized =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
