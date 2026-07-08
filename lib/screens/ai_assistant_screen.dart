import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/ai_responses.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/toyota_badge.dart';
import 'package:hugeicons/hugeicons.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _typing = false;

  static const _suggestionKeys = [
    'suggest_service',
    'suggest_engine',
    'suggest_battery',
    'suggest_price',
    'suggest_location',
  ];

  void _send(AppState appState, [String? presetText]) {
    final text = presetText ?? _controller.text.trim();
    if (text.isEmpty) return;
    appState.addChatMessage(
      ChatMessage(text: text, isUser: true, time: DateTime.now()),
    );
    _controller.clear();
    setState(() => _typing = true);
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final reply = getAiResponse(text, appState.language);
      appState.addChatMessage(
        ChatMessage(text: reply, isUser: false, time: DateTime.now()),
      );
      setState(() => _typing = false);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final messages = appState.chatMessages;
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ToyotaBadge(size: tablet ? 34 : 30),
            const SizedBox(width: 10),
            Text(context.tr('ai_title')),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: tablet ? 760 : double.infinity),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _BubbleRow(
                      isUser: false,
                      text: context.tr('ai_greeting'),
                      tablet: tablet,
                    ),
                    for (final m in messages)
                      _BubbleRow(
                        isUser: m.isUser,
                        text: m.text,
                        tablet: tablet,
                      ),
                    if (_typing) _TypingIndicator(tablet: tablet),
                  ],
                ),
              ),
              SizedBox(
                height: tablet ? 46 : 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _suggestionKeys.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final key = _suggestionKeys[i];
                    return ActionChip(
                      label: Text(context.tr(key)),
                      onPressed: _typing
                          ? null
                          : () => _send(appState, context.tr(key)),
                      backgroundColor: AppColors.card,
                      labelStyle: TextStyle(
                        fontSize: tablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppColors.divider),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(fontSize: tablet ? 16 : null),
                          decoration: InputDecoration(
                            hintText: context.tr('ai_input_hint'),
                            filled: true,
                            fillColor: AppColors.card,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: tablet ? 18 : 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _send(appState),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _send(appState),
                        child: Container(
                          padding: EdgeInsets.all(tablet ? 17 : 14),
                          decoration: const BoxDecoration(
                            color: AppColors.toyotaRed,
                            shape: BoxShape.circle,
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedSent,
                            color: Colors.white,
                            size: tablet ? 24 : 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleRow extends StatelessWidget {
  final bool isUser;
  final String text;
  final bool tablet;

  const _BubbleRow({
    required this.isUser,
    required this.text,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            ToyotaBadge(size: tablet ? 32 : 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: tablet ? 480 : double.infinity,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tablet ? 20 : 16,
                  vertical: tablet ? 15 : 12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.toyotaRed : AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: isUser ? null : Border.all(color: AppColors.divider),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                    fontSize: tablet ? 15.5 : 14,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final bool tablet;

  const _TypingIndicator({this.tablet = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ToyotaBadge(size: tablet ? 32 : 28),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tablet ? 20 : 16,
              vertical: tablet ? 17 : 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider),
            ),
            child: SizedBox(
              width: tablet ? 28 : 24,
              height: tablet ? 12 : 10,
              child: Center(
                child: SizedBox(
                  width: tablet ? 18 : 16,
                  height: tablet ? 18 : 16,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
