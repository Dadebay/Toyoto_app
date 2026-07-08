import '../models/models.dart';
import 'package:hugeicons/hugeicons.dart';

class MockData {
  MockData._();

  static final Vehicle camry = Vehicle(
    model: 'Camry 2025',
    vin: 'JTNB11HK9S1012345',
    mileageKm: 18420,
    plate: '01 AB 4521',
    fuelPercent: 0.82,
    nextServiceDate: DateTime.now().add(const Duration(days: 12)),
    nextServiceKm: 20000,
    modelAsset: 'assets/models/camry.glb',
    paintMaterialName: 'BODY.001',
    latitude: 37.9500,
    longitude: 58.3833,
    address: 'Arçabil şaýoly, Aşgabat',
  );

  static final Vehicle landCruiser = Vehicle(
    model: 'Land Cruiser LC300 VXR',
    vin: 'JTMHV05J104123456',
    mileageKm: 6250,
    plate: '01 BA 7710',
    fuelPercent: 0.95,
    nextServiceDate: DateTime.now().add(const Duration(days: 48)),
    nextServiceKm: 10000,
    modelAsset: 'assets/models/land_cruiser.glb',
    paintMaterialName: 'CarPaint',
    latitude: 37.9601,
    longitude: 58.3908,
    address: 'Bitarap Türkmenistan şaýoly, Aşgabat',
  );

  static final Vehicle camry2020 = Vehicle(
    model: 'Camry 2020',
    vin: 'JTNBB46K003014926',
    mileageKm: 62300,
    plate: '01 AC 1198',
    fuelPercent: 0.54,
    nextServiceDate: DateTime.now().add(const Duration(days: 5)),
    nextServiceKm: 65000,
    modelAsset: 'assets/models/camry_2020.glb',
    paintMaterialName: 'Paint_Color',
    latitude: 37.9452,
    longitude: 58.3701,
    address: 'Görogly köçesi, Aşgabat',
  );

  static final Vehicle camry2016 = Vehicle(
    model: 'Camry 2016',
    vin: 'JTNBF3EK803019284',
    mileageKm: 121400,
    plate: '01 AE 5602',
    fuelPercent: 0.38,
    nextServiceDate: DateTime.now().add(const Duration(days: 3)),
    nextServiceKm: 125000,
    modelAsset: 'assets/models/camry_2016.glb',
    paintMaterialName: 'Carpaint',
    latitude: 37.9381,
    longitude: 58.3958,
    address: 'Magtymguly şaýoly, Aşgabat',
  );

  static final Vehicle landCruiser300Vxr = Vehicle(
    model: 'Land Cruiser 300 VX.R',
    vin: 'JTMHY05J404556781',
    mileageKm: 14800,
    plate: '01 BB 9042',
    fuelPercent: 0.88,
    nextServiceDate: DateTime.now().add(const Duration(days: 60)),
    nextServiceKm: 20000,
    modelAsset: 'assets/models/land_cruiser_300_vxr.glb',
    paintMaterialName: 'TMI_1350010001_044',
    latitude: 37.9552,
    longitude: 58.3654,
    address: 'Andalyp köçesi, Aşgabat',
  );

  static final Vehicle granvia = Vehicle(
    model: 'Granvia Hybrid',
    vin: 'JTNGH25E802049371',
    mileageKm: 29650,
    plate: '01 BC 1275',
    fuelPercent: 0.71,
    nextServiceDate: DateTime.now().add(const Duration(days: 35)),
    nextServiceKm: 40000,
    modelAsset: 'assets/models/granvia.glb',
    paintMaterialName: 'CarPaint',
    latitude: 37.9418,
    longitude: 58.3799,
    address: 'Görogly şaýoly, Aşgabat',
  );

  static final Vehicle myVehicle = camry;

  static final List<Vehicle> vehicles = [
    camry,
    landCruiser,
    camry2020,
    camry2016,
    landCruiser300Vxr,
    granvia,
  ];

