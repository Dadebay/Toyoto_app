# Toyota Merkezi Satış Demosu — Özellik Fikirleri

Bu dosya, uygulamayı Toyota merkezine (Aşgabat) satarken müşterinin dikkatini çekecek yeni özelliklerin uygulama planıdır. Tüm özellikler **mock veri** ile çalışacak — backend gerekmez, amaç etkileyici bir demo.

## Mevcut Durum (özet)

Flutter uygulaması, tamamen mock veriyle çalışan bir Toyota sahip/müşteri uygulaması:

- **Mimari:** `provider` ile `lib/state/app_state.dart` (ChangeNotifier), mock veriler `lib/data/mock_data.dart`, 3 dil desteği (tk/en/ru) `lib/l10n/strings.dart`, tema `lib/theme/app_theme.dart`, iPad desteği `lib/utils/responsive.dart` (`context.isTablet`).
- **Mevcut ekranlar:** Home, My Car (3D GLB görüntüleyici + boya rengi değiştirme), AI Assistant (mock cevaplar), Store (parça mağazası + sepet + sipariş geçmişi), Profile, Remote Connect (kilit/klima), Health Check, Book Service, Nearby Service (flutter_map), Notifications, Settings.
- **Varlıklar:** 6 adet .glb 3D araç modeli (`assets/models/`), parça görselleri (`assets/products/`), ses efektleri (`assets/sounds/`).
- **Paketler:** model_viewer_plus, flutter_map, flutter_animate, just_audio, hugeicons, flutter_svg.

## Kurallar (her özellik için geçerli)

1. Mevcut mimariye uy: yeni ekranlar `lib/screens/`, mock veriler `lib/data/mock_data.dart`'a, modeller `lib/models/models.dart`'a, state `lib/state/app_state.dart`'a eklenir.
2. **Her yeni metin 3 dilde** (tk/en/ru) `lib/l10n/strings.dart`'a eklenmeli. Varsayılan dil Türkmence.
3. Mevcut widget'ları kullan: `AppCard`, `SectionHeader`, `QuickActionGrid`, `AppBackButton`, `ToyotaBadge`.
4. iPad'de gerçek çok sütunlu düzen kur (`context.isTablet`) — sadece ortala+padding YAPMA.
5. Animasyonlar için `flutter_animate`, ses geri bildirimi için `SoundService` kullan.
6. Yeni paket ekleme — mevcut paketlerle çözülemeyen bir şey gerekirse önce sor.
7. Uygulamayı çalıştırma/build etme — kullanıcı kendisi çalıştıracak.

---

## ÖNCELİK 1 — Demo'da "vay" dedirtecek satış özellikleri

### 1. Yeni Araç Vitrini + 3D Konfigüratör (Showroom)

Merkezin asıl işi araç satmak — uygulamada yeni araç kataloğu olması en güçlü satış argümanı.

