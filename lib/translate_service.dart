import 'dart:ui';

import 'package:get/get.dart';

class TranslationService extends Translations {
  static final locale = RxString('en_US');

  static final fallbackLocale = Locale('en', 'US');

  static final languages = [
    'English', // English
    'Hindi', // Hindi
    'Gujarati', // Gujarati
  ];

  static final locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('gu', 'IN'),
  ];
  static void changeLocale(String localeCode) {
    final index = locales.indexWhere((element) => element.toLanguageTag() == localeCode);
    print('Selected language: $localeCode, Index: $index');
    if (index != -1) {
      locale.value = localeCode;
      Get.updateLocale(locales[index]);
    }
    else {
      print('Locale code not found: $localeCode');
    }
  }
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          "app_title": "My App",
          "hello": "Hello!",
          "Home": "Home",
          "ON": "ON",
          "OFF": "OFF",
          "Sensors Details": "Sensors Details",
          "Sensor Button": "Sensor Button",
          "Settings": "Settings",
          "Notification": "Notification",
          "Accounts": "Account",
          "Account Details": "Account Details",
          "Languages": "Languages",
          "About Us": "About Us",
          "Cancel": "Cancel",
          "Feedback": "Feedback",
          "Logout": "Logout",
          "Are You sure you want to Logout?": "Are You sure you want to Logout?",
          "Name": "Name",
          "Email": "Email",
          "Feedback Type": "Feedback Type",
          "Submit": "Submit",
          "Message": "Message",
          "The button is ON": "The button is ON",
          "The button is OFF": "The button is OFF",
          "See the old Records": "See the old Records"
        },
        'hi_IN': {
          "app_title": "मेरा ऐप",
          "hello": "नमस्ते!",
          "ON": "चालू",
          "OFF": "बंद",
          "Home": "होम ",
          "Sensors Details": "सेंसर विवरण",
          "Sensor Button": "सेंसर बटन",
          "Settings": "सेटिंग्स",
          "Notification": "अधिसूचना",
          "Accounts": "खाता",
          "Account Details": "खाता विवरण",
          "Languages": "भाषाओं",
          "About Us": "हमारे बारे में",
          "Cancel": "रद्द करें",
          "Feedback": "प्रतिक्रिया",
          "Logout": "लॉग आउट",
          "Are You sure you want to Logout?": "क्या आप लॉग आउट करना चाहते हैं?",
          "Name": "नाम",
          "Email": "ईमेल",
          "Feedback Type": "प्रतिक्रिया प्रकार",
          "Submit": "जमा करना",
          "Message": "संदेश",
          "The button is ON": "बटन चालू है",
          "The button is OFF": "बटन बंद है",
          "See the old Records": "पुराने रिकॉर्ड देखें"
        },
        'gu_IN': {
          "app_title": "મારો એપ",
          "hello": "હેલો!",
          "ON": "ચાલુ",
          "OFF": "બંધ",
          "Home": "ઘર",
          "Sensors Details": "સેન્સર વિગતો",
          "Sensor Button": "સેન્સર બટન",
          "Settings": "સુયોજનો",
          "Notification": "સૂચના",
          "Accounts": "ખાતું",
          "Account Details": "ખાતાની માહિતી",
          "Languages": "ભાષાઓ",
          "About Us": "અમારા વિશે",
          "Cancel": "રદ કરો",
          "Feedback": "પ્રતિસાદ",
          "Logout": "લૉગ આઉટ",
          "Are You sure you want to Logout?": "શું તમે ખરેખર લોગઆઉટ કરવા માંગો છો?",
          "Name": "નામ",
          "Email": "ઇમેઇલ",
          "Feedback Type": "પ્રતિસાદ પ્રકાર",
          "Submit": "સબમિટ કરો",
          "Message": "સંદેશ",
          "The button is ON": "બટન ચાલુ છે",
          "The button is OFF": "બટન બંધ છે",
          "See the old Records": "જૂના રેકોર્ડ જુઓ"
        }
      };
  }