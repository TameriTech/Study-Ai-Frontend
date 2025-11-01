import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyai/app/repositories/files_repository.dart';
import 'package:studyai/app/repositories/quizz_repository.dart';
import 'package:studyai/color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/file_card_model.dart';
import '../../../models/question_model.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../quiz/controllers/quiz_controller.dart';


class FilesController extends GetxController with GetTickerProviderStateMixin{

  final Rx<UserModel> currentUser = Get.find<AuthService>().user;
   RxList<dynamic> filesList = [].obs;
   var courseGenerationState = ['start','ongoing','failed', 'generated'];
  var courseList = [].obs;
  var quizList = [].obs;
  var revisionList = [].obs;
  var safeFilesList = [];
  var safeCourseList = [];
  var safeQuizList = [];
  var safeRevisionList = [];

  RxDouble progress = 0.0.obs;
  Timer? _timer;
  Duration duration = Duration(seconds: 1);
  var generationState = ''.obs;
  var file = Rxn<XFile>();

  late TabController tabCourseController;
  late TabController tabViewController;

  var introductionSelected = false.obs;
  var notationVocabularySelected = true.obs;
  var otherSelected = true.obs;
  var filesLoading = false.obs;

  var selectedHomeIndex = 0.obs;
  late FilesRepository filesRepository;
  late QuizzRepository quizzRepository;
  TextEditingController instructionsController = TextEditingController();
  var importedFile;
  var generatedCourse = FileCardModel(title: '', timeInfo: '', type: 'Course', createdAt:  '');

  //Revisions Variables

  List revisions = [];

  RxInt currentRevisionIndex = 0.obs;
  final PageController pageController = PageController();


// Quizz Question management
  final RxList<Question> questions = <Question>[].obs;


  final RxInt currentQuestionIndex = 0.obs;
  final RxList<dynamic> correctAnswers = <dynamic>[].obs;
  final RxList<dynamic> selectedAnswers = <dynamic>[].obs;
  var selectedAnswer = 100.obs;

  // Question timer
  final RxDouble questionProgress = 0.0.obs;
  final Duration questionDuration = const Duration(seconds: 20);
  final int updatesPerSecond = 60;

  late Question question;

  final ScrollController scrollController = ScrollController();


  @override
  void dispose() {
    tabCourseController.dispose();
    instructionsController.dispose();
  super.dispose();
  }

  FilesController() {

  }

  @override
  void onInit() async {

    super.onInit();
    filesRepository = FilesRepository();
    quizzRepository = QuizzRepository();
    generationState = 'start'.obs;
    instructionsController.text = "";
    //initialize file List

    await getCompleteFileList();

    tabCourseController = TabController(length: 3, vsync: this);
    tabViewController = TabController(length: 4, vsync: this);

  }

  getCompleteFileList() async {
    filesList.clear();
    courseList.clear();
    quizList.clear();
    revisionList.clear();
    safeFilesList.clear();
    safeCourseList.clear();
    safeQuizList.clear();
    safeRevisionList.clear();
    filesLoading.value = true;
    var courseData = await getUserCourses(userId: currentUser.value.userId!)??[];
    filesList.addAll(courseData);
    var revisionData = await getUserRevisions(userId: currentUser.value.userId!)??[];
    filesList.addAll(revisionData);
    var quizzData = await getUserQuizzes(userId: currentUser.value.userId!)??[];
    filesList.addAll(quizzData);

    filesList.sort((a, b) => b.createdAt.compareTo(a.createdAt),);

    courseList.value = filesList.where((element) => element.type == "Course",).toList();
    quizList.value = filesList.where((element) => element.type == "Quizz",).toList();
    revisionList.value = filesList.where((element) => element.type == "Revision",).toList();

    safeFilesList = filesList;
    safeCourseList = courseList;
    safeQuizList = quizList;
    safeRevisionList = revisionList;

    filesLoading.value = false;
  }

  getFileCardColor(String type) {
    switch (type.toLowerCase()) {
      case "course":
        return courseColor;
      case "revision":
        return revisionColor;
      case "quizz":
        return quizzColor;
      default:
        return;
    }
  }

