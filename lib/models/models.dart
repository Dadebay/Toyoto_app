class Vehicle {
  final String model;
  final String vin;
  final int mileageKm;
  final String plate;
  final double fuelPercent;
  final DateTime nextServiceDate;
  final int nextServiceKm;
  final String modelAsset;
  final String paintMaterialName;
  final double latitude;
  final double longitude;
  final String address;

  const Vehicle({
    required this.model,
    required this.vin,
    required this.mileageKm,
    required this.plate,
    required this.fuelPercent,
    required this.nextServiceDate,
    required this.nextServiceKm,
    required this.modelAsset,
    required this.paintMaterialName,
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Dealer {
  final String name;
  final String city;
  final String address;
  final String phone;
  final double distanceKm;
  final List<String> services; // showroom, service, parts

  const Dealer({
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.distanceKm,
    required this.services,
  });
}

class HealthMetric {
  final String key; // localization key
  final List<List<dynamic>> icon;
  final int score; // 0-100

  const HealthMetric({
    required this.key,
    required this.icon,
    required this.score,
  });
}

class Product {
  final String nameTk;
  final String nameEn;
  final String nameRu;
  final String descriptionTk;
  final String descriptionEn;
  final String descriptionRu;
  final double price;
  final String imageAsset;
  final String oemCode;
  final int warrantyMonths;
  final int stockCount;

  const Product({
    required this.nameTk,
    required this.nameEn,
    required this.nameRu,
    required this.descriptionTk,
    required this.descriptionEn,
    required this.descriptionRu,
    required this.price,
    required this.imageAsset,
    required this.oemCode,
    required this.warrantyMonths,
    required this.stockCount,
  });
}

class Order {
  final String productNameTk;
  final String productNameEn;
  final String productNameRu;
  final DateTime date;
  final double price;
  final String statusTk;
  final String statusEn;
  final String statusRu;
  final String imageAsset;

  const Order({
    required this.productNameTk,
    required this.productNameEn,
    required this.productNameRu,
    required this.date,
    required this.price,
    required this.statusTk,
    required this.statusEn,
    required this.statusRu,
    required this.imageAsset,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AppNotification {
  final String titleTk;
  final String titleEn;
  final String titleRu;
  final String bodyTk;
  final String bodyEn;
  final String bodyRu;
  final List<List<dynamic>> icon;
  final DateTime time;
  final bool read;

  const AppNotification({
    required this.titleTk,
    required this.titleEn,
    required this.titleRu,
    required this.bodyTk,
    required this.bodyEn,
    required this.bodyRu,
    required this.icon,
    required this.time,
    this.read = false,
  });
}
