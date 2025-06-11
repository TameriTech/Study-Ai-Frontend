import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../models/setting_model.dart';
import '../../../services/settings_services.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Form(
        key: controller.loginFormKey,
        child: Text('Forgot Password View'),
      ),
    );
  }
}
