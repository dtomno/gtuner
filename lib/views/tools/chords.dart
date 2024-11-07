import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gtuner/code/controllers/chords.dart';
import 'package:gtuner/colors/colors.dart';

class Chords extends StatelessWidget {
  Chords({super.key});

  final _chordController = Get.find<ChordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Library'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select a chord',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => DropdownButton(
                  value: _chordController.chordName.value,
                  items: _chordController.notes,
                  onChanged: (String? value) {
                    _chordController.chordName.value = value.toString();
                    _chordController.chordList(_chordController.chordName.value,
                        _chordController.chordType.value);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Obx(
                () => DropdownButton(
                  value: _chordController.chordType.value,
                  items: _chordController.chordTypes,
                  onChanged: (value) {
                    _chordController.chordType.value = value.toString();
                    _chordController.chordList(_chordController.chordName.value,
                        _chordController.chordType.value);
                  },
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CarouselSlider(
                items: _chordController.changingChords.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SvgPicture.asset(
                            i,
                            color: AppColors.mainColor,
                          ));
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                    initialPage: _chordController.currentIndex.value,
                    onPageChanged: (index, reason) {
                      _chordController.currentIndex.value = index;
                    },
                    height: 300,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      _chordController.changingChords.length,
                      (i) => Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                  height: 10,
                                  width: 10,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: i ==
                                              _chordController
                                                  .currentIndex.value
                                          ? AppColors.mainColor
                                          : AppColors.grayedOut,
                                      borderRadius: BorderRadius.circular(50))),
                            ),
                          ))),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Swipe to see more shapes')
        ],
      ),
    );
  }
}
