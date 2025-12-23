// coverage:ignore-file
// coverage:ignore-file
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart' as _get;


import '../../l10n/app_localizations.dart';
import '../routes/app_routes.dart';

abstract class NetworkExceptions {
  static String handleResponse(Response response) {
    int statusCode = response?.statusCode ?? 0;
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        _get.Get.offAllNamed(Routes.LOGIN);
        return AppLocalizations.of(Get.context!).unauthorized_request;
        break;

      case 404:
        return AppLocalizations.of(Get.context!).an_error_occurred;
        break;

      case 409:
        return AppLocalizations.of(Get.context!).conflict_error;
        break;

      case 408:
        return AppLocalizations.of(Get.context!).connection_timeout;
        break;

      case 500:
        return AppLocalizations.of(Get.context!).internal_server_error;
        break;

      case 503:
        return AppLocalizations.of(Get.context!).service_unavailable;
        break;

      case 422:
        return AppLocalizations.of(Get.context!).invalid_credentials;
        break;

      default:
        return AppLocalizations.of(Get.context!).invalid_status_code;
    }
  }

  static String getDioException(error) {
    if (error is Exception) {
      try {
        var errorMessage = "";
        if (error is DioError) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = AppLocalizations.of(Get.context!).request_cancelled;
              break;

            case DioExceptionType.connectionTimeout:
              errorMessage = AppLocalizations.of(Get.context!).connection_request_timeout;
              break;

            case DioExceptionType.connectionError:
              errorMessage = AppLocalizations.of(Get.context!).no_internet_connection;
              break;

            case DioExceptionType.receiveTimeout:
              errorMessage = AppLocalizations.of(Get.context!).send_timeout;
              break;

            case DioExceptionType.badResponse:
              errorMessage = NetworkExceptions.handleResponse(error.response!);
              break;

            case DioExceptionType.sendTimeout:
              errorMessage = AppLocalizations.of(Get.context!).send_timeout;
              break;

            case DioExceptionType.badCertificate:
            // TODO: Handle this case.
              break;

            case DioExceptionType.unknown:
            // TODO: Handle this case.
              break;
          }
        } else if (error is SocketException) {
          errorMessage = AppLocalizations.of(Get.context!).no_internet_connection;
        } else {
          errorMessage = AppLocalizations.of(Get.context!).unexpected_error;
        }
        return errorMessage;
      } on FormatException {
        return AppLocalizations.of(Get.context!).unexpected_error;
      } catch (_) {
        return AppLocalizations.of(Get.context!).unexpected_error;
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return AppLocalizations.of(Get.context!).unable_to_process_data;
      } else {
        return AppLocalizations.of(Get.context!).unexpected_error;
      }
    }
  }
}
