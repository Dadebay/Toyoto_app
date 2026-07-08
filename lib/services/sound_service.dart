import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum SoundEffect { engineStart, lock, unlock, tap, whoosh, success }

extension on SoundEffect {
  String get _assetPath {
    switch (this) {
      case SoundEffect.engineStart:
        return 'assets/sounds/engine_start.wav';
      case SoundEffect.lock:
        return 'assets/sounds/lock.wav';
      case SoundEffect.unlock:
        return 'assets/sounds/unlock.wav';
      case SoundEffect.tap:
        return 'assets/sounds/tap.wav';
      case SoundEffect.whoosh:
        return 'assets/sounds/whoosh.wav';
      case SoundEffect.success:
        return 'assets/sounds/success.wav';
    }
  }
}

/// Fire-and-forget short SFX playback. Every failure (missing asset,
/// platform codec issue, etc.) is swallowed — sound is a nice-to-have for
/// the demo and must never crash or block the UI.
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  bool enabled = true;

  final List<AudioPlayer> _pool = List.generate(4, (_) => AudioPlayer());
  int _next = 0;

  Future<void> warmUp() async {
    // Nothing to pre-load: just_audio loads the asset lazily on setAsset.
  }

  Future<void> play(SoundEffect effect, {double volume = 1.0}) async {
    if (!enabled) return;
    try {
      final player = _pool[_next % _pool.length];
      _next++;
      await player.stop();
      await player.setAsset(effect._assetPath);
      await player.setVolume(volume);
      unawaited(player.play());
    } catch (e) {
      debugPrint('SoundService: could not play $effect ($e)');
    }
  }
}
