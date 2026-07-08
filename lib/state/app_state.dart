import 'package:flutter/material.dart';

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

  AppLanguage get language => _language;
  bool get locked => _locked;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  Map<Product, int> get cart => Map.unmodifiable(_cart);
  int get cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);
  double get cartTotal =>
      _cart.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);

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
}
