import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import 'package:hugeicons/hugeicons.dart';

const _tdWeekdayShort = {
  AppLanguage.tk: ['Duş', 'Siş', 'Çar', 'Pen', 'Anna', 'Şen', 'Ýek'],
  AppLanguage.en: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  AppLanguage.ru: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
};

class TestDriveScreen extends StatefulWidget {
  final NewCarListing? car;

  const TestDriveScreen({super.key, this.car});

  @override
  State<TestDriveScreen> createState() => _TestDriveScreenState();
}

class _TestDriveScreenState extends State<TestDriveScreen> {
  late int _carIndex;
  int _dealerIndex = 0;
  late final List<DateTime> _quickDates;
  late DateTime _date;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final listings = MockData.newCarListings;
    _carIndex = widget.car == null ? -1 : listings.indexOf(widget.car!);
    if (_carIndex < 0) _carIndex = 0;
    _quickDates = List.generate(
      10,
      (i) => DateTime.now().add(Duration(days: i + 1)),
    );
    _date = _quickDates[2];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _carChips(AppLanguage lang, bool tablet) {
    final listings = MockData.newCarListings;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(listings.length, (i) {
        final selected = i == _carIndex;
        return ChoiceChip(
          selected: selected,
          label: Text(listings[i].name(lang)),
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: tablet ? 15 : null,
          ),
          selectedColor: AppColors.bmwBlue,
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.divider),
          ),
          onSelected: (_) => setState(() => _carIndex = i),
        );
      }),
    );
  }

  Widget _dealerCard(bool tablet) {
    final dealer = MockData.dealers[_dealerIndex];
    return AppCard(
      onTap: () => _pickDealer(context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(tablet ? 14 : 10),
            decoration: BoxDecoration(
              color: AppColors.bmwBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedStore02,
              color: AppColors.bmwBlue,
              size: tablet ? 26 : 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dealer.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 16 : null,
                  ),
                ),
                Text(
                  dealer.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: tablet ? 14 : null),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  void _pickDealer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(MockData.dealers.length, (i) {
            final d = MockData.dealers[i];
            return ListTile(
              title: Text(d.name),
              subtitle: Text(d.address),
              onTap: () {
                setState(() => _dealerIndex = i);
                Navigator.pop(sheetContext);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _dateRow(AppLanguage lang, bool tablet) {
    return SizedBox(
      height: tablet ? 90 : 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _quickDates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final d = _quickDates[i];
          final selected = _isSameDay(d, _date);
          final weekday = _tdWeekdayShort[lang]![d.weekday - 1];
          return GestureDetector(
            onTap: () => setState(() => _date = d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: tablet ? 68 : 56,
              decoration: BoxDecoration(
                color: selected ? AppColors.bmwBlue : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.bmwBlue : AppColors.divider,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      fontSize: tablet ? 13 : 11,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d.day}',
                    style: TextStyle(
                      fontSize: tablet ? 20 : 17,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _contactForm(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: context.tr('td_name')),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: context.tr('td_phone')),
        ),
      ],
    );
  }

  Widget _confirmButton(bool tablet) {
    return ElevatedButton(
      onPressed: () => _confirm(context),
      style: tablet
          ? ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(fontSize: 16),
            )
          : null,
      child: Text(context.tr('td_confirm')),
    );
  }

  void _confirm(BuildContext context) {
    final lang = context.read<AppState>().language;
    final car = MockData.newCarListings[_carIndex];
    final dealer = MockData.dealers[_dealerIndex];
    final name = _nameController.text.trim().isEmpty
        ? '—'
        : _nameController.text.trim();
    final phone = _phoneController.text.trim();

    context.read<AppState>().bookTestDrive(
      TestDriveBooking(
        carName: car.name(lang),
        dealer: dealer,
        date: _date,
        name: name,
        phone: phone,
      ),
    );
    context.read<AppState>().addNotification(
      AppNotification(
        titleTk: 'Synag sürüşi tassyklandy',
        titleEn: 'Test drive confirmed',
        titleRu: 'Тест-драйв подтверждён',
        bodyTk: '${car.name(AppLanguage.tk)} üçin synag sürüşiňiz kabul edildi.',
        bodyEn: 'Your test drive for the ${car.name(AppLanguage.en)} is confirmed.',
        bodyRu: 'Ваш тест-драйв ${car.name(AppLanguage.ru)} подтверждён.',
        icon: HugeIcons.strokeRoundedSteering,
        time: DateTime.now(),
      ),
    );
    SoundService.instance.play(SoundEffect.success);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: AppColors.success,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('td_confirmed_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('td_confirmed_body'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final lang = context.watch<AppState>().language;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('td_title')),
      ),
      body: tablet
          ? _buildTabletLayout(context, lang)
          : _buildPhoneLayout(context, lang),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        SectionHeader(title: context.tr('td_select_model')),
        const SizedBox(height: 12),
        _carChips(lang, false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('td_select_dealer')),
        const SizedBox(height: 12),
        _dealerCard(false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('td_select_datetime')),
        const SizedBox(height: 12),
        _dateRow(lang, false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('td_your_info')),
        const SizedBox(height: 12),
        _contactForm(false),
        const SizedBox(height: 34),
        _confirmButton(false),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('td_select_model')),
                  const SizedBox(height: 14),
                  _carChips(lang, true),
                  const SizedBox(height: 30),
                  SectionHeader(title: context.tr('td_select_dealer')),
                  const SizedBox(height: 14),
                  _dealerCard(true),
                  const SizedBox(height: 30),
                  SectionHeader(title: context.tr('td_select_datetime')),
                  const SizedBox(height: 14),
                  _dateRow(lang, true),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('td_your_info')),
                  const SizedBox(height: 14),
                  _contactForm(true),
                  const SizedBox(height: 40),
                  _confirmButton(true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
