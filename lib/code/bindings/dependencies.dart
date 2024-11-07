import 'package:get/get.dart';
import 'package:gtuner/code/controllers/chords.dart';
import 'package:gtuner/code/controllers/metro.dart';
import 'package:gtuner/code/controllers/tuner.dart';

class DependenciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChordController());
    Get.lazyPut<MetroController>(() => MetroController(), fenix: true);
    Get.lazyPut<TunerController>(() => TunerController(), fenix: true);
  }
}
