PRAGMA foreign_keys = ON;

-- =========================
-- 0) Drop (اختياري للتجربة فقط)
-- =========================
DROP TABLE IF EXISTS attempt_major_scores;
DROP TABLE IF EXISTS attempt_trait_scores;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS attempts;
DROP TABLE IF EXISTS students;

DROP TABLE IF EXISTS major_trait_weights;
DROP TABLE IF EXISTS majors;
DROP TABLE IF EXISTS question_trait_weights;
DROP TABLE IF EXISTS traits;

DROP TABLE IF EXISTS routing_rules;
DROP TABLE IF EXISTS question_choices;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS likert_scale_points;
DROP TABLE IF EXISTS likert_scales;
DROP TABLE IF EXISTS question_groups;
DROP TABLE IF EXISTS tests;

-- =========================
-- 1) Core reference tables
-- =========================

CREATE TABLE tests (
  test_id     INTEGER PRIMARY KEY,
  code        TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  version     TEXT NOT NULL,
  is_active   INTEGER NOT NULL DEFAULT 1,
  created_at  TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE question_groups (
  group_id      INTEGER PRIMARY KEY,
  test_id       INTEGER NOT NULL,
  code          TEXT NOT NULL UNIQUE,
  name          TEXT NOT NULL,
  description   TEXT,
  display_order INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE
);

CREATE TABLE likert_scales (
  scale_id   INTEGER PRIMARY KEY,
  code       TEXT NOT NULL UNIQUE,
  name       TEXT NOT NULL,
  min_value  INTEGER NOT NULL,
  max_value  INTEGER NOT NULL,
  CHECK (min_value < max_value)
);

CREATE TABLE likert_scale_points (
  point_id INTEGER PRIMARY KEY,
  scale_id INTEGER NOT NULL,
  value    INTEGER NOT NULL,
  label    TEXT NOT NULL,
  FOREIGN KEY (scale_id) REFERENCES likert_scales(scale_id) ON DELETE CASCADE,
  UNIQUE (scale_id, value)
);

CREATE TABLE questions (
  question_id    INTEGER PRIMARY KEY,
  group_id       INTEGER NOT NULL,
  code           TEXT NOT NULL UNIQUE,
  question_text  TEXT NOT NULL,
  question_type  TEXT NOT NULL,  -- 'single_choice' | 'likert'
  scale_id       INTEGER,        -- for likert only
  display_order  INTEGER NOT NULL DEFAULT 1,
  is_required    INTEGER NOT NULL DEFAULT 1,
  is_reverse     INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (group_id) REFERENCES question_groups(group_id) ON DELETE CASCADE,
  FOREIGN KEY (scale_id) REFERENCES likert_scales(scale_id) ON DELETE SET NULL,
  CHECK (question_type IN ('single_choice','likert'))
);

CREATE TABLE question_choices (
  choice_id     INTEGER PRIMARY KEY,
  question_id   INTEGER NOT NULL,
  code          TEXT NOT NULL,
  choice_text   TEXT NOT NULL,
  choice_value  INTEGER,
  display_order INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
  UNIQUE (question_id, code)
);

CREATE TABLE routing_rules (
  rule_id          INTEGER PRIMARY KEY,
  from_question_id INTEGER NOT NULL,
  from_choice_id   INTEGER,   -- for single_choice routing
  min_value        INTEGER,   -- for likert routing (optional)
  max_value        INTEGER,
  to_group_id      INTEGER,
  to_question_id   INTEGER,
  priority         INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (from_question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
  FOREIGN KEY (from_choice_id) REFERENCES question_choices(choice_id) ON DELETE CASCADE,
  FOREIGN KEY (to_group_id) REFERENCES question_groups(group_id) ON DELETE SET NULL,
  FOREIGN KEY (to_question_id) REFERENCES questions(question_id) ON DELETE SET NULL
);

-- =========================
-- 2) Traits + Majors
-- =========================

CREATE TABLE traits (
  trait_id INTEGER PRIMARY KEY,
  code     TEXT NOT NULL UNIQUE,
  name     TEXT NOT NULL
);

CREATE TABLE question_trait_weights (
  question_id INTEGER NOT NULL,
  trait_id    INTEGER NOT NULL,
  weight      REAL NOT NULL,
  PRIMARY KEY (question_id, trait_id),
  FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
  FOREIGN KEY (trait_id) REFERENCES traits(trait_id) ON DELETE CASCADE
);

CREATE TABLE majors (
  major_id INTEGER PRIMARY KEY,
  code     TEXT NOT NULL UNIQUE,
  name     TEXT NOT NULL,
  college  TEXT
);

CREATE TABLE major_trait_weights (
  major_id INTEGER NOT NULL,
  trait_id INTEGER NOT NULL,
  weight   REAL NOT NULL,
  PRIMARY KEY (major_id, trait_id),
  FOREIGN KEY (major_id) REFERENCES majors(major_id) ON DELETE CASCADE,
  FOREIGN KEY (trait_id) REFERENCES traits(trait_id) ON DELETE CASCADE
);

-- =========================
-- 3) Runtime tables
-- =========================

