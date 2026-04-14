-- إنشاء جدول استجابات الاستبيان
CREATE TABLE IF NOT EXISTS survey_responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  respondent_name TEXT DEFAULT 'مجهول',
  
  -- الأساتذة وطرق التدريس
  t1_teaching_quality INTEGER CHECK (t1_teaching_quality BETWEEN 1 AND 5),
  t2_teaching_variety INTEGER CHECK (t2_teaching_variety BETWEEN 1 AND 5),
  t3_best_teaching_aspect TEXT,
  
  -- الجو الدراسي
  e1_student_relations INTEGER CHECK (e1_student_relations BETWEEN 1 AND 5),
  e2_study_comfort INTEGER CHECK (e2_study_comfort BETWEEN 1 AND 5),
  e3_environment_improvement TEXT,
  
  -- البنية التحتية
  i1_facilities_quality INTEGER CHECK (i1_facilities_quality BETWEEN 1 AND 5),
  i2_libraries_labs INTEGER CHECK (i2_libraries_labs BETWEEN 1 AND 5),
  i3_needs_improvement TEXT,
  
  -- الأسئلة الممتعة
  f1_fun_choice TEXT,
  f2_movie_role TEXT,
  f3_institution_change TEXT,
  f4_best_memory TEXT,
  
  submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- السماح بالإدراج للجميع (للاستبيان المفتوح)
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_insert" ON survey_responses
  FOR INSERT WITH CHECK (true);

CREATE POLICY "allow_select_own" ON survey_responses
  FOR SELECT USING (true);

-- عرض مساعد لتحليل النتائج
CREATE OR REPLACE VIEW survey_summary AS
SELECT
  COUNT(*) AS total_responses,
  ROUND(AVG(t1_teaching_quality), 2) AS avg_teaching_quality,
  ROUND(AVG(t2_teaching_variety), 2) AS avg_teaching_variety,
  ROUND(AVG(e1_student_relations), 2) AS avg_student_relations,
  ROUND(AVG(e2_study_comfort), 2) AS avg_study_comfort,
  ROUND(AVG(i1_facilities_quality), 2) AS avg_facilities_quality,
  ROUND(AVG(i2_libraries_labs), 2) AS avg_libraries_labs
FROM survey_responses;
