import 'package:riverpod_annotation/riverpod_annotation.dart'; 

part 'language_provider.g.dart';

@riverpod
class Language extends _$Language {
  @override
  String build() {
    // Default to 'en' (English). You can load this from local storage if you want persistence.
    // For now, we will return 'en' and allow the user to change it.
    return 'en';
  }

  void setLanguage(String langCode) {
    state = langCode;
  }
}
