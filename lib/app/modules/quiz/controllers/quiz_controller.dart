import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/file_card_model.dart';
import 'package:studyai/app/models/question_model.dart';
import 'package:studyai/app/repositories/quizz_repository.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';

enum QuizGenerationState { start, ongoing, failed, generated }


class QuizController extends GetxController {
  final Rx<UserModel> currentUser = Get.find<AuthService>().user;
  final RxDouble progress = 0.0.obs;
  Timer? _generationTimer;
  Timer? _questionTimer;
  final Duration generationDuration = const Duration(seconds: 1);
   Rx<QuizGenerationState> generationState = QuizGenerationState.start.obs;

  // Quiz configuration
  final RxInt numberOfQuestions = 1.obs;
  final RxList<String> difficultyLevels = ['Basique', 'Intermédiaire', 'Avancé'].obs;
  final RxList<String> questionTypes = ['QCM', 'Vrai/Faux', 'Texte'].obs;
  final RxInt difficultyIndex = 0.obs;
  final RxInt questionTypeIndex = 0.obs;
  var userAnswer = '';

  TextEditingController instructionText = TextEditingController();

  TextEditingController quizzResultRating = TextEditingController();
  TextEditingController quizzResultComment = TextEditingController();

  // Question management
  final RxList<Question> questions = <Question>[].obs;


  final RxInt currentQuestionIndex = 0.obs;
  final RxList<int?> selectedAnswers = <int?>[].obs;
  var selectedAnswer = 100.obs;
  Rx<FileCardModel> selectedCourse = FileCardModel(title: '', timeInfo: '', type: '', createdAt: '').obs;

  // Question timer
  final RxDouble questionProgress = 0.0.obs;
  final Duration questionDuration = const Duration(seconds: 20);
  final int updatesPerSecond = 60;

  late QuizzRepository quizzRepository;

  late Question question;

  var quizzResultLoading = false.obs;

  var gotQuizzResultSuccessfully = false.obs;

  var viewResponses = false.obs;

 // var extractedChoices = [];
  var extractedCorrectIndex;

  var extractedChoices;

  var quizzData;

  //get extractedChoices => null;
  var extractedUserAnswerIndex;

  @override
  void onClose() {
    _generationTimer?.cancel();
    _questionTimer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    quizzRepository = QuizzRepository();
    instructionText.text = '';
    quizzResultRating.text = '';
    quizzResultComment.text = '';

    super.onInit();
  }

  @override
  void dispose() {
    instructionText.dispose();
    quizzResultComment.dispose();
    quizzResultRating.dispose();
    super.dispose();
  }

  Future<void> startGenerationProgress(
      {required int idCourse,
      required String quizzType,
      required String levelOfDifficulty,
      required int questionsNumber,
      required String instruction}) async {
    try {
      generationState.value = QuizGenerationState.start; // Initial state

      // --- Step 1: Perform API calls ---

      var courseId = await createQuizz(
          courseId: idCourse,
          quizzType: quizzType,
          levelOfDifficulty: levelOfDifficulty,
          questionsNumber: questionsNumber,
          instruction: instruction);

      if(courseId != null){

        print('Quizz course id is: $courseId');

        quizzData = await getCourseQuizzes(courseId: courseId);

        for(var quizz in quizzData){
          print("Kkkop: quizz: ${quizz.toString()}");
           extractedChoices = extractChoices(quizz["choices"]);

          print('Extaracted choices are: ${extractedChoices.toString()}');

          extractedCorrectIndex = extractCorrectIndex(extractedChoices, quizz["correct_answer"]);

          print('Extaracted correct index: ${extractedCorrectIndex.toString()}');

          question = Question(
            courseId: courseId,
            questionId: quizz['id_quiz'],
            title: quizz["course_name"],
            text: quizz["question"],
            options: extractedChoices,
            correctIndex: extractedCorrectIndex,);
          questions.add(question);

        }

        const int updatesPerSecond = 60; // Smooth updates per second
        final int totalUpdates = generationDuration.inSeconds * updatesPerSecond;
        final double increment = 2.0 / totalUpdates;

        int updateCount = 0;

        _generationTimer = Timer.periodic(
          Duration(milliseconds: 1000 ~/ updatesPerSecond),
              (timer) {

            progress.value += increment;

            updateCount++;


            generationState.value = QuizGenerationState.ongoing;

            if (updateCount >= totalUpdates) {
              _generationTimer?.cancel();
              generationState.value = QuizGenerationState.generated;
              startQuestionTimer();
              Navigator.of(Get.context!).pop();

            }
          },
        );

      }

    } catch (e) {
      // --- Step 4: Handle error during API call ---
      generationState.value = QuizGenerationState.failed;

      _generationTimer?.cancel();

      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }

  }



