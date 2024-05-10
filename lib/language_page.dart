import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../translate_service.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale;
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages'.tr),
      ),
      body: ListView.builder(
        itemCount: TranslationService.languages.length,
        itemBuilder: (context, index) {
          final language = TranslationService.languages[index];
          final icon = _getLanguageIcon(language);
          final isSelected = currentLocale?.languageCode ==
              TranslationService.locales[index].languageCode;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(language),
              trailing: isSelected ? Icon(Icons.check) : null,
              leading: Icon(icon),
              onTap: () {
                TranslationService.changeLocale(
                    TranslationService.locales[index].toLanguageTag());
                Get.back(); // Close the language page
                print('Translated title: ${'Languages'.tr}');
              },
            ),
          );
        },
      ),
    );
  }

  IconData? _getLanguageIcon(String language) {
    switch (language) {
      case 'English':
        return Icons.language;
      case 'Hindi':
        return IconData(0x092F, fontFamily: 'MaterialIcons'); // Hindi icon
      case 'Gujarati':
        return IconData(0x0AA4, fontFamily: 'MaterialIcons'); // Gujarati icon
      default:
        return null;
    }
  }
}
