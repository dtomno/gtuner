import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gtuner/code/controllers/home.dart';
import 'package:gtuner/code/controllers/tuner.dart';
import 'package:gtuner/colors/colors.dart';
import 'package:gtuner/views/about.dart';
import 'package:gtuner/views/tools/tools_home.dart';
import 'package:gtuner/views/tuner/tuner.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _homeController = Get.find<HomeController>();

  final _tunerController = Get.find<TunerController>();

  final List<Widget> _pages = [tuner(), tools()];

  @override
  void initState() {
    super.initState();
    _tunerController.recordAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('gtuner'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 0) {
              Get.to(const About());
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<int>(
                value: 0,
                child: Text("About"),
              ),
            ];
          })
        ],
      ),
      body: Obx(
        () => Column(
          children: [_pages.elementAt(_homeController.selectedIndex.value)],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.mainColor,
            iconSize: 40,
            selectedFontSize: 18,
            unselectedFontSize: 18,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: AppColors.normalColor,
            currentIndex: _homeController.selectedIndex.value,
            onTap: (index) => _homeController.selectedIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.guitar), label: 'Tune'),
              BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Tools'),
            ]),
      ),
    );
  }
}
