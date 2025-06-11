// coverage:ignore-file
import 'package:get/get.dart';
import '../providers/laravel_provider.dart';

class QuizzRepository {
  late LaravelApiClient _laravelApiClient;

  Future createQuizz({required int courseId, required String quizzType, required String levelOfDifficulty, required int questionsNumber, required String instruction}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.createQuizz(courseId, quizzType, levelOfDifficulty, questionsNumber, instruction);
  }


  Future getUserQuizzes({required int userId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUserQuizzes(userId);
  }

  Future getCourseQuizzes({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getCourseQuizzes(courseId);
  }

  Future updateUserAnswer({required int quizzId, required String userAnswer}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUserAnswer(quizzId, userAnswer );
  }

  Future requestQuizzResult({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.requestQuizzResult(courseId);
  }


}
