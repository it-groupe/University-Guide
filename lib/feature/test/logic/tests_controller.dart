import 'package:flutter/material.dart';
import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_model.dart';
import 'package:flutter_application_9/feature/test/data/repositories/test_repository.dart';

class TestsController extends ChangeNotifier {
  final TestRepository _repo = TestRepository.instance;

  bool isLoading = false;

  String? error;
  QuestionModel? question;
  List<LikertPointModel> likretPoints = const [];
  int? selctedLikretValue;

  List<QuestionChoiceModel> choices = const [];
  int? selectedChoiceId;

  bool get hasQuestion => question != null;

  //  تبدأ جلي اسئله الاختبار
  Future<void> start() async {
    if (isLoading || question != null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final q = await _repo.getFirstCoreQuestion();
      question = q;
      selctedLikretValue = null;
      likretPoints = const [];

      if (q.isLikert && q.scaleId != null) {
        likretPoints = await _repo.getLikertPoints(q.scaleId!);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _setQuestion(QuestionModel q) async {
    question = q;
    error = null;

    // يفرغ الاجابات الحالية
    selctedLikretValue = null;
    selectedChoiceId = null;

    // يفرغ مصفوفات الاجابه
    likretPoints = const [];
    choices = const [];

    if (q.isLikert && q.scaleId != null) {
      likretPoints = await _repo.getLikertPoints(q.scaleId!);
    } else if (q.isSingleChoice) {
      choices = await _repo.getChoices(q.id);
    }
  }

  void selectChoice(int choiceId) {
    selectedChoiceId = choiceId;
    notifyListeners();
  }

  void selectLikret(int v) {
    selctedLikretValue = v;
    notifyListeners();
  }

  Future<void> next() async {
    final q = question;

    if (q == null) return;
    if (q.isLikert && selctedLikretValue == null) return;
    if (q.isSingleChoice && selectedChoiceId == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      QuestionModel? nextQ;

      if (q.isSingleChoice) {
        nextQ = await _repo.getRoutedNextQuestion(
          fromQuestionId: q.id,
          selectedChoiceId: selectedChoiceId!,
        );
      } else {
        nextQ = await _repo.getNextQuestionInSameGroup(
          groupId: q.groupId,
          currentOrder: q.displayOrder,
        );
      }

      if (nextQ == null) {
        error = 'انتهت الأسئلة المتاحة.';
        return;
      }

      await _setQuestion(nextQ);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    question = null;
    likretPoints = const [];
    choices = const [];
    selctedLikretValue = null;
    selectedChoiceId = null;
    error = null;
    await start();
  }
}
