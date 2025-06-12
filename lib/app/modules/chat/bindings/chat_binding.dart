import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/chat/controllers/chat_controller.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/auth_service.dart';


class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
          () => ChatController(),
    );
    Get.lazyPut<AuthService>(
          () => AuthService(),
    );
    Get.lazyPut<LaravelApiClient>(
          () => LaravelApiClient(dio: Dio()),
    );
  }
}