- Yeni ekran: `showroom_screen.dart`. Mevcut 6 GLB modelini "satılık yeni araçlar" olarak listele (fiyat, motor, yakıt tüketimi, donanım seviyesi gibi mock spec'lerle).
- Detayda mevcut `Car3DViewer` widget'ını kullan: renk seçici (mevcut boya değiştirme özelliği zaten var — `paintMaterialName`), donanım paketi seçimi (VX / VXR / Hybrid), seçime göre fiyatın canlı güncellenmesi.
- "Fiyat teklifi iste" butonu → mock onay ekranı + bildirim.
- Home ekranına ve bottom nav'a giriş noktası ekle (Store sekmesi içine tab olarak da olabilir).

### 2. Test Sürüşü Randevusu

- Yeni ekran: `test_drive_screen.dart`. Model seç → tarih/saat seç (takvim grid'i) → iletişim bilgisi → onay animasyonu (`flutter_animate` + `success.wav`).
- Randevu `AppState`'te tutulur, Notifications ekranına "Test sürüşünüz onaylandı" bildirimi düşer.
- Showroom detayından ve Home quick action'dan erişilebilir.

### 3. Canlı Servis Takibi (araç servisteyken)

Müşteriler için en somut fayda; demo'da çok iyi görünür.

- Yeni ekran: `service_tracking_screen.dart`. Araç servisteyken adım adım ilerleme: **Kabul → Arıza tespiti → Parça değişimi → Yıkama → Hazır** — dikey timeline, aktif adım animasyonlu.
- Demo etkisi için sahte "canlı" ilerleme: ekran açıkken her 8-10 saniyede bir adım ilerlesin (Timer ile).
- Her adımda mock foto/not ("Yağ filtresi değiştirildi") ve tahmini teslim saati.
- Book Service akışının sonunda bu ekrana bağlan; Home'da "Aracınız serviste — 2/5 adım" kartı göster.

### 4. Kredi / Taksit Hesaplayıcı

- Yeni ekran: `finance_calculator_screen.dart`. Araç fiyatı (showroom'dan gelir), peşinat slider'ı, vade seçimi (12/24/36/48 ay) → aylık taksit anında hesaplanır, büyük animasyonlu rakam.
- Basit grafik: anapara/toplam ödeme dağılımı (custom paint ile halka grafik — `HealthScoreRing` benzeri).
- Showroom detayına "Taksit hesapla" butonu.

---

## ÖNCELİK 2 — Uygulamayı "tam ürün" gösteren özellikler

### 5. Takas (Trade-in) Değerleme

- Yeni ekran: `trade_in_screen.dart`. Kullanıcının mevcut aracı (MockData'daki araçlardan) veya manuel giriş: model, yıl, km, durum → mock değerleme algoritması (yıl ve km'ye göre azalan fiyat) → "Tahmini takas değeri: X TMT" sonuç kartı, sayaç animasyonuyla.
- Showroom'a "Takasla al" bağlantısı: yeni araç fiyatından takas değeri düşülmüş fark gösterilir.

### 6. Sadakat Programı + Dijital Üye Kartı

- Yeni ekran: `loyalty_screen.dart`. Puan bakiyesi, seviye (Bronze/Silver/Gold — Gold'da Toyota kırmızısı gradyan kart), kazanım geçmişi (servis, parça alışverişi puanları).
- QR'lı dijital üye kartı (QR'ı `CustomPaint` ile basit çizebilir ya da statik SVG kullan — yeni paket ekleme).
- Store'da sepet onayında "+120 puan kazandınız" toast'u.

### 7. Kampanyalar / Duyurular

- Home ekranının üstüne yatay kayan kampanya banner carousel'i (PageView + gösterge noktaları, otomatik kayma).
- Mock kampanyalar: "Kış lastiği %20 indirim", "Ücretsiz 10.000 km bakımı", "Land Cruiser 300 test sürüşü haftası".
- Banner'a tıklayınca detay bottom sheet'i; parça kampanyaları Store'daki ürüne bağlanır.

### 8. Dijital Servis Defteri (Servis Geçmişi)

- Yeni ekran: `service_history_screen.dart`. Araç başına geçmiş servis kayıtları timeline'ı: tarih, km, yapılan işlemler, tutar, servis noktası.
- My Car ekranından erişim. "PDF olarak paylaş" butonu mock olabilir (sadece success animasyonu).
- Garanti durumu kartı: kalan garanti süresi/km progress bar ile.

### 9. Acil Yol Yardımı (SOS)

- Profile veya Home'da kırmızı SOS kartı → basılı tutunca (long-press, dolan halka animasyonu) mock çağrı ekranı: konum haritada (`flutter_map`, mevcut araç koordinatları), "Yardım yola çıktı — tahmini 25 dk", çekici aracı haritada hareket eden marker ile.
- Demo'da çok etkileyici görünür, mevcut harita altyapısıyla ucuz.

---

## ÖNCELİK 3 — Cila (süre kalırsa)

### 10. Araç Karşılaştırma

- Showroom'da iki model seç → yan yana spec tablosu (fiyat, motor, tüketim, bagaj), üstte iki küçük 3D önizleme. iPad'de gerçek iki sütun.

### 11. Yakıt & Masraf Takibi

- My Car'a "Masraflar" sekmesi: aylık yakıt/servis/parça harcaması mock verisi, basit çubuk grafik (CustomPaint), "Bu ay geçen aya göre %12 daha az" içgörü kartı.

### 12. Onboarding + Açılış Animasyonu

- İlk açılışta 3 sayfalık tanıtım (3D araç, uzaktan kontrol, servis) + Toyota logosu splash animasyonu (`flutter_animate`). Dil seçimi onboarding'in ilk adımı olsun — demo'yu Türkmence/Rusça göstermek için pratik.

### 13. Dijital Anahtar Paylaşımı

- Remote Connect ekranına "Anahtarı paylaş" kartı: aile üyesine geçici dijital anahtar ver (isim + süre seç → aktif anahtar listesi). Tamamen mock, ama "connected car" hikayesini güçlendirir.

---

## Önerilen uygulama sırası

1. Kampanya carousel'i (#7) — hızlı, Home'u hemen canlandırır.
2. Showroom + 3D konfigüratör (#1) — ana satış özelliği.
3. Test sürüşü (#2) ve kredi hesaplayıcı (#4) — showroom'u tamamlar.
4. Canlı servis takibi (#3) — demo'nun ikinci "vay" anı.
5. Kalanlar öncelik sırasıyla.

Her özellik bittiğinde: 3 dil kontrolü, iPad düzeni kontrolü, `flutter analyze` temiz olmalı.
