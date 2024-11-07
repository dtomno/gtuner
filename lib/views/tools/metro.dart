import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtuner/code/controllers/metro.dart';
import 'package:gtuner/code/controllers/tuner.dart';
import 'package:gtuner/colors/colors.dart';

class Metro extends StatefulWidget {
  const Metro({Key? key}) : super(key: key);

  @override
  State<Metro> createState() => _MetroState();
}

class _MetroState extends State<Metro> with WidgetsBindingObserver {
  final _metroController = Get.find<MetroController>();

  final _tunerController = Get.find<TunerController>();

  final double _iconSize = 40;

  final List<DropdownMenuItem<int>> times = const [
    DropdownMenuItem(
      value: 1,
      child: Text('1/4'),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('2/4'),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('3/4'),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('4/4'),
    )
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _tunerController.stopAudio();
  }

  @override
  void dispose() {
    if (_metroController.play.value) {
      _metroController.stop();
    }
    _tunerController.recordAudio();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      if (_metroController.play.value) {
        _metroController.play.value = false;
        _metroController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metronome')),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(
          () => Text(
            '${_metroController.tempo.round()} BPM',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                iconSize: _iconSize,
                onPressed: () {
                  if (_metroController.tempo.value > 30.0) {
                    _metroController.tempo.value -= 1.0;
                    _metroController.updateMetro(_metroController.tempo);
                  }
                },
                icon: const Icon(Icons.remove),
                color: AppColors.mainColor),
            Obx(
              () => Slider(
                  value: _metroController.tempo.value,
                  onChanged: (value) {
                    _metroController.tempo.value = value.round().toDouble();
                    _metroController.updateMetro(_metroController.tempo);
                  },
                  max: 240.0,
                  min: 30.0,
                  activeColor: AppColors.mainColor),
            ),
            IconButton(
                iconSize: _iconSize,
                onPressed: () {
                  if (_metroController.tempo < 240.0) {
                    _metroController.tempo.value += 1.0;
                    _metroController.updateMetro(_metroController.tempo);
                  }
                },
                icon: const Icon(Icons.add),
                color: AppColors.mainColor),
          ],
        ),
        const SizedBox(height: 60),
        Obx(
          () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(
                  _metroController.beats.value,
                  (i) => Obx(
                        () => Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: i == (_metroController.count.value) &&
                                        _metroController.play.value
                                    ? AppColors.mainColor
                                    : AppColors.grayedOut,
                                borderRadius: BorderRadius.circular(50))),
                      ))),
        ),
        const SizedBox(
          height: 50,
        ),
        const Text('Time signature'),
        Obx(
          () => DropdownButton(
              value: _metroController.beats.value,
              items: times,
              onChanged: (int? value) {
                _metroController.beats.value = value!;
                _metroController.stop();
                _metroController.play.value = false;
              }),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Obx(
            () => IconButton(
              iconSize: _iconSize,
              onPressed: () {
                _metroController.play.value = !_metroController.play.value;
                if (_metroController.play.value) {
                  _metroController.start();
                } else {
                  _metroController.stop();
                }
              },
              icon: _metroController.play.value == false
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
              color: AppColors.mainColor,
            ),
          ),
        ]),
        Obx(
          () => Text(
              _metroController.play.value == false
                  ? 'Tap to play'
                  : 'Tap to stop',
              style: TextStyle(
                  color: _metroController.play.value == false
                      ? AppColors.okColor
                      : AppColors.errorColor)),
        ),
      ]),
    );
  }
}