  static final List<Dealer> dealers = [
    const Dealer(
      name: 'Toyota Aşgabat',
      city: 'Aşgabat',
      address: 'Arçabil şaýoly, 88',
      phone: '+993 12 456 789',
      distanceKm: 2.4,
      services: ['showroom', 'service', 'parts'],
    ),
    const Dealer(
      name: 'Toyota Daşoguz',
      city: 'Daşoguz',
      address: 'S.Türkmenbaşy köçesi, 12',
      phone: '+993 322 5 12 34',
      distanceKm: 468,
      services: ['showroom', 'service'],
    ),
    const Dealer(
      name: 'Toyota Balkanabat',
      city: 'Balkanabat',
      address: 'Nebitçi köçesi, 5',
      phone: '+993 222 6 45 10',
      distanceKm: 512,
      services: ['service', 'parts'],
    ),
    const Dealer(
      name: 'Toyota Türkmenabat',
      city: 'Türkmenabat',
      address: 'Görogly köçesi, 34',
      phone: '+993 422 3 78 90',
      distanceKm: 545,
      services: ['showroom', 'service', 'parts'],
    ),
    const Dealer(
      name: 'Toyota Mary',
      city: 'Mary',
      address: 'Mollanepes köçesi, 21',
      phone: '+993 522 4 22 11',
      distanceKm: 358,
      services: ['service'],
    ),
  ];

  static const List<HealthMetric> healthMetrics = [
    HealthMetric(
      key: 'engine',
      icon: HugeIcons.strokeRoundedSettings01,
      score: 96,
    ),
    HealthMetric(
      key: 'transmission',
      icon: HugeIcons.strokeRoundedExchange02,
      score: 91,
    ),
    HealthMetric(key: 'brakes', icon: HugeIcons.strokeRoundedDisc, score: 84),
    HealthMetric(
      key: 'hybrid_battery',
      icon: HugeIcons.strokeRoundedBatteryCharging01,
      score: 89,
    ),
    HealthMetric(key: 'tires', icon: HugeIcons.strokeRoundedTire, score: 78),
    HealthMetric(key: 'adas', icon: HugeIcons.strokeRoundedRadar02, score: 100),
  ];

  static int get overallHealthScore {
    final total = healthMetrics.fold<int>(0, (sum, m) => sum + m.score);
    return (total / healthMetrics.length).round();
  }

