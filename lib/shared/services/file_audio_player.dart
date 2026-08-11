import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'lesson_audio_service.dart';

/// Plays a compressed offline audio file from disk using `audioplayers`.
///
/// Low-end-device friendly: the [AudioPlayer] is created lazily on first use
/// (so nothing native is touched until the student actually plays audio), and
/// audio is streamed from the file by the platform — the app never loads whole
/// audio files into memory. Any failure is swallowed so the caller can fall
/// back to TTS.
class FileAudioPlayer implements BundledAudioPlayer {
  FileAudioPlayer();

  AudioPlayer? _player;

  AudioPlayer _ensure() => _player ??= AudioPlayer();

  @override
  bool get isAvailable => true;

  @override
  Future<bool> playAsset(String assetPath) async {
    // Only real, on-disk files are playable here; the in-memory test store
    // returns `memory://…` which this player cannot open.
    if (!assetPath.startsWith('/')) return false;
    try {
      final player = _ensure();
      await player.stop();
      await player.play(DeviceFileSource(assetPath));
      return true;
    } catch (e) {
      debugPrint('FileAudioPlayer failed: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }

  void dispose() {
    _player?.dispose();
    _player = null;
  }
}
