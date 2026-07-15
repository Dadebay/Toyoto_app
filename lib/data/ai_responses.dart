import '../l10n/strings.dart';

/// Simple offline, rule-based canned responses for the AI assistant demo.
/// Keyword matching is language-agnostic (checks TK/EN/RU keywords together)
/// so the bot feels responsive regardless of which language the user types in.
String getAiResponse(String input, AppLanguage lang) {
  final text = input.toLowerCase();

  bool has(List<String> words) => words.any(text.contains);

  if (has(['salam', 'hello', 'hi', 'привет', 'здравств'])) {
    return {
      AppLanguage.tk:
          'Salam! Size BMW M4 CSL ulagyňyz barada nähili kömek gerek?',
      AppLanguage.en:
          'Hello! How can I help with your BMW M4 CSL today?',
      AppLanguage.ru:
          'Здравствуйте! Чем могу помочь с вашим BMW M4 CSL?',
    }[lang]!;
  }

  if (has(['servis', 'service', 'сервис', 'bron', 'appointment', 'запис'])) {
    return {
      AppLanguage.tk:
          'Elbetde! Iň ýakyn BMW Aşgabat merkezine 3 günden bron edip bilerin. Dowam etjekmi?',
      AppLanguage.en:
          'Sure! I can book you the nearest slot at BMW Aşgabat in 3 days. Shall I proceed?',
      AppLanguage.ru:
          'Конечно! Могу записать вас в ближайший BMW Aşgabat через 3 дня. Продолжить?',
    }[lang]!;
  }

  if (has(['motor', 'engine', 'двигат'])) {
    return {
      AppLanguage.tk:
          'Motoryňyzyň saglyk balы 96/100. Hemme görkezijiler kadaly.',
      AppLanguage.en:
          'Your engine health score is 96/100. All readings are within normal range.',
      AppLanguage.ru:
          'Оценка состояния двигателя — 96/100. Все показатели в норме.',
    }[lang]!;
  }

  if (has(['batare', 'battery', 'батаре', 'gibrid', 'hybrid', 'гибрид'])) {
    return {
      AppLanguage.tk:
          'Gibrid batareýaňyzyň ýagdaýy 89% — henizem gowy derejede.',
      AppLanguage.en:
          'Your hybrid battery health is at 89% — still in great condition.',
      AppLanguage.ru:
          'Состояние гибридной батареи — 89%, всё ещё в отличном состоянии.',
    }[lang]!;
  }

  if (has(['baha', 'price', 'narx', 'цена', 'стоим', 'cost'])) {
    return {
      AppLanguage.tk:
          'Adaty tehniki hyzmatyň bahasy ätiýaçlyk şaýlaryna görä 250-450 manat aralygynda bolýar.',
      AppLanguage.en:
          'A standard maintenance service typically costs between \$250-450 depending on parts needed.',
      AppLanguage.ru:
          'Стандартное ТО обычно стоит от 250 до 450 долларов в зависимости от необходимых запчастей.',
    }[lang]!;
  }

  if (has(['lokas', 'location', 'локац', 'nirede', 'where', 'где'])) {
    return {
      AppLanguage.tk:
          'Ulagyňyzyň soňky belli lokasiýasy: Arçabil şaýoly, Aşgabat.',
      AppLanguage.en:
          'Your vehicle\'s last known location is: Arçabil Avenue, Aşgabat.',
      AppLanguage.ru:
          'Последнее известное местоположение вашего авто: проспект Арчабил, Ашхабад.',
    }[lang]!;
  }

  if (has(['sag bol', 'thank', 'спасиб', 'rahmet'])) {
    return {
      AppLanguage.tk:
          'Hoş geldiňiz! Başga sorag bar bolsa, men hemişe şu ýerde.',
      AppLanguage.en:
          'You\'re welcome! I\'m here anytime you have more questions.',
      AppLanguage.ru: 'Пожалуйста! Обращайтесь, если появятся ещё вопросы.',
    }[lang]!;
  }

  return {
    AppLanguage.tk:
        'Düşnükli. Bu barada size iň ýakyn BMW hyzmat merkezi arkaly jikme-jik maglumat berip bilerin. Servis bron etmek isleýärsiňizmi?',
    AppLanguage.en:
        'Got it. I can connect you with the nearest BMW service center for more details. Would you like to book a service?',
    AppLanguage.ru:
        'Понял вас. Могу подробнее уточнить это в ближайшем сервисном центре BMW. Хотите записаться на сервис?',
  }[lang]!;
}
