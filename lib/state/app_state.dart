import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';

class AppState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.tk;
  bool _locked = true;
  bool _pushNotificationsEnabled = true;
  bool _soundEnabled = true;
  final List<ChatMessage> _chatMessages = [];
  final Map<Product, int> _cart = {};
  final List<AppNotification> _notifications = [...MockData.notifications];
  final List<TestDriveBooking> _testDriveBookings = [];
  ServiceTicket? _activeServiceTicket;
  int _loyaltyPoints = 1250;
  final List<LoyaltyTransaction> _loyaltyTransactions = [
    ...MockData.seedLoyaltyTransactions,
  ];
  final List<SharedKey> _sharedKeys = [];

  AppLanguage get language => _language;
  bool get locked => _locked;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  Map<Product, int> get cart => Map.unmodifiable(_cart);
  int get cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);
  double get cartTotal =>
      _cart.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<TestDriveBooking> get testDriveBookings =>
      List.unmodifiable(_testDriveBookings);
  ServiceTicket? get activeServiceTicket => _activeServiceTicket;
  int get loyaltyPoints => _loyaltyPoints;
  List<LoyaltyTransaction> get loyaltyTransactions =>
      List.unmodifiable(_loyaltyTransactions);
  String get loyaltyTier {
    if (_loyaltyPoints >= 3000) return 'gold';
    if (_loyaltyPoints >= 1000) return 'silver';
    return 'bronze';
  }

  List<SharedKey> get sharedKeys => List.unmodifiable(_sharedKeys);

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void bookTestDrive(TestDriveBooking booking) {
    _testDriveBookings.add(booking);
    notifyListeners();
  }

  void addLoyaltyPoints(
    int points, {
    required String descriptionTk,
    required String descriptionEn,
    required String descriptionRu,
    required List<List<dynamic>> icon,
  }) {
    _loyaltyPoints += points;
    _loyaltyTransactions.insert(
      0,
      LoyaltyTransaction(
        descriptionTk: descriptionTk,
        descriptionEn: descriptionEn,
        descriptionRu: descriptionRu,
        points: points,
        date: DateTime.now(),
        icon: icon,
      ),
    );
    notifyListeners();
  }

  void startServiceTicket(ServiceTicket ticket) {
    _activeServiceTicket = ticket;
    notifyListeners();
  }

  void advanceServiceStep() {
    final ticket = _activeServiceTicket;
    if (ticket == null || ticket.currentStep >= 4) return;
    final nextStep = ticket.currentStep + 1;
    _activeServiceTicket = ticket.copyWith(currentStep: nextStep);
    const stepNotes = [
      (
        tk: 'Ulagyňyz kabul edildi',
        en: 'Your vehicle has been received',
        ru: 'Ваш автомобиль принят',
      ),
      (
        tk: 'Arıza tespiti tamamlandy',
        en: 'Diagnosis completed',
        ru: 'Диагностика завершена',
      ),
      (
        tk: 'Zerur şaýlar çalşyryldy',
        en: 'Required parts have been replaced',
        ru: 'Необходимые детали заменены',
      ),
      (
        tk: 'Ulagyňyz ýuwuldy',
        en: 'Your vehicle has been washed',
        ru: 'Ваш автомобиль вымыт',
      ),
    ];
    final note = stepNotes[nextStep - 1];
    addNotification(
      AppNotification(
        titleTk: 'Servis täzelenmesi',
        titleEn: 'Service update',
        titleRu: 'Обновление сервиса',
        bodyTk: note.tk,
        bodyEn: note.en,
        bodyRu: note.ru,
        icon: HugeIcons.strokeRoundedWrench01,
        time: DateTime.now(),
      ),
    );
  }

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

  void toggleLock() {
    _locked = !_locked;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _pushNotificationsEnabled = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    SoundService.instance.enabled = value;
    notifyListeners();
  }

  void addChatMessage(ChatMessage message) {
    _chatMessages.add(message);
    notifyListeners();
  }

  void resetChat() {
    _chatMessages.clear();
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1}) {
    _cart[product] = (_cart[product] ?? 0) + quantity;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final qty = _cart[product];
    if (qty == null) return;
    if (qty <= 1) {
      _cart.remove(product);
    } else {
      _cart[product] = qty - 1;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void shareKey(SharedKey key) {
    _sharedKeys.add(key);
    notifyListeners();
  }

  void revokeKey(String id) {
    _sharedKeys.removeWhere((k) => k.id == id);
    notifyListeners();
  }
}