  Future<void> startProgress() async {
    try {
      generationState.value = "start"; // Initial state

      // --- Step 1: Perform API calls ---
      int courseId;
      if (!importedFile.path.contains('.pdf')) {
        courseId = await extractTextFromImage(
          instructions: instructionsController.text,
          userId: currentUser.value.userId!,
          imageFile: importedFile,
        );
      } else {
        courseId = await extractTextFromPDFFile(
          userId: currentUser.value.userId!,
          pdfFile: importedFile,
        );
      }
      print('Course id is $courseId');

      var vocabulary = await createVocabulary(courseId: courseId);
      print('Vocabulary is :$vocabulary');

      var courseData = await getCourseById(courseId: courseId);
      generatedCourse.id = courseId;
      generatedCourse.title = courseData['course_name'];
      generatedCourse.subtitle = courseData['level_of_difficulty'];
      generatedCourse.timeInfo = courseData['estimated_completion_time'];
      generatedCourse.courseData = courseData['simplified_modules'];
      generatedCourse.vocabulariesData = vocabulary['words'];

      const int updatesPerSecond = 60; // Smooth updates per second
      final int totalUpdates = duration.inSeconds * updatesPerSecond;
      final double increment = 2.0 / totalUpdates;

      int updateCount = 0;

      _timer = Timer.periodic(
        Duration(milliseconds: 1000 ~/ updatesPerSecond),
            (timer) async {

          progress.value += increment;

          updateCount++;


            generationState.value = "ongoing";

          if (updateCount >= totalUpdates) {
            _timer?.cancel();
            generationState.value = "generated";
            await getCompleteFileList();

          }
        },
      );
    } catch (e) {
      // --- Step 4: Handle error during API call ---
      generationState.value = "failed";

      _timer?.cancel();

      Navigator.of(Get.context!).pop();// Stop progress if error

      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }



  Future extractTextFromImage({required int userId, required imageFile, required String instructions}) async {

    try{

      var result = await filesRepository.extractTextFromImage(id: userId, imageFile: imageFile, instructions:instructions);
      return result;


    } catch(e){

      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future extractTextFromPDFFile({required int userId, required pdfFile}) async {

    try{

      var result = await filesRepository.extractTextFromPDFFile(id: userId, pdfFile: pdfFile);
      return result;

    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      //loading.value = false;
    }
  }

  Future getCourseById({required int courseId}) async {

    try{

      var result = await filesRepository.getCourseById(courseId: courseId);
      return result;


    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }
  }

  Future createVocabulary({required int courseId}) async {

    try{

      var result = await filesRepository.createVocabulary(courseId: courseId);
      return result;


    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future getVocabularyByCourse({required int courseId}) async {

    try{

      var result = await filesRepository.getVocabularyByCourse(courseId: courseId);
      return result;


    } catch(e){
      return [];
      //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future getUserCourses({required int userId}) async {

    FileCardModel fileCardModel;
    var courseList = [];
    try{

      var result = await filesRepository.getUserCourses(courseId: userId);
      var courses = result;
      var vocabulary;

      for(var course in courses){


          vocabulary = await getVocabularyByCourse(courseId: course['id_course']);

        fileCardModel = FileCardModel(
            id: course['id_course'],
            title: course['course_name'],
            timeInfo: course['estimated_completion_time'],
            type: 'Course',
          subtitle:  course['level_of_difficulty'],
          courseData: course['simplified_modules'],
          createdAt: course['created_at']??'',
            hasQuizz: course['has_quiz'] == false?false:true,
          vocabulariesData: vocabulary.isEmpty?[]:vocabulary['words']

        );
        courseList.add(fileCardModel);


      }
      return courseList;


    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future getUserRevisions({required int userId}) async {

    FileCardModel fileCardModel;
    var revisionList = [];
    try{

      var result = await filesRepository.getUserRevisions(userId: userId);
      var revisions = result;

      for(var revision in revisions){
        fileCardModel = FileCardModel(
            title: revision['course_name'],
            timeInfo: revision['estimated_completion_time'],
            type: 'Revision',
            subtitle:  revision['level_of_difficulty'],
          createdAt: revision['created_at']??'',
            revisionData: revision['summary_modules'],
        );
        print("revisions: ${fileCardModel.revisionData}");
        revisionList.add(fileCardModel);

      }
      return revisionList;

    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }
  }

  Future getUserQuizzes({required int userId}) async {

    FileCardModel fileCardModel;
    var quizzList = [];
    try{

      var result = await quizzRepository.getUserQuizzes(userId: userId);
      var Quizzes = result;

      for(var quizz in Quizzes){
        print('quizz  is: ${quizz}');
        fileCardModel = FileCardModel(
          title: quizz[0]['course_name'],
          timeInfo: quizz[0]['estimated_completion_time']??"not defined",
          type: 'Quizz',
          subtitle:  quizz[0]['level_of_difficulty'],
          createdAt: quizz[0]['created_at'],
          quizzData: quizz,
        );
        quizzList.add(fileCardModel);
      }
      return quizzList;

    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      //loading.value = false;
    }

  }


  void nextRevisionCard() {
    if (currentRevisionIndex.value < revisions.length - 1) {
      currentRevisionIndex.value++;
      pageController.animateToPage(
        currentRevisionIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousRevisionCard() {
    if (currentRevisionIndex.value > 0) {
      currentRevisionIndex.value--;
      pageController.animateToPage(
        currentRevisionIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void nextQuizzQuestion() {
    selectedAnswer.value = 100;
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuizzQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }
  extractQuestionsFromQuizzes(dynamic quiz){
    questions.clear();
    correctAnswers.clear();
    selectedAnswers.clear();


    for(var data in quiz){
      var extractedChoices = Get.find<QuizController>().extractChoices(data["choices"]);

      var extractedCorrectIndex = Get.find<QuizController>().extractCorrectIndex(extractedChoices, data["correct_answer"]);

      var extractedUserAnswerIndex = Get.find<QuizController>().extractCorrectIndex(extractedChoices, data["user_answer"]);

      //print("data is is is : $data");
      questions.add(
          Question(
            questionId: data['id_quiz'],
            title: data["course_name"],
            text: data["question"],
            userAnswerIndex: extractedUserAnswerIndex,
            options: extractedChoices,
            correctIndex: extractedCorrectIndex,));
      //print('lrrrrrrrrrrrrrrrrrrrrrrrrrrrrr is ${extractedCorrectIndex}');
      if(extractedCorrectIndex == 0){
        correctAnswers.add(extractedChoices[0]);
      } if(extractedCorrectIndex == 1){
        correctAnswers.add(extractedChoices[1]);
      } if(extractedCorrectIndex == 2){
        correctAnswers.add(extractedChoices[2]);
      } if(extractedCorrectIndex == 3){
        correctAnswers.add(extractedChoices[3]);
      }

      if(extractedUserAnswerIndex == 0){
        selectedAnswers.add(extractedChoices[0]);
      } if(extractedUserAnswerIndex == 1){
        selectedAnswers.add(extractedChoices[1]);
      } if(extractedUserAnswerIndex == 2){
        selectedAnswers.add(extractedChoices[2]);
      } if(extractedUserAnswerIndex == 3){
        selectedAnswers.add(extractedChoices[3]);
      }

    }
    //print('lrrrrrrrrrrrrrrrrrrrrrrrrrrrrr is ${correctAnswers.toString()}');
    //print('Selected answer is  is ${selectedAnswers.toString()}');
  }

  searchBasedOnName(String name){
    print("Lenght is is is: ${filesList[0].title.toString().toLowerCase()}");
    filesList.value =  filesList.where((fileCard) => fileCard.title.toString().toLowerCase().contains(name.toLowerCase()),).toList();
    courseList.value = courseList.where((fileCard) => fileCard.title.toString().toLowerCase().contains(name.toLowerCase()),).toList();
    revisionList.value = revisionList.where((fileCard) => fileCard.title.toString().toLowerCase().contains(name.toLowerCase()),).toList();
    quizList.value  = quizList.where((fileCard) => fileCard.title.toString().toLowerCase().contains(name.toLowerCase()),).toList();

    if(name.isEmpty){
      filesList.value = safeFilesList;
      courseList.value = safeCourseList;
      quizList.value = safeQuizList;
      revisionList.value = safeRevisionList;
    }
  }

}


