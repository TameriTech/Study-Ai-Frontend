// coverage:ignore-file
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class UserRepository {
   late LaravelApiClient _laravelApiClient;


   Future register(UserModel user) {
      _laravelApiClient = Get.find<LaravelApiClient>();
      return _laravelApiClient.registerUser(user);
   }

   Future login(UserModel user) {
      try{

      }catch(e){
         rethrow;
      }
      _laravelApiClient = Get.find<LaravelApiClient>();
      return _laravelApiClient.login(user);
   }

   Future getUser(int userId) async {
      _laravelApiClient = Get.find<LaravelApiClient>();
      var user = await _laravelApiClient.getUser(userId);
      print('user is $user');
      return user;
   }


}
