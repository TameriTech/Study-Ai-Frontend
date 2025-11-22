import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/files_controller.dart';

class RevisionView extends GetView<FilesController> {
  const RevisionView({super.key});

  @override
  Widget build(BuildContext context) {
    var fileInfo;
    if (Get.arguments != null) {
      fileInfo = Get.arguments;
    }
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      fileInfo.title,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineSmall
                    ),
                  ),
                  SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),

            // Page Counter
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: Obx(() => Text(
                '${controller.currentRevisionIndex.value + 1}/${controller.revisions.length} Pages',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
            ),

            // Card Container
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.revisions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F1E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              controller: controller.scrollController,
                              radius: Radius.circular(8),
                              thickness: 6,
                              child: SingleChildScrollView(
                                controller: controller.scrollController,
                                padding: EdgeInsets.all(24),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: controller.revisions[index]['topic'] + "\n\n",
                                        style: Get.textTheme.titleMedium
                                      ),
                                      TextSpan(
                                        text: controller.revisions[index]['body'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Obx(() => _buildNavigationButtons(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final isFirstPage = controller.currentRevisionIndex.value == 0;
    final isLastPage = controller.currentRevisionIndex.value + 1 >= controller.revisions.length;

    // First page: Only "Next" button (full width)
    if (isFirstPage) {
      return ElevatedButton(
        onPressed: controller.nextRevisionCard,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(double.infinity, 56),
          elevation: 0,
        ),
        child: Text(
          AppLocalizations.of(context).next,
          style: Get.textTheme.labelMedium
        ),
      );
    }

    // Last page: Only "Continue" button (full width)
    if (isLastPage) {
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(double.infinity, 56),
          elevation: 0,
        ),
        child: Text(
          'Continue',
          style: Get.textTheme.labelMedium
        ),
      );
    }

    // Middle pages: "Previous" and "Next" buttons
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.previousRevisionCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: disableButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 56),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context).previous,
              style: Get.textTheme.labelMedium
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.nextRevisionCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 56),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context).next,
              style: Get.textTheme.labelMedium
            ),
          ),
        ),
      ],
    );
  }
}