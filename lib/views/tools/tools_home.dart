import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:gtuner/colors/colors.dart';
import 'package:gtuner/views/tools/chords.dart';
import 'package:gtuner/views/tools/metro.dart';

Widget tools() => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tools',
              style: TextStyle(fontSize: 30, color: AppColors.mainColor),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Metronome',
              style: TextStyle(fontSize: 22),
            ),
            Card(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink.image(
                      image: const AssetImage('images/tempo.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          AppColors.imageOpacity, BlendMode.dstATop),
                      height: 220,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const Metro());
                        },
                      ),
                    ),
                    Icon(
                      CupertinoIcons.metronome,
                      size: 50,
                      color: AppColors.mainColor,
                    )
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Chords',
              style: TextStyle(fontSize: 22),
            ),
            Card(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink.image(
                      image: const AssetImage('images/chords.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          AppColors.imageOpacity, BlendMode.dstATop),
                      height: 220,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => Chords());
                        },
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      size: 50,
                      color: AppColors.mainColor,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
