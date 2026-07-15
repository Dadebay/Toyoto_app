import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

enum AppLanguage { tk, en, ru }

extension AppLanguageLabel on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.tk:
        return 'Türkmen';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.ru:
        return 'Русский';
    }
  }

  String get flagAsset {
    switch (this) {
      case AppLanguage.tk:
        return 'assets/flags/tm.svg';
      case AppLanguage.en:
        return 'assets/flags/en.svg';
      case AppLanguage.ru:
        return 'assets/flags/ru.svg';
    }
  }
}

const Map<String, Map<AppLanguage, String>> _strings = {
  'app_name': {
    AppLanguage.tk: 'BMW Connect',
    AppLanguage.en: 'BMW Connect',
    AppLanguage.ru: 'BMW Connect',
  },
  'greeting': {
    AppLanguage.tk: 'Salam, Ahmet!',
    AppLanguage.en: 'Hello, Ahmet!',
    AppLanguage.ru: 'Здравствуйте, Ахмет!',
  },
  'greeting_sub': {
    AppLanguage.tk: 'Awtoulagyňyzyň ýagdaýy gowy',
    AppLanguage.en: 'Your vehicle is in great shape',
    AppLanguage.ru: 'Ваш автомобиль в отличном состоянии',
  },
  'drag_to_rotate': {
    AppLanguage.tk: 'Aýlamak üçin süýşüriň',
    AppLanguage.en: 'Drag to rotate',
    AppLanguage.ru: 'Проведите, чтобы повернуть',
  },
  'loading_model': {
    AppLanguage.tk: 'Ulagyňyz taýýarlanýar...',
    AppLanguage.en: 'Preparing your vehicle...',
    AppLanguage.ru: 'Подготовка автомобиля...',
  },
  'view_in_3d': {
    AppLanguage.tk: '3D görnüşde gör',
    AppLanguage.en: 'View in 3D',
    AppLanguage.ru: 'Смотреть в 3D',
  },
  'my_garage': {
    AppLanguage.tk: 'Ulaglarym',
    AppLanguage.en: 'My Garage',
    AppLanguage.ru: 'Мой гараж',
  },
  // Bottom nav
  'nav_home': {
    AppLanguage.tk: 'Baş sahypa',
    AppLanguage.en: 'Home',
    AppLanguage.ru: 'Главная',
  },
  'nav_car': {
    AppLanguage.tk: 'Ulagym',
    AppLanguage.en: 'My Car',
    AppLanguage.ru: 'Авто',
  },
  'nav_ai': {
    AppLanguage.tk: 'AI Kömekçi',
    AppLanguage.en: 'AI Assistant',
    AppLanguage.ru: 'AI Помощник',
  },
  'nav_store': {
    AppLanguage.tk: 'Store',
    AppLanguage.en: 'Store',
    AppLanguage.ru: 'Магазин',
  },
  'nav_profile': {
    AppLanguage.tk: 'Profilim',
    AppLanguage.en: 'Profile',
    AppLanguage.ru: 'Профиль',
  },
  // Quick actions grid (home + my car)
  'qa_fuel': {
    AppLanguage.tk: 'Gulagyn doly',
    AppLanguage.en: 'Fuel Level',
    AppLanguage.ru: 'Уровень топлива',
  },
  'qa_service_report': {
    AppLanguage.tk: 'Hyzmat hasabaty',
    AppLanguage.en: 'Service Report',
    AppLanguage.ru: 'Отчёт о сервисе',
  },
  'qa_location': {
    AppLanguage.tk: 'Lokasiýa',
    AppLanguage.en: 'Location',
    AppLanguage.ru: 'Локация',
  },
  'qa_service_booking': {
    AppLanguage.tk: 'Servis bron',
    AppLanguage.en: 'Book Service',
    AppLanguage.ru: 'Запись на сервис',
  },
  'qa_warranty': {
    AppLanguage.tk: 'Kepillik',
    AppLanguage.en: 'Warranty',
    AppLanguage.ru: 'Гарантия',
  },
  'qa_support': {
    AppLanguage.tk: 'Resmi goldaw',
    AppLanguage.en: 'Official Support',
    AppLanguage.ru: 'Официальная поддержка',
  },
  'qa_remote': {
    AppLanguage.tk: 'Uzakdan dolandyryş',
    AppLanguage.en: 'Remote Connect',
    AppLanguage.ru: 'Удалённый доступ',
  },
  'qa_nearby_service': {
    AppLanguage.tk: 'Ýakyn servis',
    AppLanguage.en: 'Nearby Service',
    AppLanguage.ru: 'Ближайший сервис',
  },
  'qa_health': {
    AppLanguage.tk: 'Saglyk hasabaty',
    AppLanguage.en: 'Health Check',
    AppLanguage.ru: 'Диагностика',
  },
  'qa_notifications': {
    AppLanguage.tk: 'Bildirişler',
    AppLanguage.en: 'Notifications',
    AppLanguage.ru: 'Уведомления',
  },
  'qa_settings': {
    AppLanguage.tk: 'Sazlamalar',
    AppLanguage.en: 'Settings',
    AppLanguage.ru: 'Настройки',
  },
  'qa_climate': {
    AppLanguage.tk: 'Klima',
    AppLanguage.en: 'Climate',
    AppLanguage.ru: 'Климат',
  },
  'climate_title': {
    AppLanguage.tk: 'Klimat dolandyryşy',
    AppLanguage.en: 'Climate Control',
    AppLanguage.ru: 'Управление климатом',
  },
  'fan_speed': {
    AppLanguage.tk: 'Ýelpuwaç tizligi',
    AppLanguage.en: 'Fan Speed',
    AppLanguage.ru: 'Скорость вентилятора',
  },
  'ac': {
    AppLanguage.tk: 'Kondisioner',
    AppLanguage.en: 'A/C',
    AppLanguage.ru: 'Кондиционер',
  },
  'auto': {
    AppLanguage.tk: 'Awtomatik',
    AppLanguage.en: 'Auto',
    AppLanguage.ru: 'Авто',
  },
  'defrost': {
    AppLanguage.tk: 'Aýna gyzdyryjy',
    AppLanguage.en: 'Defrost',
    AppLanguage.ru: 'Обогрев стекла',
  },
  'recirculate': {
    AppLanguage.tk: 'Howa aýlanyşy',
    AppLanguage.en: 'Recirculate',
    AppLanguage.ru: 'Рециркуляция',
  },
  'driver_seat': {
    AppLanguage.tk: 'Sürüji oturgyjy',
    AppLanguage.en: 'Driver Seat',
    AppLanguage.ru: 'Сиденье водителя',
  },
  'passenger_seat': {
    AppLanguage.tk: 'Ýolagçy oturgyjy',
    AppLanguage.en: 'Passenger Seat',
    AppLanguage.ru: 'Пассажирское сиденье',
  },
  'seat_heating': {
    AppLanguage.tk: 'Oturgyç ýyladyjy',
    AppLanguage.en: 'Seat Heating',
    AppLanguage.ru: 'Подогрев сидений',
  },
  'qa_engine_report': {
    AppLanguage.tk: 'Motor hasabaty',
    AppLanguage.en: 'Engine Report',
    AppLanguage.ru: 'Отчёт двигателя',
  },
  'qa_orders': {
    AppLanguage.tk: 'Sargyt taryhy',
    AppLanguage.en: 'Order History',
    AppLanguage.ru: 'История заказов',
  },
  'qa_service': {
    AppLanguage.tk: 'Servis',
    AppLanguage.en: 'Service',
    AppLanguage.ru: 'Сервис',
  },
  'qa_showroom': {
    AppLanguage.tk: 'Täze ulaglar',
    AppLanguage.en: 'Showroom',
    AppLanguage.ru: 'Шоурум',
  },
  'qa_trade_in': {
    AppLanguage.tk: 'Takas bahasy',
    AppLanguage.en: 'Trade-In Value',
    AppLanguage.ru: 'Стоимость трейд-ин',
  },
  // My Car
  'my_car_title': {
    AppLanguage.tk: 'Ulagym',
    AppLanguage.en: 'My Car',
    AppLanguage.ru: 'Мой автомобиль',
  },
  'vin_label': {
    AppLanguage.tk: 'VIN belgisi',
    AppLanguage.en: 'VIN number',
    AppLanguage.ru: 'VIN номер',
  },
  'mileage_label': {
    AppLanguage.tk: 'Ýöreýşi',
    AppLanguage.en: 'Mileage',
    AppLanguage.ru: 'Пробег',
  },
  'upcoming_service': {
    AppLanguage.tk: 'Indiki hyzmat',
    AppLanguage.en: 'Upcoming Service',
    AppLanguage.ru: 'Следующее ТО',
  },
  // Remote Connect
  'remote_title': {
    AppLanguage.tk: 'Uzakdan dolandyryş',
    AppLanguage.en: 'Remote Connect',
    AppLanguage.ru: 'Удалённое управление',
  },
  'connected': {
    AppLanguage.tk: 'Birikdirildi',
    AppLanguage.en: 'Connected',
    AppLanguage.ru: 'Подключено',
  },
  'lock': {
    AppLanguage.tk: 'Gulplamak',
    AppLanguage.en: 'Lock',
    AppLanguage.ru: 'Заблокировать',
  },
  'unlock': {
    AppLanguage.tk: 'Açmak',
    AppLanguage.en: 'Unlock',
    AppLanguage.ru: 'Разблокировать',
  },
  'unlocked': {
    AppLanguage.tk: 'Gapylar açyk',
    AppLanguage.en: 'Doors unlocked',
    AppLanguage.ru: 'Двери открыты',
  },
  'locked': {
    AppLanguage.tk: 'Gapylar gulplandy',
    AppLanguage.en: 'Doors locked',
    AppLanguage.ru: 'Двери заблокированы',
  },
  'horn': {
    AppLanguage.tk: 'Gyžžyrma',
    AppLanguage.en: 'Horn',
    AppLanguage.ru: 'Сигнал',
  },
  'lights': {
    AppLanguage.tk: 'Çyralar',
    AppLanguage.en: 'Lights',
    AppLanguage.ru: 'Фары',
  },
  'engine_start': {
    AppLanguage.tk: 'Motory işlet',
    AppLanguage.en: 'Start Engine',
    AppLanguage.ru: 'Завести двигатель',
  },
  'tap_to_unlock': {
    AppLanguage.tk: 'Açmak üçin basyň',
    AppLanguage.en: 'Tap to unlock',
    AppLanguage.ru: 'Нажмите, чтобы открыть',
  },
  // Location
  'location_title': {
    AppLanguage.tk: 'Ulagyň lokasiýasy',
    AppLanguage.en: 'Vehicle Location',
    AppLanguage.ru: 'Местоположение авто',
  },
  'last_updated': {
    AppLanguage.tk: 'Soňky täzelenme',
    AppLanguage.en: 'Last updated',
    AppLanguage.ru: 'Обновлено',
  },
  'get_directions': {
    AppLanguage.tk: 'Ýol görkezmesi',
    AppLanguage.en: 'Get Directions',
    AppLanguage.ru: 'Проложить маршрут',
  },
  // Nearby service
  'nearby_title': {
    AppLanguage.tk: 'Ýakyn BMW Servisleri',
    AppLanguage.en: 'Nearby BMW Service',
    AppLanguage.ru: 'Ближайшие сервисы BMW',
  },
  'showroom': {
    AppLanguage.tk: 'Showroom',
    AppLanguage.en: 'Showroom',
    AppLanguage.ru: 'Шоурум',
  },
  'service_center': {
    AppLanguage.tk: 'Servis Merkezi',
    AppLanguage.en: 'Service Center',
    AppLanguage.ru: 'Сервисный центр',
  },
  'spare_parts': {
    AppLanguage.tk: 'Ätiýaçlyk şaýlary',
    AppLanguage.en: 'Spare Parts',
    AppLanguage.ru: 'Запчасти',
  },
  'call': {
    AppLanguage.tk: 'Jaň etmek',
    AppLanguage.en: 'Call',
    AppLanguage.ru: 'Позвонить',
  },
  'book_here': {
    AppLanguage.tk: 'Bron etmek',
    AppLanguage.en: 'Book Here',
    AppLanguage.ru: 'Записаться',
  },
  // Book service
  'book_service_title': {
    AppLanguage.tk: 'Servis bron etmek',
    AppLanguage.en: 'Book a Service',
    AppLanguage.ru: 'Запись на сервис',
  },
  'select_service_type': {
    AppLanguage.tk: 'Hyzmat görnüşini saýlaň',
    AppLanguage.en: 'Select service type',
    AppLanguage.ru: 'Выберите тип услуги',
  },
  'select_dealer': {
    AppLanguage.tk: 'Dileri saýlaň',
    AppLanguage.en: 'Select dealer',
    AppLanguage.ru: 'Выберите дилера',
  },
  'select_date': {
    AppLanguage.tk: 'Senäni saýlaň',
    AppLanguage.en: 'Select date',
    AppLanguage.ru: 'Выберите дату',
  },
  'confirm_booking': {
    AppLanguage.tk: 'Bron etmegi tassykla',
    AppLanguage.en: 'Confirm Booking',
    AppLanguage.ru: 'Подтвердить запись',
  },
  'booking_confirmed': {
    AppLanguage.tk: 'Bron edildi!',
    AppLanguage.en: 'Booking confirmed!',
    AppLanguage.ru: 'Запись подтверждена!',
  },
  'oil_change': {
    AppLanguage.tk: 'Ýag çalyşmak',
    AppLanguage.en: 'Oil Change',
    AppLanguage.ru: 'Замена масла',
  },
  'periodic_maintenance': {
    AppLanguage.tk: 'Tehniki hyzmat',
    AppLanguage.en: 'Periodic Maintenance',
    AppLanguage.ru: 'ТО',
  },
  'tire_service': {
    AppLanguage.tk: 'Şina hyzmaty',
    AppLanguage.en: 'Tire Service',
    AppLanguage.ru: 'Шиномонтаж',
  },
  'brake_check': {
    AppLanguage.tk: 'Tormoz barlagy',
    AppLanguage.en: 'Brake Check',
    AppLanguage.ru: 'Проверка тормозов',
  },
  'completed': {
    AppLanguage.tk: 'Tamamlandy',
    AppLanguage.en: 'Completed',
    AppLanguage.ru: 'Завершено',
  },
  // Health check
  'health_title': {
    AppLanguage.tk: 'Saglyk hasabaty',
    AppLanguage.en: 'Health Check Report',
    AppLanguage.ru: 'Отчёт диагностики',
  },
  'overall_score': {
    AppLanguage.tk: 'Umumy netije',
    AppLanguage.en: 'Overall Score',
    AppLanguage.ru: 'Общий балл',
  },
  'engine': {
    AppLanguage.tk: 'Motor',
    AppLanguage.en: 'Engine',
    AppLanguage.ru: 'Двигатель',
  },
  'transmission': {
    AppLanguage.tk: 'Şanzyman',
    AppLanguage.en: 'Transmission',
    AppLanguage.ru: 'Трансмиссия',
  },
  'brakes': {
    AppLanguage.tk: 'Tormoz',
    AppLanguage.en: 'Brakes',
    AppLanguage.ru: 'Тормоза',
  },
  'hybrid_battery': {
    AppLanguage.tk: 'Gibrid batareýa',
    AppLanguage.en: 'Hybrid Battery',
    AppLanguage.ru: 'Гибридная батарея',
  },
  'tires': {
    AppLanguage.tk: 'Tigirler',
    AppLanguage.en: 'Tires',
    AppLanguage.ru: 'Шины',
  },
  'adas': {
    AppLanguage.tk: 'ADAS ulgamy',
    AppLanguage.en: 'ADAS System',
    AppLanguage.ru: 'Система ADAS',
  },
  'last_scan': {
    AppLanguage.tk: 'Soňky barlag',
    AppLanguage.en: 'Last scan',
    AppLanguage.ru: 'Последняя проверка',
  },
  'run_new_scan': {
    AppLanguage.tk: 'Täze barlag başlat',
    AppLanguage.en: 'Run New Scan',
    AppLanguage.ru: 'Запустить проверку',
  },
  'status_excellent': {
    AppLanguage.tk: 'Ajaýyp ýagdaýda',
    AppLanguage.en: 'Excellent condition',
    AppLanguage.ru: 'Отличное состояние',
  },
  'status_good': {
    AppLanguage.tk: 'Gowy ýagdaýda',
    AppLanguage.en: 'Good condition',
    AppLanguage.ru: 'Хорошее состояние',
  },
  'status_attention': {
    AppLanguage.tk: 'Üns talap edýär',
    AppLanguage.en: 'Needs attention',
    AppLanguage.ru: 'Требует внимания',
  },
  // AI assistant
  'ai_title': {
    AppLanguage.tk: 'BMW AI Kömekçisi',
    AppLanguage.en: 'BMW AI Assistant',
    AppLanguage.ru: 'AI Помощник BMW',
  },
  'ai_greeting': {
    AppLanguage.tk: 'Salam! Size nädip kömek edip bilerin?',
    AppLanguage.en: 'Hello! How can I help you today?',
    AppLanguage.ru: 'Здравствуйте! Чем могу помочь?',
  },
  'ai_input_hint': {
    AppLanguage.tk: 'Soragyňyzy ýazyň...',
    AppLanguage.en: 'Type your question...',
    AppLanguage.ru: 'Введите ваш вопрос...',
  },
  'suggest_service': {
    AppLanguage.tk: 'Hyzmat bron etmek isleýärin',
    AppLanguage.en: 'I want to book a service',
    AppLanguage.ru: 'Хочу записаться на сервис',
  },
  'suggest_engine': {
    AppLanguage.tk: 'Motoryň ýagdaýy nähili?',
    AppLanguage.en: 'How is my engine doing?',
    AppLanguage.ru: 'Как состояние двигателя?',
  },
  'suggest_battery': {
    AppLanguage.tk: 'Gibrid batareýa ýagdaýy?',
    AppLanguage.en: 'Hybrid battery status?',
    AppLanguage.ru: 'Состояние гибридной батареи?',
  },
  'suggest_price': {
    AppLanguage.tk: 'Tehniki hyzmatyň bahasy näçe?',
    AppLanguage.en: 'How much does maintenance cost?',
    AppLanguage.ru: 'Какая стоимость ТО?',
  },
  'suggest_location': {
    AppLanguage.tk: 'Ulagym nirede?',
    AppLanguage.en: 'Where is my car?',
    AppLanguage.ru: 'Где моя машина?',
  },
  // Store
  'store_title': {
    AppLanguage.tk: 'BMW Store',
    AppLanguage.en: 'BMW Store',
    AppLanguage.ru: 'Магазин BMW',
  },
  'add_to_cart': {
    AppLanguage.tk: 'Sebede goş',
    AppLanguage.en: 'Add to Cart',
    AppLanguage.ru: 'В корзину',
  },
  'added_to_cart': {
    AppLanguage.tk: 'Sebede goşuldy',
    AppLanguage.en: 'Added to cart',
    AppLanguage.ru: 'Добавлено в корзину',
  },
  'product_details': {
    AppLanguage.tk: 'Önüm barada',
    AppLanguage.en: 'Product Details',
    AppLanguage.ru: 'О товаре',
  },
  'description': {
    AppLanguage.tk: 'Beýany',
    AppLanguage.en: 'Description',
    AppLanguage.ru: 'Описание',
  },
  'oem_code': {
    AppLanguage.tk: 'OEM belgisi',
    AppLanguage.en: 'OEM Code',
    AppLanguage.ru: 'Код OEM',
  },
  'warranty': {
    AppLanguage.tk: 'Kepillik',
    AppLanguage.en: 'Warranty',
    AppLanguage.ru: 'Гарантия',
  },
  'in_stock': {
    AppLanguage.tk: 'Ammarda bar',
    AppLanguage.en: 'In Stock',
    AppLanguage.ru: 'В наличии',
  },
  'months_short': {
    AppLanguage.tk: 'aý',
    AppLanguage.en: 'mo',
    AppLanguage.ru: 'мес',
  },
  'pieces_short': {
    AppLanguage.tk: 'sany',
    AppLanguage.en: 'pcs',
    AppLanguage.ru: 'шт',
  },
  'cart_title': {
    AppLanguage.tk: 'Sebet',
    AppLanguage.en: 'Cart',
    AppLanguage.ru: 'Корзина',
  },
  'cart_empty': {
    AppLanguage.tk: 'Sebediňiz boş',
    AppLanguage.en: 'Your cart is empty',
    AppLanguage.ru: 'Ваша корзина пуста',
  },
  'total': {
    AppLanguage.tk: 'Jemi',
    AppLanguage.en: 'Total',
    AppLanguage.ru: 'Итого',
  },
  'place_order': {
    AppLanguage.tk: 'Sargyt bermek',
    AppLanguage.en: 'Place Order',
    AppLanguage.ru: 'Оформить заказ',
  },
  'order_placed_title': {
    AppLanguage.tk: 'Sargyt kabul edildi!',
    AppLanguage.en: 'Order placed!',
    AppLanguage.ru: 'Заказ оформлен!',
  },
  'order_placed_message': {
    AppLanguage.tk:
        'Sargydyňyz üstünlikli kabul edildi. Iň gysga wagtda siziň bilen habarlaşarys.',
    AppLanguage.en:
        'Your order has been placed successfully. We will contact you shortly.',
    AppLanguage.ru:
        'Ваш заказ успешно оформлен. Мы свяжемся с вами в ближайшее время.',
  },
  'order_history_title': {
    AppLanguage.tk: 'Sargyt taryhy',
    AppLanguage.en: 'Order History',
    AppLanguage.ru: 'История заказов',
  },
  // Notifications
  'notifications_title': {
    AppLanguage.tk: 'Bildirişler',
    AppLanguage.en: 'Notifications',
    AppLanguage.ru: 'Уведомления',
  },
  // Profile
  'profile_title': {
    AppLanguage.tk: 'Profilim',
    AppLanguage.en: 'My Profile',
    AppLanguage.ru: 'Мой профиль',
  },
  'my_vehicles': {
    AppLanguage.tk: 'Ulaglarym',
    AppLanguage.en: 'My Vehicles',
    AppLanguage.ru: 'Мои автомобили',
  },
  'settings': {
    AppLanguage.tk: 'Sazlamalar',
    AppLanguage.en: 'Settings',
    AppLanguage.ru: 'Настройки',
  },
  'logout': {
    AppLanguage.tk: 'Ulgamdan çykmak',
    AppLanguage.en: 'Log Out',
    AppLanguage.ru: 'Выйти',
  },
  'logout_confirm_message': {
    AppLanguage.tk: 'Hakykatdanam ulgamdan çykmak isleýärsiňizmi?',
    AppLanguage.en: 'Are you sure you want to log out?',
    AppLanguage.ru: 'Вы уверены, что хотите выйти?',
  },
  'cancel': {
    AppLanguage.tk: 'Ýatyr',
    AppLanguage.en: 'Cancel',
    AppLanguage.ru: 'Отмена',
  },
  'got_it': {
    AppLanguage.tk: 'Düşnükli',
    AppLanguage.en: 'Got it',
    AppLanguage.ru: 'Понятно',
  },
  // Settings
  'settings_title': {
    AppLanguage.tk: 'Sazlamalar',
    AppLanguage.en: 'Settings',
    AppLanguage.ru: 'Настройки',
  },
  'language': {
    AppLanguage.tk: 'Dil',
    AppLanguage.en: 'Language',
    AppLanguage.ru: 'Язык',
  },
  'push_notifications': {
    AppLanguage.tk: 'Push habarnamalar',
    AppLanguage.en: 'Push Notifications',
    AppLanguage.ru: 'Push-уведомления',
  },
  'sound_effects': {
    AppLanguage.tk: 'Ses effektleri',
    AppLanguage.en: 'Sound Effects',
    AppLanguage.ru: 'Звуковые эффекты',
  },
  'garage_title': {
    AppLanguage.tk: 'Garaž',
    AppLanguage.en: 'Garage',
    AppLanguage.ru: 'Гараж',
  },
  'paint_color': {
    AppLanguage.tk: 'Reňk saýlaň',
    AppLanguage.en: 'Choose Color',
    AppLanguage.ru: 'Выберите цвет',
  },
  'camera_front': {
    AppLanguage.tk: 'Öň',
    AppLanguage.en: 'Front',
    AppLanguage.ru: 'Спереди',
  },
  'camera_side': {
    AppLanguage.tk: 'Ýan',
    AppLanguage.en: 'Side',
    AppLanguage.ru: 'Сбоку',
  },
  'camera_rear': {
    AppLanguage.tk: 'Yza',
    AppLanguage.en: 'Rear',
    AppLanguage.ru: 'Сзади',
  },
  'camera_34': {
    AppLanguage.tk: '3/4',
    AppLanguage.en: '3/4',
    AppLanguage.ru: '3/4',
  },
  'camera_interior': {
    AppLanguage.tk: 'Salon',
    AppLanguage.en: 'Interior',
    AppLanguage.ru: 'Салон',
  },
  'dark_mode': {
    AppLanguage.tk: 'Garaňky tema',
    AppLanguage.en: 'Dark Mode',
    AppLanguage.ru: 'Тёмная тема',
  },
  'about_app': {
    AppLanguage.tk: 'Programma barada',
    AppLanguage.en: 'About App',
    AppLanguage.ru: 'О приложении',
  },
  'version': {
    AppLanguage.tk: 'Wersiýa',
    AppLanguage.en: 'Version',
    AppLanguage.ru: 'Версия',
  },
  'see_all': {
    AppLanguage.tk: 'Hemmesini gör',
    AppLanguage.en: 'See all',
    AppLanguage.ru: 'Показать все',
  },
  // Campaigns carousel
  'campaign_details': {
    AppLanguage.tk: 'Kampaniýa barada',
    AppLanguage.en: 'Campaign details',
    AppLanguage.ru: 'О кампании',
  },
  'campaign_view_product': {
    AppLanguage.tk: 'Önümi gör',
    AppLanguage.en: 'View product',
    AppLanguage.ru: 'Посмотреть товар',
  },
  // Showroom
  'showroom_title': {
    AppLanguage.tk: 'Täze ulaglar',
    AppLanguage.en: 'New Vehicles',
    AppLanguage.ru: 'Новые автомобили',
  },
  'showroom_from': {
    AppLanguage.tk: 'başlangyç baha',
    AppLanguage.en: 'starting from',
    AppLanguage.ru: 'от',
  },
  'showroom_select_trim': {
    AppLanguage.tk: 'Donanym derejesini saýlaň',
    AppLanguage.en: 'Select trim level',
    AppLanguage.ru: 'Выберите комплектацию',
  },
  'showroom_select_color': {
    AppLanguage.tk: 'Reňk saýlaň',
    AppLanguage.en: 'Select color',
    AppLanguage.ru: 'Выберите цвет',
  },
  'showroom_features': {
    AppLanguage.tk: 'Aýratynlyklar',
    AppLanguage.en: 'Features',
    AppLanguage.ru: 'Особенности',
  },
  'showroom_request_quote': {
    AppLanguage.tk: 'Bahalandyryş sora',
    AppLanguage.en: 'Request a Quote',
    AppLanguage.ru: 'Запросить предложение',
  },
  'showroom_quote_sent_title': {
    AppLanguage.tk: 'Sorag ugradyldy!',
    AppLanguage.en: 'Quote requested!',
    AppLanguage.ru: 'Запрос отправлен!',
  },
  'showroom_quote_sent_body': {
    AppLanguage.tk:
        'Bahalandyryş soragyňyz kabul edildi. 24 sagadyň dowamynda siz bilen habarlaşarys.',
    AppLanguage.en:
        'Your quote request has been received. We will contact you within 24 hours.',
    AppLanguage.ru:
        'Ваш запрос принят. Мы свяжемся с вами в течение 24 часов.',
  },
  'showroom_engine': {
    AppLanguage.tk: 'Motor',
    AppLanguage.en: 'Engine',
    AppLanguage.ru: 'Двигатель',
  },
  'showroom_fuel_consumption': {
    AppLanguage.tk: 'Ýangyç sarpy',
    AppLanguage.en: 'Fuel Consumption',
    AppLanguage.ru: 'Расход топлива',
  },
  'showroom_trunk_capacity': {
    AppLanguage.tk: 'Bagaž göwrümi',
    AppLanguage.en: 'Trunk Capacity',
    AppLanguage.ru: 'Объём багажника',
  },
  'showroom_compare': {
    AppLanguage.tk: 'Deňeşdir',
    AppLanguage.en: 'Compare',
    AppLanguage.ru: 'Сравнить',
  },
  'showroom_body_sedan': {
    AppLanguage.tk: 'Sedan',
    AppLanguage.en: 'Sedan',
    AppLanguage.ru: 'Седан',
  },
  'showroom_body_suv': {
    AppLanguage.tk: 'SUV',
    AppLanguage.en: 'SUV',
    AppLanguage.ru: 'Внедорожник',
  },
  'showroom_body_minivan': {
    AppLanguage.tk: 'Miniwen',
    AppLanguage.en: 'Minivan',
    AppLanguage.ru: 'Минивэн',
  },
  // Compare
  'compare_title': {
    AppLanguage.tk: 'Ulaglary deňeşdir',
    AppLanguage.en: 'Compare Vehicles',
    AppLanguage.ru: 'Сравнение автомобилей',
  },
  'compare_pick_car': {
    AppLanguage.tk: 'Ulag saýlaň',
    AppLanguage.en: 'Select a vehicle',
    AppLanguage.ru: 'Выберите автомобиль',
  },
  'compare_price': {
    AppLanguage.tk: 'Baha',
    AppLanguage.en: 'Price',
    AppLanguage.ru: 'Цена',
  },
  'showroom_book_test_drive': {
    AppLanguage.tk: 'Synag sürüşi belläň',
    AppLanguage.en: 'Book a Test Drive',
    AppLanguage.ru: 'Записаться на тест-драйв',
  },
  'showroom_calc_finance': {
    AppLanguage.tk: 'Kredit hasapla',
    AppLanguage.en: 'Calculate Financing',
    AppLanguage.ru: 'Рассчитать кредит',
  },
  'showroom_trade_in': {
    AppLanguage.tk: 'Köne ulagymy tabşyr',
    AppLanguage.en: 'Trade In My Car',
    AppLanguage.ru: 'Обменять мой автомобиль',
  },
  // Test drive
  'qa_test_drive': {
    AppLanguage.tk: 'Synag sürüşi',
    AppLanguage.en: 'Test Drive',
    AppLanguage.ru: 'Тест-драйв',
  },
  'td_title': {
    AppLanguage.tk: 'Synag sürüşini belläň',
    AppLanguage.en: 'Book a Test Drive',
    AppLanguage.ru: 'Запись на тест-драйв',
  },
  'td_select_model': {
    AppLanguage.tk: 'Modeli saýlaň',
    AppLanguage.en: 'Select a model',
    AppLanguage.ru: 'Выберите модель',
  },
  'td_select_dealer': {
    AppLanguage.tk: 'Dileri saýlaň',
    AppLanguage.en: 'Select a dealer',
    AppLanguage.ru: 'Выберите дилера',
  },
  'td_select_datetime': {
    AppLanguage.tk: 'Senäni saýlaň',
    AppLanguage.en: 'Select a date',
    AppLanguage.ru: 'Выберите дату',
  },
  'td_your_info': {
    AppLanguage.tk: 'Maglumatlaryňyz',
    AppLanguage.en: 'Your information',
    AppLanguage.ru: 'Ваши данные',
  },
  'td_name': {
    AppLanguage.tk: 'Ady we familiýasy',
    AppLanguage.en: 'Full name',
    AppLanguage.ru: 'Имя и фамилия',
  },
  'td_phone': {
    AppLanguage.tk: 'Telefon belgisi',
    AppLanguage.en: 'Phone number',
    AppLanguage.ru: 'Номер телефона',
  },
  'td_confirm': {
    AppLanguage.tk: 'Belläp tassykla',
    AppLanguage.en: 'Confirm Booking',
    AppLanguage.ru: 'Подтвердить запись',
  },
  'td_confirmed_title': {
    AppLanguage.tk: 'Synag sürüşi bellendi!',
    AppLanguage.en: 'Test drive booked!',
    AppLanguage.ru: 'Тест-драйв забронирован!',
  },
  'td_confirmed_body': {
    AppLanguage.tk: 'Diler siz bilen tassyklamak üçin habarlaşar.',
    AppLanguage.en: 'The dealer will contact you to confirm the details.',
    AppLanguage.ru: 'Дилер свяжется с вами для подтверждения деталей.',
  },
  // Finance calculator
  'finance_title': {
    AppLanguage.tk: 'Kredit hasaplaýjy',
    AppLanguage.en: 'Finance Calculator',
    AppLanguage.ru: 'Кредитный калькулятор',
  },
  'finance_vehicle_price': {
    AppLanguage.tk: 'Ulagyň bahasy',
    AppLanguage.en: 'Vehicle price',
    AppLanguage.ru: 'Цена автомобиля',
  },
  'finance_down_payment': {
    AppLanguage.tk: 'Başlangyç töleg',
    AppLanguage.en: 'Down payment',
    AppLanguage.ru: 'Первоначальный взнос',
  },
  'finance_term': {
    AppLanguage.tk: 'Möhlet',
    AppLanguage.en: 'Term',
    AppLanguage.ru: 'Срок',
  },
  'finance_months_suffix': {
    AppLanguage.tk: 'aý',
    AppLanguage.en: 'mo',
    AppLanguage.ru: 'мес',
  },
  'finance_monthly_payment': {
    AppLanguage.tk: 'Aýlyk töleg',
    AppLanguage.en: 'Monthly payment',
    AppLanguage.ru: 'Ежемесячный платёж',
  },
  'finance_principal': {
    AppLanguage.tk: 'Esasy bergi',
    AppLanguage.en: 'Principal',
    AppLanguage.ru: 'Основной долг',
  },
  'finance_total_interest': {
    AppLanguage.tk: 'Jemi göterim',
    AppLanguage.en: 'Total interest',
    AppLanguage.ru: 'Общие проценты',
  },
  'finance_total_payment': {
    AppLanguage.tk: 'Jemi töleg',
    AppLanguage.en: 'Total payment',
    AppLanguage.ru: 'Общая сумма',
  },
  // Trade-in
  'tradein_title': {
    AppLanguage.tk: 'Köne ulagyňyzy bahalandyryň',
    AppLanguage.en: 'Value Your Trade-In',
    AppLanguage.ru: 'Оценка вашего авто в трейд-ин',
  },
  'tradein_pick_vehicle': {
    AppLanguage.tk: 'Ulaglarym',
    AppLanguage.en: 'My vehicles',
    AppLanguage.ru: 'Мои автомобили',
  },
  'tradein_manual_entry': {
    AppLanguage.tk: 'Elde girizmek',
    AppLanguage.en: 'Manual entry',
    AppLanguage.ru: 'Ручной ввод',
  },
  'tradein_model': {
    AppLanguage.tk: 'Model',
    AppLanguage.en: 'Model',
    AppLanguage.ru: 'Модель',
  },
  'tradein_year': {
    AppLanguage.tk: 'Öndürilen ýyly',
    AppLanguage.en: 'Year',
    AppLanguage.ru: 'Год выпуска',
  },
  'tradein_mileage': {
    AppLanguage.tk: 'Ýöreýşi (km)',
    AppLanguage.en: 'Mileage (km)',
    AppLanguage.ru: 'Пробег (км)',
  },
  'tradein_condition': {
    AppLanguage.tk: 'Ýagdaýy',
    AppLanguage.en: 'Condition',
    AppLanguage.ru: 'Состояние',
  },
  'tradein_condition_excellent': {
    AppLanguage.tk: 'Ajaýyp',
    AppLanguage.en: 'Excellent',
    AppLanguage.ru: 'Отличное',
  },
  'tradein_condition_good': {
    AppLanguage.tk: 'Gowy',
    AppLanguage.en: 'Good',
    AppLanguage.ru: 'Хорошее',
  },
  'tradein_condition_fair': {
    AppLanguage.tk: 'Ortaça',
    AppLanguage.en: 'Fair',
    AppLanguage.ru: 'Среднее',
  },
  'tradein_estimate_button': {
    AppLanguage.tk: 'Bahalandyr',
    AppLanguage.en: 'Get Estimate',
    AppLanguage.ru: 'Получить оценку',
  },
  'tradein_estimated_value': {
    AppLanguage.tk: 'Çak edilýän baha',
    AppLanguage.en: 'Estimated value',
    AppLanguage.ru: 'Примерная стоимость',
  },
  'tradein_apply_to_showroom': {
    AppLanguage.tk: 'Täze ulaga ulan',
    AppLanguage.en: 'Apply to new car',
    AppLanguage.ru: 'Применить к новому авто',
  },
  'tradein_price_after_tradein': {
    AppLanguage.tk: 'Tabşyrandan soň töleg',
    AppLanguage.en: 'Price after trade-in',
    AppLanguage.ru: 'Цена после трейд-ин',
  },
  // Live service tracking
  'svc_track_title': {
    AppLanguage.tk: 'Servis yzarlamasy',
    AppLanguage.en: 'Service Tracking',
    AppLanguage.ru: 'Отслеживание сервиса',
  },
  'svc_step_received': {
    AppLanguage.tk: 'Kabul edildi',
    AppLanguage.en: 'Received',
    AppLanguage.ru: 'Принят',
  },
  'svc_step_diagnosis': {
    AppLanguage.tk: 'Arıza tespiti',
    AppLanguage.en: 'Diagnosis',
    AppLanguage.ru: 'Диагностика',
  },
  'svc_step_parts': {
    AppLanguage.tk: 'Şaý çalyşmak',
    AppLanguage.en: 'Parts Replacement',
    AppLanguage.ru: 'Замена деталей',
  },
  'svc_step_wash': {
    AppLanguage.tk: 'Ýuwmak',
    AppLanguage.en: 'Wash',
    AppLanguage.ru: 'Мойка',
  },
  'svc_step_ready': {
    AppLanguage.tk: 'Taýýar',
    AppLanguage.en: 'Ready',
    AppLanguage.ru: 'Готово',
  },
  'svc_estimated_ready': {
    AppLanguage.tk: 'Çak edilýän taýýarlyk wagty',
    AppLanguage.en: 'Estimated ready time',
    AppLanguage.ru: 'Ожидаемое время готовности',
  },
  'svc_home_card_title': {
    AppLanguage.tk: 'Ulagyňyz serwisde',
    AppLanguage.en: 'Your car is in service',
    AppLanguage.ru: 'Ваш автомобиль на сервисе',
  },
  'svc_step_label': {
    AppLanguage.tk: 'Ädim',
    AppLanguage.en: 'Step',
    AppLanguage.ru: 'Шаг',
  },
  // Loyalty
  'loyalty_title': {
    AppLanguage.tk: 'Sadyklyk maksatnamasy',
    AppLanguage.en: 'Loyalty Program',
    AppLanguage.ru: 'Программа лояльности',
  },
  'loyalty_points_balance': {
    AppLanguage.tk: 'Bal balansy',
    AppLanguage.en: 'Points balance',
    AppLanguage.ru: 'Баланс баллов',
  },
  'loyalty_tier_bronze': {
    AppLanguage.tk: 'Bürünç',
    AppLanguage.en: 'Bronze',
    AppLanguage.ru: 'Бронза',
  },
  'loyalty_tier_silver': {
    AppLanguage.tk: 'Kümüş',
    AppLanguage.en: 'Silver',
    AppLanguage.ru: 'Серебро',
  },
  'loyalty_tier_gold': {
    AppLanguage.tk: 'Altyn',
    AppLanguage.en: 'Gold',
    AppLanguage.ru: 'Золото',
  },
  'loyalty_history': {
    AppLanguage.tk: 'Bal taryhy',
    AppLanguage.en: 'Points history',
    AppLanguage.ru: 'История баллов',
  },
  'loyalty_member': {
    AppLanguage.tk: 'Agza',
    AppLanguage.en: 'Member',
    AppLanguage.ru: 'Участник',
  },
  'loyalty_earned_toast': {
    AppLanguage.tk: 'puan gazanyldy',
    AppLanguage.en: 'points earned',
    AppLanguage.ru: 'баллов начислено',
  },
  'loyalty_from_parts': {
    AppLanguage.tk: 'Ätiýaçlyk şaý satyn alnyşy',
    AppLanguage.en: 'Spare part purchase',
    AppLanguage.ru: 'Покупка запчасти',
  },
  // Service history / digital service booklet
  'svc_history_title': {
    AppLanguage.tk: 'Sanly servis depderçesi',
    AppLanguage.en: 'Digital Service Booklet',
    AppLanguage.ru: 'Цифровая сервисная книжка',
  },
  'qa_service_history': {
    AppLanguage.tk: 'Servis depderçesi',
    AppLanguage.en: 'Service Booklet',
    AppLanguage.ru: 'Сервисная книжка',
  },
  'svc_history_empty': {
    AppLanguage.tk: 'Heniz servis ýazgysy ýok',
    AppLanguage.en: 'No service records yet',
    AppLanguage.ru: 'Пока нет записей о сервисе',
  },
  'svc_history_share_pdf': {
    AppLanguage.tk: 'PDF görnüşinde paýlaş',
    AppLanguage.en: 'Share as PDF',
    AppLanguage.ru: 'Поделиться как PDF',
  },
  'svc_history_share_success': {
    AppLanguage.tk: 'Taýýarlandy we paýlaşyldy',
    AppLanguage.en: 'Prepared and shared',
    AppLanguage.ru: 'Подготовлено и отправлено',
  },
  'svc_history_warranty_title': {
    AppLanguage.tk: 'Kepillik ýagdaýy',
    AppLanguage.en: 'Warranty Status',
    AppLanguage.ru: 'Статус гарантии',
  },
  'svc_history_warranty_time': {
    AppLanguage.tk: 'Wagt boýunça galan',
    AppLanguage.en: 'Time remaining',
    AppLanguage.ru: 'Осталось по времени',
  },
  'svc_history_warranty_km': {
    AppLanguage.tk: 'Ýöreýiş boýunça galan',
    AppLanguage.en: 'Mileage remaining',
    AppLanguage.ru: 'Осталось по пробегу',
  },
  'svc_history_cost': {
    AppLanguage.tk: 'Bahasy',
    AppLanguage.en: 'Cost',
    AppLanguage.ru: 'Стоимость',
  },
  'svc_history_dealer': {
    AppLanguage.tk: 'Dilerçilik',
    AppLanguage.en: 'Dealer',
    AppLanguage.ru: 'Дилер',
  },
  // Fuel & cost tracking
  'expenses_title': {
    AppLanguage.tk: 'Masraflar',
    AppLanguage.en: 'Fuel & Costs',
    AppLanguage.ru: 'Расходы',
  },
  'qa_expenses': {
    AppLanguage.tk: 'Masraflar',
    AppLanguage.en: 'Expenses',
    AppLanguage.ru: 'Расходы',
  },
  'expenses_fuel': {
    AppLanguage.tk: 'Ýangyç',
    AppLanguage.en: 'Fuel',
    AppLanguage.ru: 'Топливо',
  },
  'expenses_service': {
    AppLanguage.tk: 'Servis',
    AppLanguage.en: 'Service',
    AppLanguage.ru: 'Сервис',
  },
  'expenses_parts': {
    AppLanguage.tk: 'Şaýlar',
    AppLanguage.en: 'Parts',
    AppLanguage.ru: 'Запчасти',
  },
  'expenses_this_month': {
    AppLanguage.tk: 'Bu aý',
    AppLanguage.en: 'This month',
    AppLanguage.ru: 'В этом месяце',
  },
  'expenses_insight_lower': {
    AppLanguage.tk: 'Bu aý geçen aýa görä %{n} az',
    AppLanguage.en: 'This month is %{n} lower than last month',
    AppLanguage.ru: 'В этом месяце на %{n} меньше, чем в прошлом',
  },
  'expenses_insight_higher': {
    AppLanguage.tk: 'Bu aý geçen aýa görä %{n} köp',
    AppLanguage.en: 'This month is %{n} higher than last month',
    AppLanguage.ru: 'В этом месяце на %{n} больше, чем в прошлом',
  },
  // SOS roadside assistance
  'sos_title': {
    AppLanguage.tk: 'Ýol kömegi',
    AppLanguage.en: 'Roadside Assistance',
    AppLanguage.ru: 'Помощь на дороге',
  },
  'sos_hold_to_call': {
    AppLanguage.tk: 'Kömek çagyrmak üçin basyp saklaň',
    AppLanguage.en: 'Hold to call for help',
    AppLanguage.ru: 'Удерживайте, чтобы вызвать помощь',
  },
  'sos_help_dispatched': {
    AppLanguage.tk: 'Kömek ýola çykdy',
    AppLanguage.en: 'Help is on the way',
    AppLanguage.ru: 'Помощь в пути',
  },
  'sos_eta_minutes': {
    AppLanguage.tk: 'Çak edilýän wagt: ~25 min',
    AppLanguage.en: 'Estimated arrival: ~25 min',
    AppLanguage.ru: 'Ожидаемое время: ~25 мин',
  },
  'sos_tow_truck_label': {
    AppLanguage.tk: 'Ýardam ulagy',
    AppLanguage.en: 'Tow truck',
    AppLanguage.ru: 'Эвакуатор',
  },
  'sos_your_location': {
    AppLanguage.tk: 'Siziň ýeriňiz',
    AppLanguage.en: 'Your location',
    AppLanguage.ru: 'Ваше местоположение',
  },
  'sos_cancel_request': {
    AppLanguage.tk: 'Islegi ýatyr',
    AppLanguage.en: 'Cancel request',
    AppLanguage.ru: 'Отменить запрос',
  },
  // Digital key sharing
  'keyshare_title': {
    AppLanguage.tk: 'Açary paýlaşmak',
    AppLanguage.en: 'Share Digital Key',
    AppLanguage.ru: 'Поделиться ключом',
  },
  'keyshare_card_title': {
    AppLanguage.tk: 'Sanly açary paýlaşyň',
    AppLanguage.en: 'Share a digital key',
    AppLanguage.ru: 'Поделитесь цифровым ключом',
  },
  'keyshare_card_body': {
    AppLanguage.tk:
        'Maşgala agzasyna wagtlaýyn açar beriň, olar ulagy açyp/gulplap bilerler.',
    AppLanguage.en:
        'Grant a family member temporary access to unlock/lock the car.',
    AppLanguage.ru:
        'Предоставьте члену семьи временный доступ для открытия/блокировки авто.',
  },
  'keyshare_recipient_name': {
    AppLanguage.tk: 'Alyjynyň ady',
    AppLanguage.en: 'Recipient name',
    AppLanguage.ru: 'Имя получателя',
  },
  'keyshare_duration': {
    AppLanguage.tk: 'Möhleti',
    AppLanguage.en: 'Duration',
    AppLanguage.ru: 'Срок',
  },
  'keyshare_duration_1day': {
    AppLanguage.tk: '1 gün',
    AppLanguage.en: '1 day',
    AppLanguage.ru: '1 день',
  },
  'keyshare_duration_1week': {
    AppLanguage.tk: '1 hepde',
    AppLanguage.en: '1 week',
    AppLanguage.ru: '1 неделя',
  },
  'keyshare_duration_1month': {
    AppLanguage.tk: '1 aý',
    AppLanguage.en: '1 month',
    AppLanguage.ru: '1 месяц',
  },
  'keyshare_active_keys': {
    AppLanguage.tk: 'Işjeň açarlar',
    AppLanguage.en: 'Active keys',
    AppLanguage.ru: 'Активные ключи',
  },
  'keyshare_grant': {
    AppLanguage.tk: 'Açar ber',
    AppLanguage.en: 'Grant Key',
    AppLanguage.ru: 'Выдать ключ',
  },
  'keyshare_revoke': {
    AppLanguage.tk: 'Yza al',
    AppLanguage.en: 'Revoke',
    AppLanguage.ru: 'Отозвать',
  },
  'keyshare_expires_in': {
    AppLanguage.tk: 'Möhleti gutarýar',
    AppLanguage.en: 'Expires',
    AppLanguage.ru: 'Истекает',
  },
  'keyshare_no_active_keys': {
    AppLanguage.tk: 'Heniz işjeň açar ýok',
    AppLanguage.en: 'No active keys yet',
    AppLanguage.ru: 'Пока нет активных ключей',
  },
};

extension Localize on BuildContext {
  AppLanguage get _lang => read<AppState>().language;

  String tr(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[_lang] ?? entry[AppLanguage.en] ?? key;
  }
}
