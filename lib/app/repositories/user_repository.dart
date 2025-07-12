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

   Future updateUser(UserModel user) {
      _laravelApiClient = Get.find<LaravelApiClient>();
      return _laravelApiClient.updateUser(user);
   }

   Future login(UserModel user) {
      try{
         _laravelApiClient = Get.find<LaravelApiClient>();
         return _laravelApiClient.login(user);
      }catch(e){
         rethrow;
      }

   }

   Future loginGoogle(String  idToken) {
      try{
         _laravelApiClient = Get.find<LaravelApiClient>();
         return _laravelApiClient.loginGoogle(idToken);
      }catch(e){
         rethrow;
      }

   }

   Future loginFacebook(String  accessToken) {
      try{
         _laravelApiClient = Get.find<LaravelApiClient>();
         return _laravelApiClient.loginFacebook(accessToken);
      }catch(e){
         rethrow;
      }

   }

   Future getUser(int userId) async {
      _laravelApiClient = Get.find<LaravelApiClient>();
      var user = await _laravelApiClient.getUser(userId);
      print('user is $user');
      return user;
   }


}
