import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:get/get.dart';
import 'package:gtuner/colors/colors.dart';
import 'package:gtuner/views/utils/info_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TunerController extends GetxController {
  final _audioCapture = FlutterAudioCapture();
  final _pitchDetector = PitchDetector(16000, 2000);
  final _pitchHandler = PitchHandler(InstrumentType.guitar);
  Rx<String> note = ''.obs;
  Rx<String> status = 'Play something'.obs;
  Rx<double> frequency = 0.0.obs;
  Rx<double> diff = 0.0.obs;
  Rx<double> actualFrequency = 0.0.obs;
  RxList tuningNotes = [].obs;

  final List<DropdownMenuItem<String>> tunings = const [
    DropdownMenuItem(
        value: 'Any (Detects all notes)',
        child: Text('Any (Detects all notes)')),
    DropdownMenuItem(value: 'Standard', child: Text('Standard')),
    DropdownMenuItem(value: 'Bass (4 string)', child: Text('Bass (4 string)')),
    DropdownMenuItem(value: 'Bass (5 string)', child: Text('Bass (5 string)')),
    DropdownMenuItem(value: 'Bass (6 string)', child: Text('Bass (6 string)')),
    DropdownMenuItem(value: 'Drop D', child: Text('Drop D')),
    DropdownMenuItem(value: 'Drop A', child: Text('Drop A')),
    DropdownMenuItem(value: 'Half step down', child: Text('Half step down')),
    DropdownMenuItem(value: 'Open C', child: Text('Open C')),
    DropdownMenuItem(value: 'Open D', child: Text('Open D')),
    DropdownMenuItem(value: 'Open F', child: Text('Open F')),
    DropdownMenuItem(value: 'Open G', child: Text('Open G'))
  ];

  Rx<String> tuning = 'Any (Detects all notes)'.obs;

  @override
  void onClose() async {
    await _audioCapture.stop();
    super.onClose();
  }

  ///Start recording audio
  Future<void> recordAudio() async {
    if (await Permission.microphone.request().isGranted ||
        await Permission.microphone.request().isLimited) {
      await _audioCapture.start(listener, onError,
          sampleRate: 16000, bufferSize: 2000);
    } else {
      InteractiveWidget(
          title: 'Permission failure',
          info: 'Please allow mic permission in app settings to tune guitar',
          buttonAction: () {
            Get.back();
          },
          titleColor: AppColors.errorColor);
    }
  }

  Future<void> stopAudio() async {
    await _audioCapture.stop();
  }

  ///listen's for audio stream
  void listener(o) {
    var buffer = Float64List.fromList(o.cast<double>());
    final List<double> audioSample = buffer.toList();

    final result = _pitchDetector.getPitch(audioSample);

    if (result.pitched) {
      final handledResult = _pitchHandler.handlePitch(result.pitch);

      note.value = handledResult.note;
      frequency.value = handledResult.expectedFrequency.truncateToDouble();
      diff.value = handledResult.diffFrequency.truncateToDouble();
      actualFrequency.value = frequency.value + diff.value;
      status.value = handledResult.tuningStatus
          .toString()
          .replaceFirst('TuningStatus.', '');

      if (tuning.value == 'Standard') {
        tuningNotes.value = ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'];
        standardTuning();
      } else if (tuning.value == 'Bass (4 string)') {
        tuningNotes.value = ['E1', 'A1', 'D2', 'G2'];
        bass4Tuning();
      } else if (tuning.value == 'Bass (5 string)') {
        tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2'];
        bass5Tuning();
      } else if (tuning.value == 'Bass (6 string)') {
        tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2', 'C3'];
        bass6Tuning();
      } else if (tuning.value == 'Drop D') {
        tuningNotes.value = ['D2', 'A2', 'D3', 'G3', 'B3', 'E4'];
        dropDTuning();
      } else if (tuning.value == 'Drop A') {
        tuningNotes.value = ['A1', 'A2', 'D3', 'G3', 'B3', 'E4'];
        dropATuning();
      } else if (tuning.value == 'Half step down') {
        tuningNotes.value = ['D#2', 'G#2', 'C#3', 'F#3', 'A#3', 'D#4'];
        halfStepDownTuning();
      } else if (tuning.value == 'Open C') {
        tuningNotes.value = ['C2', 'G2', 'C3', 'G3', 'C4', 'E4'];
        openCTuning();
      } else if (tuning.value == 'Open D') {
        tuningNotes.value = ['D2', 'A2', 'D3', 'F#3', 'A3', 'D4'];
        openDTuning();
      } else if (tuning.value == 'Open F') {
        tuningNotes.value = ['C2', 'F2', 'C3', 'F3', 'A3', 'F4'];
        openFTuning();
      } else if (tuning.value == 'Open G') {
        tuningNotes.value = ['D2', 'G2', 'D3', 'G3', 'B3', 'D4'];
        openGTuning();
      } else {
        tuningNotes.value = [];
      }
    }
  }

  void tune(target) {
    frequency.value = target;
    diff.value = actualFrequency.value - target;
    if (diff >= -0.5 && diff <= 0.5) {
      status.value = 'tuned';
    } else if (diff >= -2.0 && diff <= -0.5) {
      status.value = 'low';
    } else if (diff > 0.5 && diff <= 2.0) {
      status.value = 'high';
    } else if (diff >= double.negativeInfinity && diff <= -2.0) {
      status.value = 'toolow';
    } else {
      status.value = 'toohigh';
    }
  }

  void standardTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'E2';
      tune(82.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass4Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0) {
      note.value = 'G2';
      tune(97.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass5Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 41.0) {
      note.value = 'B0';
      tune(30.0);
    }
    if (frequency.value >= 41.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0) {
      note.value = 'G2';
      tune(97.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass6Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 41.0) {
      note.value = 'B0';
      tune(30.0);
    }
    if (frequency.value >= 41.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0 && frequency.value < 130.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 130.0) {
      note.value = 'C3';
      tune(130.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void dropDTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void dropATuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void halfStepDownTuning() {
    if (frequency.value >= 30.0 && frequency.value < 103.0) {
      note.value = 'D#2';
      tune(77.0);
    } else if (frequency.value >= 103.0 && frequency.value < 138.0) {
      note.value = 'G#2';
      tune(103.0);
    } else if (frequency.value >= 138.0 && frequency.value < 185.0) {
      note.value = 'C#3';
      tune(138.0);
    } else if (frequency.value >= 185.0 && frequency.value < 233.0) {
      note.value = 'F#3';
      tune(185.0);
    } else if (frequency.value >= 233.0 && frequency.value < 311.0) {
      note.value = 'A#3';
      tune(233.0);
    } else if (frequency.value >= 311.0) {
      note.value = 'D#4';
      tune(311.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openCTuning() {
    if (frequency.value >= 30.0 && frequency.value < 97.0) {
      note.value = 'C2';
      tune(65.0);
    } else if (frequency.value >= 97.0 && frequency.value < 130.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 130.0 && frequency.value < 195.0) {
      note.value = 'C3';
      tune(130.0);
    } else if (frequency.value >= 195.0 && frequency.value < 261.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 261.0 && frequency.value < 329.0) {
      note.value = 'C4';
      tune(261.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openDTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 185.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 185.0 && frequency.value < 220.0) {
      note.value = 'F#3';
      tune(185.0);
    } else if (frequency.value >= 220.0 && frequency.value < 293.0) {
      note.value = 'A3';
      tune(220.0);
    } else if (frequency.value >= 293.0) {
      note.value = 'D4';
      tune(293.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openFTuning() {
    if (frequency.value >= 30.0 && frequency.value < 87.0) {
      note.value = 'C2';
      tune(65.0);
    } else if (frequency.value >= 87.0 && frequency.value < 130.0) {
      note.value = 'F2';
      tune(87.0);
    } else if (frequency.value >= 130.0 && frequency.value < 174.0) {
      note.value = 'C3';
      tune(130.0);
    } else if (frequency.value >= 174.0 && frequency.value < 220.0) {
      note.value = 'F3';
      tune(174.0);
    } else if (frequency.value >= 220.0 && frequency.value < 349.0) {
      note.value = 'A3';
      tune(220.0);
    } else if (frequency.value >= 349.0) {
      note.value = 'F4';
      tune(349.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openGTuning() {
    if (frequency.value >= 30.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0 && frequency.value < 146.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 146.0 && frequency.value < 196.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 293.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 293.0) {
      note.value = 'D4';
      tune(293.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void onError(e) {}
}
