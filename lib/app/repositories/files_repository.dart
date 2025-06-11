// coverage:ignore-file
import 'package:get/get.dart';
import '../providers/laravel_provider.dart';

class FilesRepository {
  late LaravelApiClient _laravelApiClient;

  Future extractTextFromImage({required int id, required imageFile, required String instructions}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.extractTextFromImage(id: id, imageFile: imageFile, instructions: instructions);
  }

  Future extractTextFromPDFFile({required int id, required pdfFile}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.extractTextFromPDFFile(id: id, pdfFile: pdfFile);
  }

  Future createVocabulary({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.createVocabulary(courseId);
  }

  Future getCourseById({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getCourseById(courseId);
  }

  Future getUserCourses({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUserCourses(courseId);
  }

  Future getVocabularyByCourse({required int courseId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getVocabularyByCourse(courseId);
  }

  Future getUserRevisions({required int userId}) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUserRevisions(userId);
  }

}
