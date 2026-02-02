import 'package:flutter/material.dart';
import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';
import 'package:flutter_application_9/feature/test/data/models/major_score_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_model.dart';
import 'package:flutter_application_9/feature/test/data/repositories/test_repository.dart';

enum TestPhase { idle, core, probe, focused, validation, done }

class TestsController extends ChangeNotifier {
  final TestRepository _repo = TestRepository.instance;

  int? _attemptId;
  List<MajorScoreModel> topMajors = const [];
  bool isResultsLoading = false;
  String? resultsError;
  int? get attemptId => _attemptId;

  bool isLoading = false;
  String? error;

  TestPhase phase = TestPhase.idle;

  QuestionModel? question;
  List<LikertPointModel> likretPoints = const [];
  List<QuestionChoiceModel> choices = const [];

  int? selectedChoiceId;
  int? selctedLikretValue;

  bool get hasQuestion => question != null;

  List<QuestionModel> _core = const [];
  int _coreIndex = 0;

  final List<QuestionModel> _queue = <QuestionModel>[];
  final Map<int, double> traitScores = <int, double>{};

  String? _trackCode; // يحدد المسار اذاهو عملي ولا ادبي
  int? _trackGroupId;

  static const _scienceTraits = <int>[1, 2, 3, 4, 9];
  static const _literaryTraits = <int>[5, 6, 7, 8];
  static const double kTop3AbsMargin = 2.0;

  final Set<int> _seenQuestionIds = <int>{};

