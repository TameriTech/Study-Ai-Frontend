import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:studyai/app/models/user_model.dart';
import '../../color_constants.dart';
import '../exceptions/network_exceptions.dart';
import '../routes/app_routes.dart';
import '../services/global_services.dart';
import '../../l10n/app_localizations.dart';


class LaravelApiClient extends GetxService {
  late Dio httpClient;
  late String baseUrl;
  late dio.Options optionsNetwork;
  late dio.Options optionsCache;

  LaravelApiClient({required Dio dio}) {
    baseUrl = GlobalService().baseUrl;
    httpClient = dio;
  }

  Future<LaravelApiClient> init() async {
    return this;
  }


  registerUser(UserModel user)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var data = user.toJson();
      print('user${data}');
      var response = await httpClient.request(
        '$baseUrl/register',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);;
    }on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AppLocalizations.of(Get.context!).user_with_email_exists;
      } else if (e.response?.statusCode == 403) {
        throw AppLocalizations.of(Get.context!).user_with_email_exists;
      } else {
        throw NetworkExceptions.getDioException(e);
      }
    }
    catch (e) {

        throw NetworkExceptions.getDioException(e);

    }//
  }

  updateUser(UserModel user)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var data = user.toJson();
      print('user${data}');
      var response = await httpClient.request(
        '$baseUrl/user/update/${user.userId}',
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    }on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AppLocalizations.of(Get.context!).user_with_email_exists;
      } else if (e.response?.statusCode == 403) {
        throw AppLocalizations.of(Get.context!).user_with_email_exists;
      } else {
        throw NetworkExceptions.getDioException(e);
      }
    }
    catch (e) {

      throw NetworkExceptions.getDioException(e);

    }//
  }


  login(UserModel user)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var data = user.toJson();
      var response = await httpClient.request(
        '$baseUrl/login',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );


      if (response.statusCode == 200) {
        print('date: ${response.data['user']['id']}');
        return (response.data['user']['id']);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw  FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    }on DioException catch (e) {
      print(e.response?.statusCode);
       if (e.response?.statusCode == 401) {
        throw AppLocalizations.of(Get.context!).invalid_credentials;
      } else {
        throw NetworkExceptions.getDioException(e);
      }
    }
    catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  loginGoogle(String idToken)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/login/google',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: {"id_token": idToken},
      );


      if (response.statusCode == 200) {
        print('date: ${response.data['user']['id']}');
        return (response.data['user']['id']);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    }on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response?.statusCode == 401) {
        throw "Invalid credentials";
      } else {
        throw NetworkExceptions.getDioException(e);
      }
    }
    catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  loginFacebook(String accessToken)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/login/facebook',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: {"access_token": accessToken},
      );


      if (response.statusCode == 200) {
        print('date: ${response.data['user']['id']}');
        return (response.data['user']['id']);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    }on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response?.statusCode == 401) {
        throw AppLocalizations.of(Get.context!).invalid_credentials;
      } else {
        throw NetworkExceptions.getDioException(e);
      }
    }
    catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }


  getUser(int userId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/get-user/$userId',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );


      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  Future extractTextFromImage({required int id, required imageFile, required String instructions}) async {
      try {
        var headers = {
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json'
        };

        var request = http.MultipartRequest(
            'POST', Uri.parse(
            '${GlobalService().baseUrl}/extract-text-from-image/?user_id=$id'));
        request.fields.addAll({
          'instructions': instructions,
        });

        if (imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'file', "${imageFile!.path}", contentType:  MediaType('image', 'png'), ));
        }


        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();


        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          var result = jsonDecode(data);
          print('result is  ${result['cours_info']['id']}');
          return result['cours_info']['id'];
        }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  Future extractTextFromPDFFile({required int id, required pdfFile}) async {
    print(pdfFile.path);
    print('user id is : $id');
    try {
      if (pdfFile == null || !await File(pdfFile!.path).exists()) {
        throw Exception(AppLocalizations.of(Get.context!).pdf_file_not_found);
      }

      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      };


      var request = http.MultipartRequest('POST', Uri.parse('${GlobalService().baseUrl}/extract-pdf-text?user_id=$id'));
      request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('data is: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        var result = jsonDecode(data);
        print('result is  $result');
        return result['course_info']['id'];

      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw Exception(e);
    }
  }

  getUserCourses(int userId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/user/$userId/courses',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );


      if (response.statusCode == 200) {
        List<Map<String, dynamic>> extractedCourses = [];

        if (response.data != null && response.data['courses'] is List) {
          for (var courseMap in response.data['courses']) {
            if (courseMap is Map<String, dynamic>) {
              for (var course in courseMap.values) {
                if (course is Map<String, dynamic>) {
                  extractedCourses.add(course);
                }
              }
            }
          }
        }

        return extractedCourses;
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      print(e);
      throw NetworkExceptions.getDioException(e);
    }//
  }

  getCourseById(int courseId)async{
    const maxRetries = 3;
    int attempt = 0;
    while (attempt < maxRetries) {
      try{
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        };

        var response = await httpClient.request(
          '$baseUrl/get-course/$courseId/',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          return (response.data);
        }
        else {
          print(response.statusMessage);
          break;
        }
      }on SocketException catch (e) {
        throw SocketException(e.toString());
      } on FormatException catch (_) {
        throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          throw NetworkExceptions.getDioException(e);
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }//

    }


  }

  getVocabularyByCourse(int courseId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/vocabularies/$courseId/words',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );


      if (response.statusCode == 200) {
        print("vocabulary extracted");
        return (response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  getCourseSimplifiedModule(int courseId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/courses-id/$courseId/simplified-modules',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        return (response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  getCourseSummaryModule(int courseId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/api/courses/$courseId/summary-modules',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {

        return (response.data);
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  createVocabulary(int courseId)async{
    print('id is ss : $courseId');
    const maxRetries = 3;
    int attempt = 0;
    while (attempt < maxRetries) {
      try{
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        };
        var response = await httpClient.request(
          '$baseUrl/create-vocabularies/$courseId/',
          options: Options(
            method: 'POST',
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          return response.data;
        }
        else {

          print(response.statusMessage);
          break;
        }
      }on SocketException catch (e) {
        throw SocketException(e.toString());
      } on FormatException catch (_) {
        throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          throw NetworkExceptions.getDioException(e);
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }//
    }
  }

  getCourseVocabularyById(int courseId)async{
    const maxRetries = 3;
  int attempt = 0;
  while (attempt < maxRetries) {
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/vocabularies/$courseId/words',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        return (response.data);
      }
      else {
        print(response.statusMessage);
        break;
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      attempt++;
      if (attempt >= maxRetries) {
        throw NetworkExceptions.getDioException(e);
      }
      await Future.delayed(Duration(seconds: 2 * attempt));
    }//
  }

  }

  getUserQuizzes(int userId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/user/$userId/quizzes',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      print("Status code is: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> quizzes = [];
        if(!(response.data['detail'] == "No quizzes found for this user.")){
          response.data.forEach((key, value) {
            // `key` is like "Course_id:14"
            print('Parsing course: $key');
            // `value` is a List<dynamic> (list of questions for this course)
            quizzes.add(value);}
          );
          print('Quizzes are: ${quizzes.toString()}');
        }

        return (quizzes);

      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      print("error is $e");
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      print("Format exception");
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } on DioException catch (e){
      if(e.type == DioExceptionType.badResponse){
        List<dynamic> quizzes = [];
        return quizzes;
      }
    }
    catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  getUserRevisions(int userId)async{
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      var response = await httpClient.request(
        '$baseUrl/user/$userId/revisions',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> extractedRevisions = [];

        if (response.data != null && response.data['courses'] is List) {
          for (var courseMap in response.data['courses']) {
            if (courseMap is Map<String, dynamic>) {
              for (var course in courseMap.values) {
                if (course is Map<String, dynamic>) {
                  extractedRevisions.add(course);
                }
              }
            }
          }
        }
        return extractedRevisions;
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  createQuizz(int courseId, String quizzType, String levelOfDifficulty, int questionsNumber, String instruction)async{
    print('id is ss : $courseId');
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var response = await httpClient.request(
        '$baseUrl/create/quizzes/',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: {
          "course_id": courseId,
          "quiz_type": quizzType,
          "level_of_difficulty": levelOfDifficulty,
          "number_of_questions": questionsNumber,
          "quiz_instruction": instruction
        }
      );

      if (response.statusCode == 200) {
        return response.data["course_id"];
      }
      else {
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  getCourseQuizzes(int courseId)async{
    const maxRetries = 3;
    int attempt = 0;
    while (attempt < maxRetries) {
      try{
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        };

        var response = await httpClient.request(
          '$baseUrl/get-course/$courseId/quizzes',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          return (response.data);
        }
        else {
          print(response.statusMessage);
          break;
        }
      }on SocketException catch (e) {
        throw SocketException(e.toString());
      } on FormatException catch (_) {
        throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          throw NetworkExceptions.getDioException(e);
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }//
    }

  }

  updateUserAnswer(int quizzId, String userAnswer)async{
    print('id is ss : $quizzId');
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var response = await httpClient.request(
        '$baseUrl/quizzes/$quizzId/update-user-answer',
        options: Options(
          method: 'PATCH',
          headers: headers,
        ),
          data: {"user_answer":userAnswer}
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      else {
        print(response.statusCode);
        print(response.statusMessage);
      }
    }on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }//
  }

  requestQuizzResult(int courseId)async{
    String language = Get.locale.toString()=='fr'? 'fr':'en';
    const maxRetries = 3;
    int attempt = 0;
    while (attempt < maxRetries) {
      try{
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Accept-Language': language
        };

        var response = await httpClient.request(
          '${GlobalService().secondUrl}/create/feedback/$courseId',
          options: Options(
            method: 'POST',
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          return (response.data);
        }
        else {
          print(response.statusMessage);
          break;
        }
      }on SocketException catch (e) {
        throw SocketException(e.toString());
      } on FormatException catch (_) {
        throw FormatException(AppLocalizations.of(Get.context!).unable_to_process_data);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          throw NetworkExceptions.getDioException(e);
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }//
    }

  }



}
