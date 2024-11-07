import 'package:flutter/scheduler.dart';
import 'package:flutter_sequencer/models/instrument.dart';
import 'package:flutter_sequencer/sequence.dart';
import 'package:flutter_sequencer/track.dart';
import 'package:get/get.dart';

class MetroController extends GetxController {
  Rx<int> count = 0.obs;
  Sequence? sequence;
  Track? track;
  Ticker? ticker;
  Rx<int> beats = 4.obs;
  Rx<double> tempo = 30.0.obs;
  Rx<bool> play = false.obs;

  @override
  void onInit() {
    super.onInit();
    sequence = Sequence(tempo: (tempo.value / 2.8), endBeat: beats.toDouble());
    final instruments = [
      Sf2Instrument(path: 'sounds/Metronom.sf2', isAsset: true)
    ];
    sequence!.createTracks(instruments).then((tracks) => track = tracks[0]);
    ticker = Ticker(((elapsed) => count.value = sequence!.getBeat().toInt()));
  }

  @override
  void onClose() {
    ticker!.dispose();
    super.onClose();
  }

  void start() {
    for (var i = 0; i <= beats.value - 1; i++) {
      if (i == 0) {
        track!.addNote(
            noteNumber: 77,
            velocity: 1.0,
            startBeat: i.toDouble(),
            durationBeats: 0.0);
      } else {
        track!.addNote(
            noteNumber: 76,
            velocity: 1.0,
            startBeat: i.toDouble(),
            durationBeats: 0.0);
      }
    }
    sequence!.setLoop(0.0, beats.value.toDouble());
    ticker!.start();
    sequence!.play();
  }

  void stop() {
    count.value = 0;
    ticker!.stop();
    sequence!.stop();
  }

  void updateMetro(tempo) {
    sequence!.setTempo((tempo.value / 2.8));
  }
}
