import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:todoapp/locales/de.dart';
import 'package:todoapp/locales/en.dart';
import 'package:todoapp/locales/fa.dart';



class TranslationService extends Translations {
  static Locale get locale => Locale('fa', 'IR');
  static final fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'fa': fa,
        'de': de,
      };
}