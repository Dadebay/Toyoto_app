import 'package:flutter/material.dart' show Color;

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

class TrimLevel {
  final String nameTk;
  final String nameEn;
  final String nameRu;
  final double priceDelta;
  final List<String> featuresTk;
  final List<String> featuresEn;
  final List<String> featuresRu;

  const TrimLevel({
    required this.nameTk,
    required this.nameEn,
    required this.nameRu,
    required this.priceDelta,
    required this.featuresTk,
    required this.featuresEn,
    required this.featuresRu,
  });
}

class NewCarListing {
  final String id;
  final String nameTk;
  final String nameEn;
  final String nameRu;
  final double basePrice;
  final String modelAsset;
  final String paintMaterialName;
  final String engineTk;
  final String engineEn;
  final String engineRu;
  final double fuelConsumption; // l/100km
  final String bodyType; // sedan, suv, minivan
  final int trunkCapacityLiters;
  final List<TrimLevel> trims;

  const NewCarListing({
    required this.id,
    required this.nameTk,
    required this.nameEn,
    required this.nameRu,
    required this.basePrice,
    required this.modelAsset,
    required this.paintMaterialName,
    required this.engineTk,
    required this.engineEn,
    required this.engineRu,
    required this.fuelConsumption,
    required this.bodyType,
    required this.trunkCapacityLiters,
    required this.trims,
  });
}

class TestDriveBooking {
  final String carName;
  final Dealer dealer;
  final DateTime date;
  final String name;
  final String phone;

  const TestDriveBooking({
    required this.carName,
    required this.dealer,
    required this.date,
    required this.name,
    required this.phone,
  });
}

class ServiceTicket {
  final Vehicle vehicle;
  final int currentStep; // 0-4
  final DateTime startedAt;
  final DateTime estimatedReadyAt;

  const ServiceTicket({
    required this.vehicle,
    required this.currentStep,
    required this.startedAt,
    required this.estimatedReadyAt,
  });

  ServiceTicket copyWith({int? currentStep}) => ServiceTicket(
    vehicle: vehicle,
    currentStep: currentStep ?? this.currentStep,
    startedAt: startedAt,
    estimatedReadyAt: estimatedReadyAt,
  );
}

class LoyaltyTransaction {
  final String descriptionTk;
  final String descriptionEn;
  final String descriptionRu;
  final int points;
  final DateTime date;
  final List<List<dynamic>> icon;

  const LoyaltyTransaction({
    required this.descriptionTk,
    required this.descriptionEn,
    required this.descriptionRu,
    required this.points,
    required this.date,
    required this.icon,
  });
}

class ServiceHistoryRecord {
  final Vehicle vehicle;
  final DateTime date;
  final int mileageKm;
  final String descriptionTk;
  final String descriptionEn;
  final String descriptionRu;
  final double cost;
  final String dealerName;

  const ServiceHistoryRecord({
    required this.vehicle,
    required this.date,
    required this.mileageKm,
    required this.descriptionTk,
    required this.descriptionEn,
    required this.descriptionRu,
    required this.cost,
    required this.dealerName,
  });
}

class MonthlyExpense {
  final DateTime month;
  final double fuelCost;
  final double serviceCost;
  final double partsCost;

  const MonthlyExpense({
    required this.month,
    required this.fuelCost,
    required this.serviceCost,
    required this.partsCost,
  });

  double get total => fuelCost + serviceCost + partsCost;
}

class SharedKey {
  final String id;
  final String holderName;
  final DateTime grantedAt;
  final DateTime expiresAt;

  const SharedKey({
    required this.id,
    required this.holderName,
    required this.grantedAt,
    required this.expiresAt,
  });
}

class Campaign {
  final String titleTk;
  final String titleEn;
  final String titleRu;
  final String bodyTk;
  final String bodyEn;
  final String bodyRu;
  final List<List<dynamic>> icon;
  final List<Color> gradient;
  final String? linkedProductOemCode;

  const Campaign({
    required this.titleTk,
    required this.titleEn,
    required this.titleRu,
    required this.bodyTk,
    required this.bodyEn,
    required this.bodyRu,
    required this.icon,
    required this.gradient,
    this.linkedProductOemCode,
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
