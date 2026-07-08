import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import 'package:hugeicons/hugeicons.dart';

const _weekdayShort = {
  AppLanguage.tk: ['Duş', 'Siş', 'Çar', 'Pen', 'Anna', 'Şen', 'Ýek'],
  AppLanguage.en: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  AppLanguage.ru: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
};

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  int _serviceIndex = 0;
  int _dealerIndex = 0;
  late final List<DateTime> _quickDates;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _quickDates = List.generate(
      10,
      (i) => DateTime.now().add(Duration(days: i + 1)),
    );
    _date = _quickDates[2];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static const _serviceKeys = [
    'oil_change',
    'periodic_maintenance',
    'tire_service',
    'brake_check',
  ];
  static const _serviceIcons = [
    HugeIcons.strokeRoundedOilBarrel,
    HugeIcons.strokeRoundedWrench01,
    HugeIcons.strokeRoundedTire,
    HugeIcons.strokeRoundedTire,
  ];

  Widget _serviceChips(bool tablet) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_serviceKeys.length, (i) {
        final selected = _serviceIndex == i;
        return ChoiceChip(
          selected: selected,
          label: Text(context.tr(_serviceKeys[i])),
          avatar: HugeIcon(
            icon: _serviceIcons[i],
            size: tablet ? 19 : 16,
            color: selected ? Colors.white : AppColors.toyotaRed,
          ),
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: tablet ? 15 : null,
          ),
          padding: tablet
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
              : null,
          selectedColor: AppColors.toyotaRed,
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.divider),
          ),
          onSelected: (_) => setState(() => _serviceIndex = i),
        );
      }),
    );
  }

  Widget _dealerCard(Dealer selectedDealer, List<Dealer> dealers, bool tablet) {
    return AppCard(
      onTap: () => _pickDealer(context, dealers),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(tablet ? 14 : 10),
            decoration: BoxDecoration(
              color: AppColors.toyotaRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedStore02,
              color: AppColors.toyotaRed,
              size: tablet ? 26 : 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDealer.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 16 : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  selectedDealer.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: tablet ? 14 : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _dateRow(AppLanguage lang, bool tablet) {
    return SizedBox(
      height: tablet ? 90 : 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _quickDates.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          if (i == _quickDates.length) {
            return _MoreDateButton(
              selected: !_quickDates.any((d) => _isSameDay(d, _date)),
              tablet: tablet,
              onTap: () async {
                final picked = await _showThemedDatePicker(context);
                if (picked != null) setState(() => _date = picked);
              },
            );
          }
          final d = _quickDates[i];
          final selected = _isSameDay(d, _date);
          final weekday = _weekdayShort[lang]![d.weekday - 1];
          return _DateChip(
            weekday: weekday,
            day: d.day,
            selected: selected,
            tablet: tablet,
            onTap: () => setState(() => _date = d),
          );
        },
      ),
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
      child: Text(context.tr('confirm_booking')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dealers = MockData.dealers;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('book_service_title')),
      ),
      body: context.isTablet
          ? _buildTabletLayout(context, dealers)
          : _buildPhoneLayout(context, dealers),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, List<Dealer> dealers) {
    final lang = context.watch<AppState>().language;
    final selectedDealer = dealers[_dealerIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        SectionHeader(title: context.tr('select_service_type')),
        const SizedBox(height: 12),
        _serviceChips(false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('select_dealer')),
        const SizedBox(height: 12),
        _dealerCard(selectedDealer, dealers, false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('select_date')),
        const SizedBox(height: 12),
        _dateRow(lang, false),
        const SizedBox(height: 34),
        _confirmButton(false),
      ],
    );
  }

  /// iPad splits the form into a selection column (service type + dealer)
  /// and a scheduling column (date + confirm), instead of stacking every
  /// step in one centered phone-width column.
  Widget _buildTabletLayout(BuildContext context, List<Dealer> dealers) {
    final lang = context.watch<AppState>().language;
    final selectedDealer = dealers[_dealerIndex];

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
                  SectionHeader(title: context.tr('select_service_type')),
                  const SizedBox(height: 14),
                  _serviceChips(true),
                  const SizedBox(height: 30),
                  SectionHeader(title: context.tr('select_dealer')),
                  const SizedBox(height: 14),
                  _dealerCard(selectedDealer, dealers, true),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('select_date')),
                  const SizedBox(height: 14),
                  _dateRow(lang, true),
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

  Future<DateTime?> _showThemedDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.toyotaRed),
          ),
          child: child!,
        );
      },
    );
  }

  void _pickDealer(BuildContext context, List<Dealer> dealers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.tr('select_dealer'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(dealers.length, (i) {
                final d = dealers[i];
                final selected = i == _dealerIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() => _dealerIndex = i);
                      Navigator.pop(sheetContext);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.toyotaRed.withValues(alpha: 0.06)
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? AppColors.toyotaRed
                              : AppColors.divider,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.toyotaRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedStore02,
                              color: AppColors.toyotaRed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  d.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${d.distanceKm.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          if (selected) ...[
                            const SizedBox(width: 8),
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                              color: AppColors.toyotaRed,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedCheckmarkCircle02,
          color: AppColors.success,
          size: 40,
        ),
        title: Text(
          context.tr('booking_confirmed'),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '${MockData.dealers[_dealerIndex].name}\n${_date.day.toString().padLeft(2, '0')}.${_date.month.toString().padLeft(2, '0')}.${_date.year}',
          textAlign: TextAlign.center,
        ),
        actions: [
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
    );
  }
}

class _DateChip extends StatelessWidget {
  final String weekday;
  final int day;
  final bool selected;
  final bool tablet;
  final VoidCallback onTap;

  const _DateChip({
    required this.weekday,
    required this.day,
    required this.selected,
    required this.onTap,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: tablet ? 68 : 56,
        decoration: BoxDecoration(
          color: selected ? AppColors.toyotaRed : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.toyotaRed : AppColors.divider,
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
              '$day',
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
  }
}

class _MoreDateButton extends StatelessWidget {
  final bool selected;
  final bool tablet;
  final VoidCallback onTap;

  const _MoreDateButton({
    required this.selected,
    required this.onTap,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tablet ? 68 : 56,
        decoration: BoxDecoration(
          color: selected ? AppColors.toyotaRed : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.toyotaRed : AppColors.divider,
          ),
        ),
        alignment: Alignment.center,
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar03,
          color: selected ? Colors.white : AppColors.toyotaRed,
          size: tablet ? 26 : 22,
        ),
      ),
    );
  }
}