  List<String> extractChoices(Map<String, dynamic> responseData) {
    if (responseData != null) {
      return responseData.entries.expand((entry) {
        final key = entry.key;
        final value = entry.value;

        if (value is List) {
          return value.map((v) => '$key: $v');
        } else {
          return <String>['$key: $value']; // fallback for non-list values
        }
      }).toList();
    }
    return [];
  }

  extractCorrectIndex(dynamic extractedChoices, correctAnswerLetter) {
    if (correctAnswerLetter.toString().toUpperCase() == 'A') {
      return 0;
    }
    if (correctAnswerLetter.toString().toUpperCase() == 'B') {
      return 1;
    }
    if (correctAnswerLetter.toString().toUpperCase() == 'C') {
      return 2;
    }
    if (correctAnswerLetter.toString().toUpperCase() == 'D') {
      return 3;
    }

  }

  extractUserAnswer(int index) {
    if (index == 0) {
      userAnswer = "A";
    }
    if (index == 1) {
      userAnswer = "B";
    }
    if (index == 2) {
      userAnswer = "C";
    }
    if (index == 3) {
      userAnswer = "D";
    }

  }

  getLevelOfDifficulty(int difficultyIndex){
    if(difficultyIndex == 0){
      return "easy";
    }else if(difficultyIndex == 1){
      return "medium";
    }else if(difficultyIndex == 2){
      return "hard";
    }

  }

  getQuizzType(int quizzTypeIndex){
    if(quizzTypeIndex == 0){
      return "mcq";
    }else if(quizzTypeIndex == 1){
      return "true_or_false";
    }else if(quizzTypeIndex == 2){
      return "text";
    }
  }

  void startQuestionTimer() {
    questionProgress.value = 0.0;
    final int totalUpdates = questionDuration.inSeconds * updatesPerSecond;
    final double increment = 1.0 / totalUpdates;
    int updateCount = 0;

    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(
      Duration(milliseconds: 1000 ~/ updatesPerSecond),
          (timer) {
        questionProgress.value += increment;
        updateCount++;

        if (updateCount >= totalUpdates) {
          timer.cancel();
          handleTimerExpiration();
        }
      },
    );
  }

  void handleTimerExpiration() {
    if (currentQuestionIndex.value < questions.length - 1) {
      nextQuestion();
    } else {
      submitQuiz();
    }
  }

  void nextQuestion() {
    selectedAnswer.value = 100;
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      startQuestionTimer();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      startQuestionTimer();
    }
  }

  Future<void> selectAnswer(int answerIndex, int quizzId, String userAnswer) async {
    selectedAnswers.add(answerIndex);
    selectedAnswer.value = answerIndex;
    await updateUserAnswer(quizzId: quizzId, userAnswer: userAnswer );
  }

  void initializeNewQuiz(List<Question> newQuestions) {
    questions.value = newQuestions;
    selectedAnswers.value = List.filled(newQuestions.length, null);
    currentQuestionIndex.value = 0;
    generationState.value = QuizGenerationState.generated;
    startQuestionTimer();
  }

   submitQuiz({int? courseId}) async {
    _questionTimer?.cancel();
    if (!(currentQuestionIndex.value < questions.length - 1)) {
      gotQuizzResultSuccessfully.value = await requestQuizzResult(courseId: courseId!);
    }


  }

  Future createQuizz({required int courseId, required String quizzType, required String levelOfDifficulty, required int questionsNumber, required String instruction}) async {

    try{

      var result = await quizzRepository.createQuizz(courseId: courseId, quizzType: quizzType, levelOfDifficulty: levelOfDifficulty, questionsNumber: questionsNumber, instruction: instruction);
      return result;


    } catch(e){
      rethrow;

    }
    finally {
      //loading.value = false;
    }

  }

  Future getCourseQuizzes({required int courseId}) async {

    try{

      var result = await quizzRepository.getCourseQuizzes(courseId: courseId);
      return result;


    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future updateUserAnswer({required int quizzId, required String userAnswer}) async {

    try{

      var result = await quizzRepository.updateUserAnswer(quizzId: quizzId, userAnswer: userAnswer);
      //await Get.showSnackbar(Ui.SuccessSnackBar(message: "Reponse enregistree avec succes"));
      return result;

    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future requestQuizzResult({required int courseId,}) async {

    try{
      quizzResultLoading.value = true;


      var result = await quizzRepository.requestQuizzResult(courseId: courseId);

      print("result is $result");
      if(result != null){
        quizzResultComment.text = result['comment'];
        quizzResultRating.text = "${result['rating']} %";
        quizzResultLoading.value = false;
        return true;
      }
      return false;


    } catch(e){
      quizzResultLoading.value = false;
      await Get.showSnackbar(Ui.ErrorSnackBar(message: "Echec d' enregisstrement de la reponse\n Svp reselectionnez votre reponse"));
      return false;

    }
    finally {
      quizzResultLoading.value = false;
    }

  }





}