CREATE TABLE students (
  student_id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name  TEXT,
  gender     TEXT,
  school     TEXT,
  created_at TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE attempts (
  attempt_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  test_id      INTEGER NOT NULL,
  student_id   INTEGER,
  status       TEXT NOT NULL DEFAULT 'in_progress', -- in_progress|completed
  started_at   TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  completed_at TEXT,
  FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE SET NULL,
  CHECK (status IN ('in_progress','completed'))
);

CREATE TABLE answers (
  answer_id    INTEGER PRIMARY KEY AUTOINCREMENT,
  attempt_id   INTEGER NOT NULL,
  question_id  INTEGER NOT NULL,
  choice_id    INTEGER,
  likert_value INTEGER,
  answered_at  TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (attempt_id) REFERENCES attempts(attempt_id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
  FOREIGN KEY (choice_id) REFERENCES question_choices(choice_id) ON DELETE SET NULL,
  UNIQUE (attempt_id, question_id),
  CHECK (
    (choice_id IS NOT NULL AND likert_value IS NULL)
    OR
    (choice_id IS NULL AND likert_value IS NOT NULL)
  )
);

CREATE TABLE attempt_trait_scores (
  attempt_id INTEGER NOT NULL,
  trait_id   INTEGER NOT NULL,
  score      REAL NOT NULL,
  PRIMARY KEY (attempt_id, trait_id),
  FOREIGN KEY (attempt_id) REFERENCES attempts(attempt_id) ON DELETE CASCADE,
  FOREIGN KEY (trait_id) REFERENCES traits(trait_id) ON DELETE CASCADE
);

CREATE TABLE attempt_major_scores (
  attempt_id INTEGER NOT NULL,
  major_id   INTEGER NOT NULL,
  score      REAL NOT NULL,
  rank_no    INTEGER NOT NULL,
  PRIMARY KEY (attempt_id, major_id),
  FOREIGN KEY (attempt_id) REFERENCES attempts(attempt_id) ON DELETE CASCADE,
  FOREIGN KEY (major_id) REFERENCES majors(major_id) ON DELETE CASCADE
);

CREATE INDEX ix_questions_group_order ON questions(group_id, display_order);
CREATE INDEX ix_choices_question_order ON question_choices(question_id, display_order);
CREATE INDEX ix_rules_from_question ON routing_rules(from_question_id, priority);
CREATE INDEX ix_qtw_trait ON question_trait_weights(trait_id);
CREATE INDEX ix_mtw_trait ON major_trait_weights(trait_id);

-- =========================
-- 4) Seed data
-- =========================

-- Likert
INSERT INTO likert_scales (scale_id, code, name, min_value, max_value)
VALUES (1, 'LIKERT_5_AR', 'مقياس ليكرت 5 درجات', 1, 5);
INSERT INTO likert_scale_points (point_id, scale_id, value, label) VALUES
(1, 1, 1, 'لا أوافق بشدة'),
(2, 1, 2, 'لا أوافق'),
(3, 1, 3, 'محايد'),
(4, 1, 4, 'أوافق'),
(5, 1, 5, 'أوافق بشدة');

-- Test + groups
INSERT INTO tests (test_id, code, name, version, is_active)
VALUES (1, 'YEMEN_INTEREST_TEST', 'اختبار تحديد الميول لخريجي الثانوية (اليمن)', '1.0', 1);

INSERT INTO question_groups (group_id, test_id, code, name, description, display_order) VALUES
(1, 1, 'CORE',      'الأسئلة المشتركة (Core)', 'أسئلة عامة للجميع لتكوين صورة أولية عن الميول.', 1),
(2, 1, 'SCIENCE',   'مسار علمي (Science Track)', 'أسئلة أعمق في العلوم/الهندسة/التقنية/الصحة/الزراعة.', 2),
(3, 1, 'LITERARY',  'مسار أدبي (Literary Track)', 'أسئلة أعمق في التجارة/القانون والشريعة/اللغات/الإعلام والفنون.', 3),
(4, 1, 'VALIDATE',  'أسئلة التحقق (Validation)', 'لتحسين جودة القياس وكشف الإجابات العشوائية.', 4);

-- Traits
INSERT INTO traits (trait_id, code, name) VALUES
(1, 'STEM',        'ميول علمية وتحليلية (علوم/رياضيات)'),
(2, 'ENGINEERING', 'ميول هندسية/بناء/حلول عملية'),
(3, 'TECH',        'ميول تقنية وحاسوبية'),
(4, 'HEALTH',      'ميول صحية وطبية'),
(5, 'BUSINESS',    'ميول تجارة/إدارة/اقتصاد'),
(6, 'LAW_SHARIA',  'ميول شريعة وقانون'),
(7, 'LANG_EDU',    'ميول لغات/تعليم/ترجمة'),
(8, 'ARTS_MEDIA',  'ميول إعلام/فنون/تصميم'),
(9, 'AGRI_ENV',    'ميول زراعة/بيئة/موارد'),
(99,'QUALITY',     'مؤشر جودة/اتساق الإجابات');

-- CORE (12 Likert + Gate)
INSERT INTO questions
(question_id, group_id, code, question_text, question_type, scale_id, display_order, is_required, is_reverse)
VALUES
(1001, 1, 'CORE_01', 'أستمتع بحل المشكلات خطوة بخطوة حتى لو استغرق الأمر وقتًا.', 'likert', 1, 1, 1, 0),
(1002, 1, 'CORE_02', 'أفضّل الأعمال التي تتطلب دقة وانتباه للتفاصيل أكثر من الأعمال السريعة.', 'likert', 1, 2, 1, 0),
(1003, 1, 'CORE_03', 'أشعر بالحماس عندما أتعلم شيئًا جديدًا وأطبّقه عمليًا.', 'likert', 1, 3, 1, 0),
(1004, 1, 'CORE_04', 'أفضل العمل مع الناس ومساعدتهم على العمل الفردي الطويل.', 'likert', 1, 4, 1, 0),
(1005, 1, 'CORE_05', 'أحب القراءة/الكتابة والشرح أكثر من الحسابات والأرقام.', 'likert', 1, 5, 1, 0),
(1006, 1, 'CORE_06', 'أحب الأرقام والرياضيات والمنطق حتى خارج المنهج.', 'likert', 1, 6, 1, 0),
(1007, 1, 'CORE_07', 'يلفتني فهم جسم الإنسان/الأمراض/العلاج ومعلومات الصحة.', 'likert', 1, 7, 1, 0),
(1008, 1, 'CORE_08', 'أستمتع بتجربة الأجهزة/التقنية/التطبيقات ومعرفة كيف تعمل.', 'likert', 1, 8, 1, 0),
(1009, 1, 'CORE_09', 'أفضل الأعمال التي يكون فيها “إبداع بصري” (تصميم/ألوان/إخراج).', 'likert', 1, 9, 1, 0),
(1010, 1, 'CORE_10', 'يهمني تنظيم المال والوقت واتخاذ قرارات عملية (شراء/بيع/ميزانية).', 'likert', 1, 10, 1, 0),
(1011, 1, 'CORE_11', 'يهمني النقاش حول الحقوق والعدالة وحل الخلافات بالقانون/التحكيم.', 'likert', 1, 11, 1, 0),
(1012, 1, 'CORE_12', 'أحب التعليم/الشرح للآخرين وأشعر بالرضا عندما يفهم شخص بسببي.', 'likert', 1, 12, 1, 0),
(1013, 1, 'CORE_GATE', 'بعد الإجابة على الأسئلة العامة، أي مسار تشعر أنه أقرب لميولك الآن؟', 'single_choice', NULL, 13, 1, 0);

INSERT INTO question_choices (choice_id, question_id, code, choice_text, choice_value, display_order) VALUES
(5001, 1013, 'SCI', 'المسار العلمي (علوم/هندسة/تقنية/صحة/زراعة)', 1, 1),
(5002, 1013, 'LIT', 'المسار الأدبي (تجارة/قانون وشريعة/لغات/إعلام وفنون)', 2, 2);

INSERT INTO routing_rules
(rule_id, from_question_id, from_choice_id, min_value, max_value, to_group_id, to_question_id, priority)
VALUES
(9001, 1013, 5001, NULL, NULL, 2, NULL, 1),
(9002, 1013, 5002, NULL, NULL, 3, NULL, 1);

-- SCIENCE track (30)
INSERT INTO questions
(question_id, group_id, code, question_text, question_type, scale_id, display_order, is_required, is_reverse)
VALUES
(2001, 2, 'STEM_01', 'أستمتع بمسائل الفيزياء التي تشرح الظواهر (حركة/طاقة/كهرباء) أكثر من حفظ المعلومات فقط.', 'likert', 1, 1, 1, 0),
(2002, 2, 'STEM_02', 'أرتاح للتجارب العلمية وفهم “لماذا” تحدث النتائج.', 'likert', 1, 2, 1, 0),
(2003, 2, 'STEM_03', 'أحب الكيمياء عندما أفهم التفاعلات لا عندما أحفظ المعادلات فقط.', 'likert', 1, 3, 1, 0),
(2004, 2, 'STEM_04', 'أستمتع بتحليل البيانات/الجداول والبحث عن علاقات ونمط.', 'likert', 1, 4, 1, 0),
(2005, 2, 'STEM_05', 'أفضل التفسير العلمي المنطقي على التفسير السريع غير المدعوم بأدلة.', 'likert', 1, 5, 1, 0),
(2006, 2, 'STEM_06', 'أستمتع بحل مسائل رياضيات طويلة تتطلب تركيزًا وتسلسلًا.', 'likert', 1, 6, 1, 0),

(2007, 2, 'ENG_01', 'يلفتني تصميم وبناء الأشياء (مبانٍ/جسور/شبكات مياه/طرق).', 'likert', 1, 7, 1, 0),
(2008, 2, 'ENG_02', 'أحب رسم المخططات أو تخيل الشكل النهائي لمشروع قبل تنفيذه.', 'likert', 1, 8, 1, 0),
(2009, 2, 'ENG_03', 'أفضّل العمل الذي ينتج “شيئًا ملموسًا” يمكن استخدامه.', 'likert', 1, 9, 1, 0),
(2010, 2, 'ENG_04', 'أستمتع بإيجاد حل عملي لمشكلة في البيت/الحي (كهرباء/ماء/تركيب/صيانة).', 'likert', 1, 10, 1, 0),
(2011, 2, 'ENG_05', 'أحب التفكير في تحسين الطاقة (مثل حلول الكهرباء/الطاقة الشمسية) بشكل واقعي.', 'likert', 1, 11, 1, 0),
(2012, 2, 'ENG_06', 'لا أمانع العمل الميداني والزيارات للمواقع أكثر من الجلوس الدائم في مكتب.', 'likert', 1, 12, 1, 0),

(2013, 2, 'TECH_01', 'أحب تعلم مهارات الحاسوب حتى لو كانت ذاتيًا (برامج/تطبيقات/تصميم بسيط/كود).', 'likert', 1, 13, 1, 0),
(2014, 2, 'TECH_02', 'أستمتع بحل مشاكل تقنية مثل إعداد جهاز/شبكة/تطبيق أو اكتشاف سبب العطل.', 'likert', 1, 14, 1, 0),
(2015, 2, 'TECH_03', 'فكرة تطوير تطبيق/موقع يساعد الناس (خدمات/تعليم/تجارة) تثير اهتمامي.', 'likert', 1, 15, 1, 0),
(2016, 2, 'TECH_04', 'أحب التفكير بشكل “خوارزمي”: إذا حدث كذا نفعل كذا (خطوات/شروط).', 'likert', 1, 16, 1, 0),
(2017, 2, 'TECH_05', 'أحب حماية الحسابات والخصوصية وأهتم بفكرة الأمن السيبراني.', 'likert', 1, 17, 1, 0),
(2018, 2, 'TECH_06', 'أفضل العمل الذي يعتمد على التفكير والمنطق أكثر من الحفظ النصي.', 'likert', 1, 18, 1, 0),

(2019, 2, 'HLTH_01', 'أشعر أنني قادر على التعامل بهدوء مع مريض/مصاب ومساعدته.', 'likert', 1, 19, 1, 0),
(2020, 2, 'HLTH_02', 'أحب فهم الأحياء/الجسم/الأدوية وتأثيراتها.', 'likert', 1, 20, 1, 0),
(2021, 2, 'HLTH_03', 'لا أمانع رؤية الدم/الإجراءات الطبية إذا كان الهدف مساعدة إنسان.', 'likert', 1, 21, 1, 0),
(2022, 2, 'HLTH_04', 'أستمتع بمواد تتطلب حفظًا “مفهومًا” مثل الأعضاء والوظائف وليس حفظًا عشوائيًا.', 'likert', 1, 22, 1, 0),
(2023, 2, 'HLTH_05', 'أحب الأعمال التي تجمع بين العلم وخدمة المجتمع (مراكز صحية/مستشفيات).', 'likert', 1, 23, 1, 0),
(2024, 2, 'HLTH_06', 'أفضّل تخصصًا واضح الأثر على حياة الناس اليومية.', 'likert', 1, 24, 1, 0),

(2025, 2, 'AGRI_01', 'يهمني تحسين الإنتاج الزراعي/الغذائي أو حل مشكلات مثل شح المياه.', 'likert', 1, 25, 1, 0),
(2026, 2, 'AGRI_02', 'أحب فهم البيئة والموارد الطبيعية وكيف نحافظ عليها.', 'likert', 1, 26, 1, 0),
(2027, 2, 'AGRI_03', 'أستمتع بمتابعة موضوعات مثل التربة، النباتات، الآفات، أو الثروة الحيوانية.', 'likert', 1, 27, 1, 0),
(2028, 2, 'AGRI_04', 'لا أمانع العمل الميداني في مزرعة/مختبر/مشروع بيئي.', 'likert', 1, 28, 1, 0),
(2029, 2, 'AGRI_05', 'يلفتني مجال الأغذية (جودة/تصنيع/سلامة) وتأثيره على صحة الناس.', 'likert', 1, 29, 1, 0),
(2030, 2, 'AGRI_06', 'أحب مشاريع تخدم المجتمع محليًا (مياه، بيئة، غذاء) بحلول عملية.', 'likert', 1, 30, 1, 0);

-- LITERARY track (24)
INSERT INTO questions
(question_id, group_id, code, question_text, question_type, scale_id, display_order, is_required, is_reverse)
VALUES
(3001, 3, 'BUS_01', 'أستمتع بحساب الربح والخسارة والتخطيط لمشروع صغير (حتى لو افتراضي).', 'likert', 1, 1, 1, 0),
(3002, 3, 'BUS_02', 'أحب التفاوض والإقناع والوصول لاتفاق يرضي الطرفين.', 'likert', 1, 2, 1, 0),
(3003, 3, 'BUS_03', 'أفضّل العمل الذي فيه تنظيم وقيادة فريق وتوزيع مهام.', 'likert', 1, 3, 1, 0),
(3004, 3, 'BUS_04', 'أحب فهم حركة السوق والأسعار ولماذا ترتفع/تنخفض.', 'likert', 1, 4, 1, 0),
(3005, 3, 'BUS_05', 'أستمتع بتحليل ميزانية والتخطيط للصرف بذكاء.', 'likert', 1, 5, 1, 0),
(3006, 3, 'BUS_06', 'فكرة العمل في محاسبة/إدارة/بنوك/شركات تبدو مناسبة لي.', 'likert', 1, 6, 1, 0),
(3007, 3, 'LAW_01', 'أحب دراسة الأحكام/الأدلة وتنظيم الأفكار للوصول لنتيجة واضحة.', 'likert', 1, 7, 1, 0),
(3008, 3, 'LAW_02', 'يهمني إصلاح ذات البين وحل النزاعات بطريقة عادلة ومنظمة.', 'likert', 1, 8, 1, 0),
(3009, 3, 'LAW_03', 'أستمتع بالقراءة العميقة للنصوص ومناقشة المعاني والاستدلال.', 'likert', 1, 9, 1, 0),
(3010, 3, 'LAW_04', 'أشعر بالاهتمام عندما أتعلم عن الحقوق والواجبات والأنظمة.', 'likert', 1, 10, 1, 0),
(3011, 3, 'LAW_05', 'أفضل مجالات “الحجة والبرهان” والنقاش المنضبط على المجالات العملية الميدانية.', 'likert', 1, 11, 1, 0),
(3012, 3, 'LAW_06', 'أحب العمل الذي يتطلب أمانة عالية وسرية ومسؤولية.', 'likert', 1, 12, 1, 0),

(3013, 3, 'LANG_01', 'أستمتع بتعلم اللغة الإنجليزية/اللغات وأتابع محتوى يساعدني أتطور.', 'likert', 1, 13, 1, 0),
(3014, 3, 'LANG_02', 'أحب شرح الدروس أو تبسيطها لزملائي.', 'likert', 1, 14, 1, 0),
(3015, 3, 'LANG_03', 'أستمتع بالقراءة والكتابة والتعبير وصياغة الأفكار بوضوح.', 'likert', 1, 15, 1, 0),
(3016, 3, 'LANG_04', 'أحب العمل الذي يعتمد على التواصل (تدريس/ترجمة/تدريب).', 'likert', 1, 16, 1, 0),
(3017, 3, 'LANG_05', 'أفضّل مهامًا تتطلب فهمًا للنصوص أكثر من الحسابات المعقدة.', 'likert', 1, 17, 1, 0),
(3018, 3, 'LANG_06', 'أستمتع بالبحث عن معنى كلمة/مصطلح واختيار أدق ترجمة حسب السياق.', 'likert', 1, 18, 1, 0),

(3019, 3, 'ART_01', 'أستمتع بإنتاج محتوى (كتابة/تصوير/مونتاج/تصميم) حتى لو بسيط.', 'likert', 1, 19, 1, 0),
(3020, 3, 'ART_02', 'أهتم بتناسق الألوان والشكل النهائي (بوستر/شعار/عرض).', 'likert', 1, 20, 1, 0),
(3021, 3, 'ART_03', 'أحب إيصال فكرة للناس بطريقة جذابة وسهلة الفهم.', 'likert', 1, 21, 1, 0),
(3022, 3, 'ART_04', 'أفضل الأعمال الإبداعية التي تسمح بأسلوبي الخاص.', 'likert', 1, 22, 1, 0),
(3023, 3, 'ART_05', 'أستمتع بتحليل الإعلانات أو الرسائل الإعلامية وتأثيرها على الناس.', 'likert', 1, 23, 1, 0),
(3024, 3, 'ART_06', 'أشعر بالرضا عندما “أبدع” شيئًا يراه الناس ويعجبهم.', 'likert', 1, 24, 1, 0);

-- VALIDATION (4)
INSERT INTO questions
(question_id, group_id, code, question_text, question_type, scale_id, display_order, is_required, is_reverse)
VALUES
(4001, 4, 'VAL_01', 'أفضّل دائمًا الدراسة بدون أي تعب أو ضغط (حتى في أصعب المواد).', 'likert', 1, 1, 1, 0),
(4002, 4, 'VAL_02', 'أغيّر رأيي بسرعة كبيرة في اختيار التخصص من يوم ليوم.', 'likert', 1, 2, 1, 0),
(4003, 4, 'VAL_03', 'أجيب على الأسئلة بسرعة دون قراءة جيدة.', 'likert', 1, 3, 1, 0),
(4004, 4, 'VAL_04', 'غالبًا أختار الإجابة الوسط (3) حتى لو لدي رأي.', 'likert', 1, 4, 1, 0);

-- Question->Trait weights (Core multi-trait)
INSERT INTO question_trait_weights (question_id, trait_id, weight) VALUES
(1001, 1, 0.350),(1001, 2, 0.250),(1001, 3, 0.250),(1001, 5, 0.150),
(1002, 5, 0.250),(1002, 6, 0.200),(1002, 4, 0.200),(1002, 3, 0.200),(1002, 2, 0.150),
(1003, 3, 0.250),(1003, 2, 0.200),(1003, 1, 0.200),(1003, 5, 0.150),(1003, 8, 0.200),
(1004, 4, 0.300),(1004, 7, 0.200),(1004, 6, 0.150),(1004, 5, 0.150),(1004, 8, 0.200),
(1005, 7, 0.600),(1005, 6, 0.150),(1005, 8, 0.250),
(1006, 1, 0.450),(1006, 3, 0.250),(1006, 2, 0.300),
(1007, 4, 0.800),(1007, 9, 0.200),
(1008, 3, 0.800),(1008, 2, 0.200),
(1009, 8, 0.850),(1009, 7, 0.150),
(1010, 5, 0.850),(1010, 6, 0.150),
(1011, 6, 0.850),(1011, 5, 0.150),
(1012, 7, 0.350),(1012, 4, 0.250),(1012, 8, 0.200),(1012, 6, 0.200);

-- Science questions (1.0)
INSERT INTO question_trait_weights (question_id, trait_id, weight) VALUES
(2001, 1, 1.0),(2002, 1, 1.0),(2003, 1, 1.0),(2004, 1, 1.0),(2005, 1, 1.0),(2006, 1, 1.0),
(2007, 2, 1.0),(2008, 2, 1.0),(2009, 2, 1.0),(2010, 2, 1.0),(2011, 2, 1.0),(2012, 2, 1.0),
(2013, 3, 1.0),(2014, 3, 1.0),(2015, 3, 1.0),(2016, 3, 1.0),(2017, 3, 1.0),(2018, 3, 1.0),
(2019, 4, 1.0),(2020, 4, 1.0),(2021, 4, 1.0),(2022, 4, 1.0),(2023, 4, 1.0),(2024, 4, 1.0),
(2025, 9, 1.0),(2026, 9, 1.0),(2027, 9, 1.0),(2028, 9, 1.0),(2029, 9, 1.0),(2030, 9, 1.0);

-- Literary questions (1.0)
INSERT INTO question_trait_weights (question_id, trait_id, weight) VALUES(3001, 5, 1.0),(3002, 5, 1.0),(3003, 5, 1.0),(3004, 5, 1.0),(3005, 5, 1.0),(3006, 5, 1.0),
(3007, 6, 1.0),(3008, 6, 1.0),(3009, 6, 1.0),(3010, 6, 1.0),(3011, 6, 1.0),(3012, 6, 1.0),
(3013, 7, 1.0),(3014, 7, 1.0),(3015, 7, 1.0),(3016, 7, 1.0),(3017, 7, 1.0),(3018, 7, 1.0),
(3019, 8, 1.0),(3020, 8, 1.0),(3021, 8, 1.0),(3022, 8, 1.0),(3023, 8, 1.0),(3024, 8, 1.0);

-- Validation -> QUALITY
INSERT INTO question_trait_weights (question_id, trait_id, weight) VALUES
(4001, 99, 1.0),(4002, 99, 1.0),(4003, 99, 1.0),(4004, 99, 1.0);

-- Majors
INSERT INTO majors (major_id, code, name, college) VALUES
(1,  'MED',   'طب وجراحة', 'الطب'),
(2,  'DENT',  'طب أسنان', 'طب الأسنان'),
(3,  'PHARM', 'صيدلة', 'الصيدلة'),
(4,  'NURS',  'تمريض', 'العلوم الصحية'),
(5,  'LAB',   'مختبرات طبية', 'العلوم الصحية'),
(6,  'CS',    'علوم حاسوب', 'الحاسوب وتقنية المعلومات'),
(7,  'IT',    'تقنية معلومات', 'الحاسوب وتقنية المعلومات'),
(8,  'IS',    'نظم معلومات', 'الحاسوب وتقنية المعلومات'),
(9,  'SWENG', 'هندسة برمجيات', 'الحاسوب وتقنية المعلومات'),
(10, 'CIVIL', 'هندسة مدنية', 'الهندسة'),
(11, 'ARCH',  'هندسة معمارية', 'الهندسة'),
(12, 'ELEC',  'هندسة كهربائية', 'الهندسة'),
(13, 'MECH',  'هندسة ميكانيكية', 'الهندسة'),
(14, 'ACC',   'محاسبة', 'التجارة والاقتصاد'),
(15, 'BA',    'إدارة أعمال', 'التجارة والاقتصاد'),
(16, 'ECON',  'اقتصاد', 'التجارة والاقتصاد'),
(17, 'LAW',   'قانون', 'القانون'),
(18, 'SHAR',  'شريعة وعلوم إسلامية', 'الشريعة'),
(19, 'ENG',   'لغة إنجليزية', 'الآداب واللغات'),
(20, 'TRANS', 'ترجمة', 'الآداب واللغات'),
(21, 'MEDIA', 'إعلام', 'الإعلام'),
(22, 'GDES',  'تصميم جرافيك', 'الفنون'),
(23, 'AGRI',  'زراعة', 'الزراعة'),
(24, 'ENV',   'علوم بيئية', 'العلوم'),
(25, 'FOOD',  'علوم أغذية', 'الزراعة');

-- Major->Trait weights
INSERT INTO major_trait_weights (major_id, trait_id, weight) VALUES
(1, 4, 1.000),(1, 1, 0.300),
(2, 4, 0.900),(2, 1, 0.300),
(3, 4, 0.850),(3, 1, 0.350),
(4, 4, 0.900),(4, 7, 0.150),
(5, 4, 0.850),(5, 1, 0.300),

(6, 3, 1.000),(6, 1, 0.350),
(7, 3, 0.950),(7, 1, 0.250),
(8, 3, 0.850),(8, 5, 0.200),
(9, 3, 1.000),(9, 2, 0.200),

(10,2, 1.000),(10,1, 0.300),
(11,2, 0.900),(11,8, 0.250),
(12,2, 1.000),(12,1, 0.250),
(13,2, 1.000),(13,1, 0.250),

(14,5, 1.000),(14,1, 0.150),
(15,5, 0.950),(15,7, 0.150),
(16,5, 0.900),(16,1, 0.250),

(17,6, 1.000),(17,7, 0.150),
(18,6, 1.000),(18,7, 0.150),

(19,7, 1.000),
(20,7, 1.000),(20,6, 0.150),

(21,8, 1.000),(21,7, 0.200),
(22,8, 1.000),

(23,9, 1.000),(23,1, 0.200),
(24,9, 0.900),(24,1, 0.250),
(25,9, 0.950),(25,4, 0.200);