  static final List<Product> products = [
    Product(
      nameTk: 'Komple motor',
      nameEn: 'Complete Engine',
      nameRu: 'Двигатель в сборе',
      descriptionTk:
          'Toyota zawod ülňülerine laýyk gelýän doly örülen hereketlendiriji, ýokary öndürijilik we uzak ömür üçin.',
      descriptionEn:
          'Fully rebuilt engine assembly matching Toyota factory specifications, built for high performance and long service life.',
      descriptionRu:
          'Полностью собранный двигатель, соответствующий заводским стандартам Toyota, для высокой производительности и долгого срока службы.',
      price: 3200,
      imageAsset: 'assets/products/engine.png',
      oemCode: 'TY-19000-31',
      warrantyMonths: 24,
      stockCount: 4,
    ),
    Product(
      nameTk: 'Şanzyman',
      nameEn: 'Transmission',
      nameRu: 'Коробка передач',
      descriptionTk:
          'Ýumşak geçişli, ygtybarly awtomat şanzyman, gündelik we uzak aralyk sürüş üçin optimirlenen.',
      descriptionEn:
          'Smooth-shifting, reliable automatic transmission optimized for both daily driving and long trips.',
      descriptionRu:
          'Надёжная автоматическая коробка передач с плавным переключением, оптимизированная для города и трассы.',
      price: 1850,
      imageAsset: 'assets/products/transmission.png',
      oemCode: 'TY-30500-42',
      warrantyMonths: 18,
      stockCount: 6,
    ),
    Product(
      nameTk: 'Diferensial',
      nameEn: 'Differential',
      nameRu: 'Дифференциал',
      descriptionTk:
          'Güýji deň paýlaýan berk gurluşly diferensial, çyglylyga we agyr şertlere durnukly.',
      descriptionEn:
          'Robust differential assembly for even power distribution, built to withstand heavy-duty conditions.',
      descriptionRu:
          'Прочный дифференциал для равномерного распределения крутящего момента, устойчив к тяжёлым нагрузкам.',
      price: 620,
      imageAsset: 'assets/products/differential.png',
      oemCode: 'TY-41110-27',
      warrantyMonths: 12,
      stockCount: 9,
    ),
    Product(
      nameTk: 'Kardan mili',
      nameEn: 'Drive Shaft',
      nameRu: 'Карданный вал',
      descriptionTk:
          'Ýokary aýlaw tizliginde çydamly, deňagramlaşdyrylan kardan mili.',
      descriptionEn:
          'Precision-balanced drive shaft built to handle high rotational speeds without vibration.',
      descriptionRu:
          'Балансированный карданный вал, выдерживающий высокие обороты без вибраций.',
      price: 240,
      imageAsset: 'assets/products/driveshaft.png',
      oemCode: 'TY-37100-19',
      warrantyMonths: 12,
      stockCount: 11,
    ),
    Product(
      nameTk: 'Debriýaž toplumy',
      nameEn: 'Clutch Kit',
      nameRu: 'Комплект сцепления',
      descriptionTk:
          'Disk, basyş plastinasy we podşipnigi öz içine alýan doly debriýaž toplumy.',
      descriptionEn:
          'Complete clutch kit including disc, pressure plate, and release bearing.',
      descriptionRu:
          'Полный комплект сцепления: диск, нажимной диск и выжимной подшипник.',
      price: 180,
      imageAsset: 'assets/products/clutch_kit.png',
      oemCode: 'TY-31250-08',
      warrantyMonths: 12,
      stockCount: 14,
    ),
    Product(
      nameTk: 'Ön tampon',
      nameEn: 'Front Bumper',
      nameRu: 'Передний бампер',
      descriptionTk:
          'OEM ülňülerine laýyk gelýän, gönüden gurnalýan öň tampon.',
      descriptionEn:
          'Direct-fit front bumper matching OEM dimensions and mounting points.',
      descriptionRu:
          'Передний бампер прямой установки, полностью соответствует размерам оригинала.',
      price: 210,
      imageAsset: 'assets/products/front_bumper.png',
      oemCode: 'TY-52119-06',
      warrantyMonths: 6,
      stockCount: 7,
    ),
    Product(
      nameTk: 'Panjur',
      nameEn: 'Radiator Grille',
      nameRu: 'Решётка радиатора',
      descriptionTk:
          'Awtoulagyň öňki keşbini dikeltmek üçin ýokary hilli plastik panjur.',
      descriptionEn:
          "High-quality plastic radiator grille to restore your vehicle's front-end appearance.",
      descriptionRu:
          'Качественная пластиковая решётка радиатора для восстановления внешнего вида авто.',
      price: 85,
      imageAsset: 'assets/products/grille.png',
      oemCode: 'TY-53101-33',
      warrantyMonths: 6,
      stockCount: 13,
    ),
    Product(
      nameTk: 'Ön far',
      nameEn: 'Headlight',
      nameRu: 'Передняя фара',
      descriptionTk: 'Aýdyň ýagtylyk berýän, projektorly öň far toplumy.',
      descriptionEn:
          'Projector-style headlight assembly delivering clear, focused illumination.',
      descriptionRu:
          'Фара головного света проекторного типа с чётким направленным светом.',
      price: 165,
      imageAsset: 'assets/products/headlight.png',
      oemCode: 'TY-81110-52',
      warrantyMonths: 12,
      stockCount: 8,
    ),
    Product(
      nameTk: 'Arka stop çyrasy',
      nameEn: 'Tail Light',
      nameRu: 'Задний фонарь',
      descriptionTk: 'LED signal ulgamly, suw geçirmeýän arka stop çyrasy.',
      descriptionEn:
          'Weatherproof tail light with integrated LED signal system.',
      descriptionRu:
          'Влагозащищённый задний фонарь со встроенной LED-сигнализацией.',
      price: 95,
      imageAsset: 'assets/products/tail_light.png',
      oemCode: 'TY-81550-71',
      warrantyMonths: 12,
      stockCount: 10,
    ),
    Product(
      nameTk: 'Sis farsy',
      nameEn: 'Fog Light',
      nameRu: 'Противотуманная фара',
      descriptionTk:
          'Ýaramaz howa şertlerinde görnükliligi ýokarlandyrýan sis farsy.',
      descriptionEn:
          'Fog light designed to improve visibility in poor weather conditions.',
      descriptionRu:
          'Противотуманная фара для улучшения видимости в плохую погоду.',
      price: 45,
      imageAsset: 'assets/products/fog_light.png',
      oemCode: 'TY-81210-14',
      warrantyMonths: 12,
      stockCount: 16,
    ),
    Product(
      nameTk: 'Ýan aýna',
      nameEn: 'Side Mirror',
      nameRu: 'Боковое зеркало',
      descriptionTk: 'Elektrik bilen sazlanýan, gyzdyryjyly ýan aýna.',
      descriptionEn:
          'Power-adjustable side mirror with integrated heating element.',
      descriptionRu: 'Боковое зеркало с электроприводом и функцией обогрева.',
      price: 70,
      imageAsset: 'assets/products/side_mirror.png',
      oemCode: 'TY-87910-60',
      warrantyMonths: 12,
      stockCount: 12,
    ),
    Product(
      nameTk: 'Öň aýna',
      nameEn: 'Windshield',
      nameRu: 'Лобовое стекло',
      descriptionTk: 'UF şöhlelerinden goraýan gatlakly howpsuzlyk aýnasy.',
      descriptionEn: 'Laminated safety glass windshield with UV protection.',
      descriptionRu: 'Ламинированное лобовое стекло с защитой от УФ-излучения.',
      price: 190,
      imageAsset: 'assets/products/windshield.png',
      oemCode: 'TY-56101-45',
      warrantyMonths: 6,
      stockCount: 5,
    ),
    Product(
      nameTk: 'Gösterge paneli',
      nameEn: 'Instrument Cluster',
      nameRu: 'Панель приборов',
      descriptionTk: 'Sanly displeýli, takyk görkezijili gösterge paneli.',
      descriptionEn:
          'Instrument cluster with digital display and precise gauge readings.',
      descriptionRu:
          'Панель приборов с цифровым дисплеем и точными показаниями.',
      price: 260,
      imageAsset: 'assets/products/instrument_cluster.png',
      oemCode: 'TY-83800-27',
      warrantyMonths: 12,
      stockCount: 6,
    ),
    Product(
      nameTk: 'Dikiz aýnasy',
      nameEn: 'Rearview Mirror',
      nameRu: 'Зеркало заднего вида',
      descriptionTk: 'Awtomatiki garaňkylaşýan içerki dikiz aýnasy.',
      descriptionEn: 'Auto-dimming interior rearview mirror.',
      descriptionRu: 'Салонное зеркало заднего вида с автозатемнением.',
      price: 35,
      imageAsset: 'assets/products/rearview_mirror.png',
      oemCode: 'TY-87810-02',
      warrantyMonths: 12,
      stockCount: 15,
    ),
    Product(
      nameTk: 'Rul',
      nameEn: 'Steering Wheel',
      nameRu: 'Руль',
      descriptionTk: 'Deri bilen örtülen, ergonomiki dizaýnly rul.',
      descriptionEn: 'Leather-wrapped steering wheel with ergonomic design.',
      descriptionRu: 'Руль в кожаной оплётке с эргономичным дизайном.',
      price: 150,
      imageAsset: 'assets/products/steering_wheel.png',
      oemCode: 'TY-45100-89',
      warrantyMonths: 12,
      stockCount: 9,
    ),
    Product(
      nameTk: 'Öň oturgyç',
      nameEn: 'Front Seat',
      nameRu: 'Переднее сиденье',
      descriptionTk: 'Deri örtükli, ýylytma funksiýaly öň oturgyç.',
      descriptionEn: 'Leather-upholstered front seat with heating function.',
      descriptionRu: 'Переднее сиденье из кожи с функцией подогрева.',
      price: 340,
      imageAsset: 'assets/products/front_seat.png',
      oemCode: 'TY-71100-73',
      warrantyMonths: 12,
      stockCount: 4,
    ),
    Product(
      nameTk: 'Merkezi konsol',
      nameEn: 'Center Console',
      nameRu: 'Центральная консоль',
      descriptionTk: 'Saklaýyş bölümli, stakan tutawaçly merkezi konsol.',
      descriptionEn: 'Center console with storage compartment and cup holders.',
      descriptionRu:
          'Центральная консоль с отсеком для хранения и подстаканниками.',
      price: 120,
      imageAsset: 'assets/products/center_console.png',
      oemCode: 'TY-58910-17',
      warrantyMonths: 6,
      stockCount: 10,
    ),
    Product(
      nameTk: 'Motor ýagy',
      nameEn: 'Engine Oil',
      nameRu: 'Моторное масло',
      descriptionTk:
          'Toyota hereketlendirijileri üçin doly sintetiki motor ýagy, ýokary temperaturada durnukly we uzak wagtlap goragy üpjün edýär.',
      descriptionEn:
          'Fully synthetic engine oil formulated for Toyota engines, stable under high temperatures and built for long-lasting protection.',
      descriptionRu:
          'Полностью синтетическое моторное масло для двигателей Toyota, стабильное при высоких температурах и обеспечивающее долгую защиту.',
      price: 45,
      imageAsset: 'assets/products/engine_oil.jpg',
      oemCode: 'TY-08880-01',
      warrantyMonths: 6,
      stockCount: 32,
    ),
    Product(
      nameTk: 'Ýag süzgüji',
      nameEn: 'Oil Filter',
      nameRu: 'Масляный фильтр',
      descriptionTk:
          'OEM ülňülerine laýyk gelýän ýag süzgüji, hereketlendirijini hapalanmadan goraýar.',
      descriptionEn:
          'OEM-spec oil filter that keeps contaminants out of the engine for cleaner, longer-lasting lubrication.',
      descriptionRu:
          'Масляный фильтр по стандартам OEM, защищающий двигатель от загрязнений.',
      price: 18,
      imageAsset: 'assets/products/oil_filter.jpg',
      oemCode: 'TY-90915-20',
      warrantyMonths: 6,
      stockCount: 40,
    ),
    Product(
      nameTk: 'Salon süzgüji',
      nameEn: 'Cabin Air Filter',
      nameRu: 'Салонный фильтр',
      descriptionTk:
          'Tozy we allergenleri saklaýan, sazlaşykly howa akymyny üpjün edýän salon süzgüji.',
      descriptionEn:
          'Cabin air filter that traps dust and allergens for cleaner airflow inside the vehicle.',
      descriptionRu:
          'Салонный фильтр, задерживающий пыль и аллергены для более чистого воздуха в салоне.',
      price: 22,
      imageAsset: 'assets/products/cabin_filter.jpg',
      oemCode: 'TY-87139-06',
      warrantyMonths: 6,
      stockCount: 27,
    ),
    Product(
      nameTk: 'Akkumulýator',
      nameEn: 'Car Battery',
      nameRu: 'Аккумулятор',
      descriptionTk:
          'Ygtybarly başlangyç güýji we uzak ömri üpjün edýän, tehniki hyzmat talap etmeýän akkumulýator.',
      descriptionEn:
          'Maintenance-free car battery delivering reliable starting power and a long service life.',
      descriptionRu:
          'Необслуживаемый аккумулятор с надёжным пусковым током и долгим сроком службы.',
      price: 140,
      imageAsset: 'assets/products/car_battery.jpg',
      oemCode: 'TY-28800-54',
      warrantyMonths: 18,
      stockCount: 15,
    ),
    Product(
      nameTk: 'Içki arassalaýjy spreý',
      nameEn: 'Interior Cleaner Spray',
      nameRu: 'Спрей для чистки салона',
      descriptionTk:
          'Salonyň üstlerini arassalaýan we täzeden janlandyrýan, ýokary täsirli arassalaýjy spreý.',
      descriptionEn:
          'High-performance cleaning spray that refreshes and revives interior surfaces.',
      descriptionRu:
          'Эффективный чистящий спрей, освежающий и восстанавливающий поверхности салона.',
      price: 12,
      imageAsset: 'assets/products/interior_cleaner.jpg',
      oemCode: 'TY-08630-11',
      warrantyMonths: 3,
      stockCount: 50,
    ),
  ];