  //  تبدأ جلي اسئله الاختبار
  Future<void> start() async {
    if (isLoading || question != null) return;

    isLoading = true;
    error = null;
    phase = TestPhase.core;
    _seenQuestionIds.clear();
    notifyListeners();

    try {
      final test = await _repo.getActiveTest();
      const localStudentId = 1;
      _attemptId = await _repo.createAttempt(
        testId: test.id,
        studentId: localStudentId,
      );

      _core = await _repo.getCoreQuestions();
      _coreIndex = 0;

      traitScores.clear();
      _queue.clear();

      await _setQuestion(_core[_coreIndex]);
    } catch (e) {
      error = e.toString();
      phase = TestPhase.idle;
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

    _seenQuestionIds.add(q.id);

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
      // ✅ 0) احفظ الإجابة في DB (Likert أو Choice)
      await _saveCurrentAnswer(q);

      // ✅ 1) score current answer (likert only)
      if (q.isLikert) {
        await _scoreLikertAnswer(q, selctedLikretValue!);
      }

      // ✅ 2) handle gate question specifically (بعد الحفظ)
      if (q.code == 'CORE_GATE') {
        await _handleGate();
        return;
      }

      // ✅ 3) move forward depending on phase
      if (phase == TestPhase.core) {
        _coreIndex++;
        if (_coreIndex >= _core.length) {
          error = 'انتهت أسئلة CORE بدون Gate؟ تحقق من البيانات.';
          phase = TestPhase.done;
          question = null;

          return;
        }
        await _setQuestion(_core[_coreIndex]);
        return;
      }

      if (_queue.isNotEmpty) {
        final nextQ = _queue.removeAt(0);
        await _setQuestion(nextQ);
        return;
      }

      if (phase == TestPhase.probe) {
        await _buildFocusedQueue();
        if (_queue.isEmpty) {
          error = 'لم يتم توليد أسئلة Focused.';
          phase = TestPhase.done;
          question = null;

          return;
        }
        phase = TestPhase.focused;
        await _setQuestion(_queue.removeAt(0));
        return;
      }

      if (phase == TestPhase.focused) {
        await _buildValidationQueue();
        if (_queue.isEmpty) {
          error = 'لم يتم توليد أسئلة Validation.';
          phase = TestPhase.done;
          question = null;

          // if (_attemptId != null) await _repo.completeAttempt(_attemptId!);
          return;
        }
        phase = TestPhase.validation;
        await _setQuestion(_queue.removeAt(0));
        return;
      }

      if (phase == TestPhase.validation) {
        phase = TestPhase.done;
        question = null;

        if (_attemptId != null) {
          await _finalizeResults();
        }

        await loadResults();
        return;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _scoreLikertAnswer(QuestionModel q, int rawValue) async {
    final weights = await _repo.getTraitWeightsForQuestion(q.id);

    final v = q.isReverse ? (6 - rawValue) : rawValue;

    for (final w in weights) {
      traitScores[w.traitId] = (traitScores[w.traitId] ?? 0) + (v * w.weight);
    }
  }

  Future<void> _handleGate() async {
    final chosen = choices.firstWhere((c) => c.id == selectedChoiceId);

    _trackCode = (chosen.code == 'SCI') ? 'SCIENCE' : 'LITERARY';
    _trackGroupId = await _repo.getGroupIdByCode(_trackCode!);

    phase = TestPhase.probe;
    _queue.clear();

    final traitIds = (_trackCode == 'SCIENCE')
        ? _scienceTraits
        : _literaryTraits;

    final buckets = <List<QuestionModel>>[];
    for (final traitId in traitIds) {
      final qs = await _repo.getTraitQuestions(
        groupId: _trackGroupId!,
        traitId: traitId,
        limit: 2,
        offset: 0,
      );
      buckets.add(qs);
    }

    _queue.addAll(_interleave(buckets));

    if (_queue.isEmpty) {
      error = 'لم يتم العثور على أسئلة Probe للمسار $_trackCode';
      phase = TestPhase.done;
      question = null;
      return;
    }

    await _setQuestion(_queue.removeAt(0));
  }

  Future<void> _buildFocusedQueue() async {
    _queue.clear();

    final traitIds = (_trackCode == 'SCIENCE')
        ? _scienceTraits
        : _literaryTraits;

    final scored =
        traitIds.map((id) => MapEntry(id, traitScores[id] ?? 0)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    if (scored.isEmpty) return;

    final chosen = <int>[];
    if (scored.length < 3) {
      chosen.addAll(scored.take(2).map((e) => e.key));
    } else {
      final diff = scored[1].value - scored[2].value;
      chosen.addAll(
        (diff <= kTop3AbsMargin)
            ? scored.take(3).map((e) => e.key)
            : scored.take(2).map((e) => e.key),
      );
    }

    final buckets = <List<QuestionModel>>[];

    for (final traitId in chosen) {
      final total = await _repo.countTraitQuestions(
        groupId: _trackGroupId!,
        traitId: traitId,
      );

      final remaining = (total - 2).clamp(0, 6);

      final qs = await _repo.getTraitQuestions(
        groupId: _trackGroupId!,
        traitId: traitId,
        limit: remaining,
        offset: 2,
      );

      buckets.add(qs);
    }

    _queue.addAll(_interleave(buckets));
  }

  Future<void> _buildValidationQueue() async {
    _queue
      ..clear()
      ..addAll(await _repo.getValidationQuestions(limit: 2));
  }

  Future<void> _saveCurrentAnswer(QuestionModel q) async {
    final attemptId = _attemptId;
    if (attemptId == null) {
      throw StateError(
        'Attempt is not initialized. Call start() and create attempt first.',
      );
    }

    if (q.isLikert) {
      final v = selctedLikretValue;
      if (v == null) {
        throw StateError('Likert value is null for a likert question.');
      }
      await _repo.saveLikertAnswer(
        attemptId: attemptId,
        questionId: q.id,
        likertValue: v,
      );
      return;
    }

    if (q.isSingleChoice) {
      final cid = selectedChoiceId;
      if (cid == null) {
        throw StateError('Choice id is null for a single_choice question.');
      }
      await _repo.saveChoiceAnswer(
        attemptId: attemptId,
        questionId: q.id,
        choiceId: cid,
      );
      return;
    }

    throw UnsupportedError('Unsupported question type: ${q.type}');
  }

  Future<void> retry() async {
    question = null;
    likretPoints = const [];
    choices = const [];
    selctedLikretValue = null;
    selectedChoiceId = null;
    error = null;
    phase = TestPhase.idle;
    _seenQuestionIds.clear();
    _attemptId = null;
    _seenQuestionIds.clear();
    traitScores.clear();
    _queue.clear();
    _core = const [];
    _coreIndex = 0;
    topMajors = const [];
    resultsError = null;
    isResultsLoading = false;
    notifyListeners();
    await start();
  }

  List<QuestionModel> _interleave(List<List<QuestionModel>> buckets) {
    final result = <QuestionModel>[];
    final maxLen = buckets.fold<int>(0, (m, b) => b.length > m ? b.length : m);

    for (var i = 0; i < maxLen; i++) {
      for (final b in buckets) {
        if (i < b.length) {
          final q = b[i];
          if (_seenQuestionIds.add(q.id)) {
            result.add(q);
          }
        }
      }
    }
    return result;
  }

  Future<void> _finalizeResults() async {
    final attemptId = _attemptId;
    if (attemptId == null) return;

    // 1) حفظ traitScores
    await _repo.saveAttemptTraitScores(
      attemptId: attemptId,
      traitScores: traitScores,
    );

    // 2) حساب majors من SQL
    final majorRows = await _repo.computeMajorScores(attemptId);

    // 3) حفظها مع rank
    await _repo.saveAttemptMajorScores(
      attemptId: attemptId,
      majorRows: majorRows,
    );

    // 4) جلب Top 5 للعرض
    topMajors = await _repo.getAttemptMajorScores(attemptId, limit: 5);

    // 5) إنهاء attempt
    await _repo.completeAttempt(attemptId);
  }

  Future<void> loadResults({int? attemptId}) async {
    final id = attemptId ?? _attemptId;
    if (id == null) {
      resultsError = 'لا يوجد attemptId لعرض النتائج.';
      topMajors = const [];
      notifyListeners();
      return;
    }

    isResultsLoading = true;
    resultsError = null;
    notifyListeners();

    try {
      topMajors = await _repo.getAttemptMajorScores(id, limit: 5);
    } catch (e) {
      resultsError = e.toString();
      topMajors = const [];
    } finally {
      isResultsLoading = false;
      notifyListeners();
    }
  }

  Future<int?> loadLastCompletedAttemptId() async {
    final test = await _repo.getActiveTest();
    const localStudentId = 1; // مؤقتًا إلى أن نضيف login
    return _repo.getLastCompletedAttemptId(
      testId: test.id,
      studentId: localStudentId,
    );
  }
}
