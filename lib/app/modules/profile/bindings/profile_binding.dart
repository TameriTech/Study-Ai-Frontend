import 'package:get/get.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );


  }
}