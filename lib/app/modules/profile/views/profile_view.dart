import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/warning_pupop.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(null),
          leadingWidth: 0,
          title: Text(
            AppLocalizations.of(context).my_profile,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.onInit();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Section
                    Center(
                      child: Column(
                        children: [
                          // Profile Avatar
                          Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                          // Name with Edit Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Text(
                                controller.currentUser.value.fullName ?? "User",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.CHANGE_USERNAME);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height/6),

                    // School Level Section
                    Text(
                      AppLocalizations.of(context).school_level,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildMenuItem(
                      context: context,
                      title: controller.currentUser.value.academicLevel ?? "Not set",
                      onTap: () {
                        Get.toNamed(Routes.COMPLETE_PROFILE_VIEW);
                      },
                    ),

                    SizedBox(height: 24),

                    // Quiz Summary Section
                    Text(
                      "Quiz Summary",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildQuizSummaryCard(context),

                    SizedBox(height: 24),

                    // Your Language Section
                    Text(
                      AppLocalizations.of(context).language,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildMenuItem(
                      context: context,
                      title: controller.languageBox.read('language') == 'fr'
                          ? "Français"
                          : "English",
                      onTap: () => Get.toNamed(Routes.SETTINGS_LANGUAGE),
                    ),

                    SizedBox(height: 24),

                    // Change Password
                    _buildMenuItem(
                      context: context,
                      title: AppLocalizations.of(context).password,
                      onTap: () {
                        Get.toNamed(Routes.CHANGE_PASSWORD);
                      },
                    ),

                    SizedBox(height: 16),

                    // Logout
                    _buildMenuItem(
                      context: context,
                      title: AppLocalizations.of(context).logout,
                      icon: Icons.logout,
                      showArrow: false,
                      onTap: () => Get.toNamed(Routes.LOGIN),
                    ),

                    SizedBox(height: 16),

                    // Delete Account
                    _buildMenuItem(
                      context: context,
                      title: AppLocalizations.of(context).delete_account,
                      icon: Icons.delete_forever,
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      showArrow: false,
                      onTap: () {
                        WarningDialog.show(
                          context: context,
                          title: AppLocalizations.of(context).attention,
                          message: AppLocalizations.of(context).delete_account_warning,
                          confirmText: AppLocalizations.of(context).ok,
                          onConfirm: () {
                            controller.deleteAccount();
                          },
                        );
                      },
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    IconData? icon,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: titleColor ?? Colors.black,
          ),
        ),
        trailing: icon != null
            ? Icon(icon, color: iconColor ?? Colors.grey.shade400)
            : showArrow
            ? Icon(Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400)
            : null,
      ),
    );
  }

  Widget _buildQuizSummaryCard(BuildContext context) {
    var statistic = double.tryParse(
        controller.currentUser.value.statistic?.toString() ?? "0"
    ) ?? 0;
    var progressValue = statistic / 100;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed Quiz",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "40", // You can make this dynamic from controller
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Highest Score",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "60%",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Lowest Score",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "20%",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Right side - Circular Progress
              Column(
                children: [
                  Text(
                    "Average Score Rating",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressValue <= 0.30
                                  ? Colors.red
                                  : progressValue <= 0.50
                                  ? Colors.orange
                                  : appColor,
                            ),
                          ),
                        ),
                        Text(
                          "${statistic.toInt()}%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}