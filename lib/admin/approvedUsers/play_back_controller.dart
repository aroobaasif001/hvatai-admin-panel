import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackController extends GetxController {
  AudioPlayer? _currentPlayer;

  void setPlaying(AudioPlayer player) {
    _currentPlayer = player;
  }

  void stopAll() {
    if (_currentPlayer != null) {
      _currentPlayer!.stop();
      _currentPlayer = null;
    }
  }
}
