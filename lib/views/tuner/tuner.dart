import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtuner/code/controllers/tuner.dart';
import 'package:gtuner/colors/colors.dart';

final _tunerController = Get.find<TunerController>();

Widget tuner() => SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Tunings',
                style: TextStyle(fontSize: 30, color: AppColors.mainColor),
              ),
              const SizedBox(height: 20),
              Obx(
                () => DropdownButton(
                    value: _tunerController.tuning.value,
                    items: _tunerController.tunings,
                    isExpanded: true,
                    onChanged: ((value) =>
                        _tunerController.tuning.value = value.toString())),
              ),
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(() => Text(
                    _tunerController.note.value,
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 80,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Text(
                    _tunerController.status.value == 'undefined'
                        ? 'Play something'
                        : _tunerController.status.value,
                    style: TextStyle(
                        fontSize: 24,
                        color: _tunerController.status.value == 'tuned' ||
                                _tunerController.status.value ==
                                    'Play something'
                            ? AppColors.okColor
                            : _tunerController.status.value == 'undefined'
                                ? AppColors.okColor
                                : AppColors.errorColor),
                  )),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Text(
                    _tunerController.frequency.value == 0.0
                        ? ''
                        : 'Target : ${_tunerController.frequency.value}',
                    style: const TextStyle(fontSize: 20),
                  )),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Text(
                    _tunerController.diff.value == 0.0
                        ? ''
                        : 'Diff : ${_tunerController.diff.value}',
                    style: const TextStyle(fontSize: 20),
                  )),
              const SizedBox(
                height: 80,
              ),
              Obx(
                () => Container(
                    child: _tunerController.tuning.value ==
                            'Any (Detects all notes)'
                        ? const Text(
                            'You can use this to learn notes on your guitar')
                        : Obx(
                            () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List<Widget>.generate(
                                    _tunerController.tuningNotes.length,
                                    (index) => Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color:
                                                _tunerController.tuningNotes[index] == (_tunerController.note.value)
                                                    ? AppColors.mainColor
                                                    : AppColors.grayedOut2,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                            child: Text(_tunerController.tuningNotes[index],
                                                style: TextStyle(
                                                    color: _tunerController
                                                                .tuningNotes[index] ==
                                                            (_tunerController.note.value)
                                                        ? AppColors.blue
                                                        : AppColors.normalColor)))))),
                          )),
              )
            ],
          ),
        ),
      ),
    );
