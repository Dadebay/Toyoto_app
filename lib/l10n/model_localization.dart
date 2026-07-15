import '../models/models.dart';
import 'strings.dart';

extension ProductLocalization on Product {
  String name(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return nameTk;
      case AppLanguage.en:
        return nameEn;
      case AppLanguage.ru:
        return nameRu;
    }
  }

  String description(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return descriptionTk;
      case AppLanguage.en:
        return descriptionEn;
      case AppLanguage.ru:
        return descriptionRu;
    }
  }
}

extension OrderLocalization on Order {
  String productName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return productNameTk;
      case AppLanguage.en:
        return productNameEn;
      case AppLanguage.ru:
        return productNameRu;
    }
  }

  String status(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return statusTk;
      case AppLanguage.en:
        return statusEn;
      case AppLanguage.ru:
        return statusRu;
    }
  }
}

extension TrimLevelLocalization on TrimLevel {
  String name(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return nameTk;
      case AppLanguage.en:
        return nameEn;
      case AppLanguage.ru:
        return nameRu;
    }
  }

  List<String> features(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return featuresTk;
      case AppLanguage.en:
        return featuresEn;
      case AppLanguage.ru:
        return featuresRu;
    }
  }
}

extension NewCarListingLocalization on NewCarListing {
  String name(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return nameTk;
      case AppLanguage.en:
        return nameEn;
      case AppLanguage.ru:
        return nameRu;
    }
  }

  String engine(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return engineTk;
      case AppLanguage.en:
        return engineEn;
      case AppLanguage.ru:
        return engineRu;
    }
  }
}

extension LoyaltyTransactionLocalization on LoyaltyTransaction {
  String description(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return descriptionTk;
      case AppLanguage.en:
        return descriptionEn;
      case AppLanguage.ru:
        return descriptionRu;
    }
  }
}

extension ServiceHistoryRecordLocalization on ServiceHistoryRecord {
  String description(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return descriptionTk;
      case AppLanguage.en:
        return descriptionEn;
      case AppLanguage.ru:
        return descriptionRu;
    }
  }
}

extension CampaignLocalization on Campaign {
  String title(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return titleTk;
      case AppLanguage.en:
        return titleEn;
      case AppLanguage.ru:
        return titleRu;
    }
  }

  String body(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return bodyTk;
      case AppLanguage.en:
        return bodyEn;
      case AppLanguage.ru:
        return bodyRu;
    }
  }
}

extension NotificationLocalization on AppNotification {
  String title(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return titleTk;
      case AppLanguage.en:
        return titleEn;
      case AppLanguage.ru:
        return titleRu;
    }
  }

  String body(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.tk:
        return bodyTk;
      case AppLanguage.en:
        return bodyEn;
      case AppLanguage.ru:
        return bodyRu;
    }
  }
}
