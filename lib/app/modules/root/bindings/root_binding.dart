import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/chat/controllers/chat_controller.dart';
import 'package:studyai/app/modules/profile/controllers/profile_controller.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/auth_service.dart';
import '../../files/controllers/files_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
          () => RootController(),
    );

    Get.lazyPut<AuthService>(
          () => AuthService(),
    );
    Get.lazyPut<LaravelApiClient>(
          () => LaravelApiClient(dio: Dio()),
    );
    Get.lazyPut<FilesController>(
          () => FilesController(),
    );
    Get.lazyPut<QuizController>(
          () => QuizController(), fenix: true
    );
    Get.lazyPut<ChatController>(
          () => ChatController(),
    );
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
  }
}