  static final List<Order> orders = [
    Order(
      productNameTk: 'Debriýaž toplumy',
      productNameEn: 'Clutch Kit',
      productNameRu: 'Комплект сцепления',
      date: DateTime.now().subtract(const Duration(days: 6)),
      price: 180,
      statusTk: 'Gowşuryldy',
      statusEn: 'Delivered',
      statusRu: 'Доставлено',
      imageAsset: 'assets/products/clutch_kit.png',
    ),
    Order(
      productNameTk: 'Ön far',
      productNameEn: 'Headlight',
      productNameRu: 'Передняя фара',
      date: DateTime.now().subtract(const Duration(days: 34)),
      price: 165,
      statusTk: 'Gowşuryldy',
      statusEn: 'Delivered',
      statusRu: 'Доставлено',
      imageAsset: 'assets/products/headlight.png',
    ),
    Order(
      productNameTk: 'Gösterge paneli',
      productNameEn: 'Instrument Cluster',
      productNameRu: 'Панель приборов',
      date: DateTime.now().subtract(const Duration(days: 1)),
      price: 260,
      statusTk: 'Ýolda',
      statusEn: 'In Transit',
      statusRu: 'В пути',
      imageAsset: 'assets/products/instrument_cluster.png',
    ),
  ];

  static final List<AppNotification> notifications = [
    AppNotification(
      titleTk: 'Hyzmat wagty ýakynlaşýar',
      titleEn: 'Service due soon',
      titleRu: 'Скоро ТО',
      bodyTk: 'Camry 2025 ulagyňyz 20,000 km-de tehniki hyzmata mätäç',
      bodyEn: 'Your Camry 2025 needs maintenance at 20,000 km',
      bodyRu: 'Вашему Camry 2025 требуется ТО на 20 000 км',
      icon: HugeIcons.strokeRoundedWrench01,
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      titleTk: 'Täze kampaniýa',
      titleEn: 'New campaign',
      titleRu: 'Новая акция',
      bodyTk: 'Tomus kepillik kampaniýasy başlady',
      bodyEn: 'Summer warranty campaign has started',
      bodyRu: 'Началась летняя гарантийная акция',
      icon: HugeIcons.strokeRoundedTag02,
      time: DateTime.now().subtract(const Duration(hours: 8)),
      read: true,
    ),
    AppNotification(
      titleTk: 'Sargydyňyz ýolda',
      titleEn: 'Your order is on the way',
      titleRu: 'Ваш заказ в пути',
      bodyTk: 'Toyota kamera ulgamy sargydyňyz eltilýär',
      bodyEn: 'Your Dash Camera Kit order is being delivered',
      bodyRu: 'Ваш заказ комплекта видеорегистратора доставляется',
      icon: HugeIcons.strokeRoundedTruckDelivery,
      time: DateTime.now().subtract(const Duration(days: 1)),
      read: true,
    ),
    AppNotification(
      titleTk: 'Programma üpjünçiligi täzelendi',
      titleEn: 'Software update available',
      titleRu: 'Доступно обновление ПО',
      bodyTk: 'ECU programma üpjünçiligi täze wersiýa çykdy',
      bodyEn: 'A new ECU software version is available',
      bodyRu: 'Доступна новая версия ПО ЭБУ',
      icon: HugeIcons.strokeRoundedCloudUpload,
      time: DateTime.now().subtract(const Duration(days: 3)),
      read: true,
    ),
  ];
}
