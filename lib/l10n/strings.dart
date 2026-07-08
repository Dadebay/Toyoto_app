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
    AppLanguage.tk: 'Toyota TM',
    AppLanguage.en: 'Toyota TM',
    AppLanguage.ru: 'Toyota TM',
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
    AppLanguage.tk: 'Ýakyn Toyota Servisleri',
    AppLanguage.en: 'Nearby Toyota Service',
    AppLanguage.ru: 'Ближайшие сервисы Toyota',
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
    AppLanguage.tk: 'Toyota AI Kömekçisi',
    AppLanguage.en: 'Toyota AI Assistant',
    AppLanguage.ru: 'AI Помощник Toyota',
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
    AppLanguage.tk: 'Toyota Store',
    AppLanguage.en: 'Toyota Store',
    AppLanguage.ru: 'Магазин Toyota',
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
};

extension Localize on BuildContext {
  AppLanguage get _lang => read<AppState>().language;

  String tr(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[_lang] ?? entry[AppLanguage.en] ?? key;
  }
}
