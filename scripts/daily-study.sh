#!/bin/bash
# 매일 아침 9시 - JavaScript 학습 문제 생성 및 텔레그램 전송
# 월~금: 학습, 토: 주간 평가, 일: 휴식

set -e

# 설정
STUDY_DIR="/Users/macmini/Documents/GitHub/js-study"
SCRIPTS_DIR="$STUDY_DIR/scripts"
PROBLEMS_DIR="$STUDY_DIR/problems"
REPORTS_DIR="$STUDY_DIR/reports"
TELEGRAM_BOT_TOKEN="8738509039:AAGY2sEvuirnO4C0h2rsULLu7TnqgOEgFyw"
TELEGRAM_CHAT_ID="6664560837"
PROGRESS_FILE="$SCRIPTS_DIR/progress.json"
CURRICULUM_FILE="$SCRIPTS_DIR/curriculum.json"
CLAUDE="/Users/macmini/.local/bin/claude"

mkdir -p "$PROBLEMS_DIR" "$REPORTS_DIR"

# 진행 상황 초기화
if [ ! -f "$PROGRESS_FILE" ]; then
  echo '{"current_week": 1, "current_day": 1, "retry_count": 0, "mode": "study"}' > "$PROGRESS_FILE"
fi

# 텔레그램 메시지 전송 함수
send_telegram() {
  local msg="$1"
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${msg}" \
    -d "parse_mode=Markdown" > /dev/null
}

# 현재 진행 상황 읽기
read_progress() {
  CURRENT_WEEK=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['current_week'])")
  CURRENT_DAY=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['current_day'])")
  RETRY_COUNT=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['retry_count'])")
  MODE=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['mode'])")
}

# 진행 상황 저장
save_progress() {
  local week=$1 day=$2 retry=$3 mode=$4
  echo "{\"current_week\": ${week}, \"current_day\": ${day}, \"retry_count\": ${retry}, \"mode\": \"${mode}\"}" > "$PROGRESS_FILE"
}

# 커리큘럼에서 정보 가져오기
get_curriculum_info() {
  local week=$1 day=$2
  python3 -c "
import json
c = json.load(open('$CURRICULUM_FILE'))
weeks = c['weeks']
w = $week - 1
d = $day - 1
if w < len(weeks) and d < len(weeks[w]['days']):
    info = weeks[w]['days'][d]
    cat = weeks[w]['category']
    print(f\"{info['topic']}|{info['type']}|{cat}\")
else:
    print('DONE|done|done')
"
}

# 총 주차 수 가져오기
TOTAL_WEEKS=$(python3 -c "import json; print(len(json.load(open('$CURRICULUM_FILE'))['weeks']))")

read_progress

# 일요일이면 휴식
DOW=$(date +%u)
if [ "$DOW" -eq 7 ]; then
  send_telegram "☀️ *일요일 휴식*

오늘은 쉬는 날입니다. 내일부터 다시 시작해요!
이번 주차: Week ${CURRENT_WEEK}"
  exit 0
fi

# 전체 커리큘럼 완료 체크
if [ "$CURRENT_WEEK" -gt "$TOTAL_WEEKS" ]; then
  send_telegram "🎉 *축하합니다!*

JavaScript 기초 ${TOTAL_WEEKS}주 커리큘럼을 모두 완료했습니다!
리포트를 확인해보세요: \`js-study/reports/\`"
  exit 0
fi

# 오늘의 정보 가져오기
INFO=$(get_curriculum_info $CURRENT_WEEK $CURRENT_DAY)
TOPIC=$(echo "$INFO" | cut -d'|' -f1)
TYPE=$(echo "$INFO" | cut -d'|' -f2)
CATEGORY=$(echo "$INFO" | cut -d'|' -f3)

WEEK_DIR="$PROBLEMS_DIR/week$(printf '%02d' $CURRENT_WEEK)"
mkdir -p "$WEEK_DIR"

# ===== 학습 모드 =====
if [ "$TYPE" = "study" ]; then

  DAY_DIR="$WEEK_DIR/day${CURRENT_DAY}"
  mkdir -p "$DAY_DIR"

  # 반복 모드일 때 약점 정보 가져오기
  WEAK_CONTEXT=""
  if [ "$MODE" = "retry" ]; then
    REPORT_FILE="$REPORTS_DIR/week$(printf '%02d' $CURRENT_WEEK)-report.json"
    if [ -f "$REPORT_FILE" ]; then
      WEAK_TOPICS=$(python3 -c "
import json
r = json.load(open('$REPORT_FILE'))
print(', '.join(r.get('weak_topics', [])))
" 2>/dev/null)
      WEAK_CONTEXT="

⚠️ 중요: 이번은 반복 학습입니다. 학생이 이전 평가에서 약했던 부분: [${WEAK_TOPICS}]
이 약점을 보강하는 데 초점을 맞춰주세요. 해당 개념을 더 자세히 설명하고, 관련 문제를 더 많이 포함해주세요."
    fi
  fi

  PROMPT="당신은 JavaScript 초급 강사입니다. 파일을 생성하지 말고 마크다운 텍스트만 출력하세요.

Week ${CURRENT_WEEK}, Day ${CURRENT_DAY}/5
카테고리: ${CATEGORY}
주제: ${TOPIC}${WEAK_CONTEXT}

아래 형식으로 학습 자료를 작성해주세요:

# Week ${CURRENT_WEEK} Day ${CURRENT_DAY} - ${TOPIC}

## 1. 개념 설명
- 초보자가 이해할 수 있도록 일상생활 비유를 사용해서 자세히 설명
- 핵심 개념마다 ASCII 다이어그램이나 표로 시각화
- 주의할 점, 흔한 실수도 포함
- 최소 500자 이상 상세하게 작성

## 2. 실제 활용 사례
- 이 개념이 실무/실제 프로젝트에서 어떻게 쓰이는지 3가지 사례
- 예: 쇼핑몰, 게임, 채팅앱 등에서의 활용
- 각 사례마다 간단한 코드 포함

## 3. 예제 코드
- 5개의 예제 (기초 2개, 응용 2개, 심화 1개)
- 각 예제에 한줄한줄 상세한 주석 포함
- 실행 결과도 주석으로 표시

## 4. 연습 문제
- 5문제 (쉬움 2개, 보통 2개, 도전 1개)
- 각 문제에 함수 시그니처 제공
- 예상 입출력 포함
- 힌트도 포함

## 5. test.js
- Node.js로 실행 가능한 테스트 코드 블록
- solution.js에서 함수를 require해서 5문제 모두 검증
- 통과/실패 메시지 출력

모든 코드는 JavaScript, 설명은 한국어로 작성해주세요."

  echo "$PROMPT" | $CLAUDE -p --output-format text --max-turns 1 > "$DAY_DIR/README.md" 2>/dev/null

  # solution.js 템플릿
  cat > "$DAY_DIR/solution.js" << SOLEOF
// Week ${CURRENT_WEEK} Day ${CURRENT_DAY} - ${TOPIC}
// 아래에 풀이를 작성하세요!

// 문제 1
function problem1() {
  // 여기에 코드를 작성하세요
}

// 문제 2
function problem2() {
  // 여기에 코드를 작성하세요
}

// 문제 3
function problem3() {
  // 여기에 코드를 작성하세요
}

// 문제 4
function problem4() {
  // 여기에 코드를 작성하세요
}

// 문제 5
function problem5() {
  // 여기에 코드를 작성하세요
}

module.exports = { problem1, problem2, problem3, problem4, problem5 };
SOLEOF

  # Git 커밋 & push
  cd "$STUDY_DIR"
  git add -A
  git commit -m "Week ${CURRENT_WEEK} Day ${CURRENT_DAY}: ${TOPIC}" 2>/dev/null || true
  git push origin main 2>/dev/null || true

  # 텔레그램 알림
  RETRY_LABEL=""
  if [ "$MODE" = "retry" ]; then
    RETRY_LABEL=" (반복 학습)"
  fi

  send_telegram "📚 *JavaScript 학습 - Week ${CURRENT_WEEK} Day ${CURRENT_DAY}/5*${RETRY_LABEL}

📂 카테고리: ${CATEGORY}
📌 주제: ${TOPIC}

오늘의 학습이 준비되었습니다!

📖 개념 설명 + ASCII 다이어그램
💼 실제 활용 사례 3가지
💻 예제 코드 5개
✏️ 연습 문제 5개

📁 \`problems/week$(printf '%02d' $CURRENT_WEEK)/day${CURRENT_DAY}/\`
- \`README.md\` → 학습 자료
- \`solution.js\` → 풀이 작성
- \`node test.js\` → 정답 확인

화이팅! 💪"

  # 다음 날로 진행
  NEXT_DAY=$((CURRENT_DAY + 1))
  save_progress $CURRENT_WEEK $NEXT_DAY $RETRY_COUNT "$MODE"

# ===== 평가 모드 =====
elif [ "$TYPE" = "exam" ]; then

  EXAM_DIR="$WEEK_DIR/exam"
  mkdir -p "$EXAM_DIR"

  # 이번 주 학습 주제 목록
  WEEK_TOPICS=$(python3 -c "
import json
c = json.load(open('$CURRICULUM_FILE'))
w = $CURRENT_WEEK - 1
topics = [d['topic'] for d in c['weeks'][w]['days'] if d['type'] == 'study']
print(', '.join(topics))
")

  PROMPT="당신은 JavaScript 초급 시험 출제자입니다. 파일을 생성하지 말고 마크다운 텍스트만 출력하세요.

Week ${CURRENT_WEEK} 주간 평가
카테고리: ${CATEGORY}
이번 주 학습 주제: ${WEEK_TOPICS}

아래 형식으로 주간 평가를 작성해주세요:

# Week ${CURRENT_WEEK} 주간 평가 - ${CATEGORY}

## 평가 안내
- 총 10문제, 각 10점 (100점 만점)
- 70점 이상이면 통과

## 문제
- 10문제 출제 (각 문제에 번호, 배점 10점 표시)
- 이번 주 학습한 5개 주제에서 골고루 2문제씩
- 각 문제에 함수 시그니처, 입출력 예시, 관련 주제 태그 포함
- 난이도: 기초 4문제, 응용 4문제, 심화 2문제

## exam-test.js
- Node.js로 실행 가능한 테스트 코드
- exam-solution.js에서 함수를 require해서 10문제 모두 검증
- 각 문제 통과 여부와 총점 출력
- 마지막에 JSON 형식으로 결과 요약 출력:
  \`\`\`
  ===RESULT_JSON===
  {\"score\": 80, \"total\": 100, \"passed\": [1,2,3,5,6,7,8,10], \"failed\": [4,9], \"failed_topics\": [\"주제1\", \"주제2\"]}
  ===END_RESULT===
  \`\`\`

모든 코드는 JavaScript, 설명은 한국어로 작성해주세요."

  echo "$PROMPT" | $CLAUDE -p --output-format text --max-turns 1 > "$EXAM_DIR/README.md" 2>/dev/null

  # exam-solution.js 템플릿
  cat > "$EXAM_DIR/exam-solution.js" << SOLEOF
// Week ${CURRENT_WEEK} 주간 평가 - ${CATEGORY}
// 아래에 풀이를 작성하세요!

function q1() { /* 여기에 코드 작성 */ }
function q2() { /* 여기에 코드 작성 */ }
function q3() { /* 여기에 코드 작성 */ }
function q4() { /* 여기에 코드 작성 */ }
function q5() { /* 여기에 코드 작성 */ }
function q6() { /* 여기에 코드 작성 */ }
function q7() { /* 여기에 코드 작성 */ }
function q8() { /* 여기에 코드 작성 */ }
function q9() { /* 여기에 코드 작성 */ }
function q10() { /* 여기에 코드 작성 */ }

module.exports = { q1, q2, q3, q4, q5, q6, q7, q8, q9, q10 };
SOLEOF

  # 채점 스크립트 생성
  cat > "$EXAM_DIR/grade.sh" << 'GRADEEOF'
#!/bin/bash
# 채점 실행 스크립트
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STUDY_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
REPORT_DIR="$STUDY_DIR/reports"
PROGRESS_FILE="$STUDY_DIR/scripts/progress.json"

# exam-test.js 실행 및 결과 파싱
RESULT=$(cd "$SCRIPT_DIR" && node exam-test.js 2>&1)
echo "$RESULT"

# JSON 결과 추출
JSON=$(echo "$RESULT" | sed -n '/===RESULT_JSON===/,/===END_RESULT===/p' | grep -v '===')

if [ -z "$JSON" ]; then
  echo "⚠️ 채점 결과를 파싱할 수 없습니다. exam-test.js를 확인해주세요."
  exit 1
fi

# 현재 주차 읽기
CURRENT_WEEK=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['current_week'])")
RETRY_COUNT=$(python3 -c "import json; print(json.load(open('$PROGRESS_FILE'))['retry_count'])")

# 리포트 저장
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/week$(printf '%02d' $CURRENT_WEEK)-report.json"

python3 -c "
import json
result = json.loads('$JSON')
result['week'] = $CURRENT_WEEK
result['attempt'] = $RETRY_COUNT + 1
with open('$REPORT_FILE', 'w') as f:
    json.dump(result, f, ensure_ascii=False, indent=2)
print(json.dumps(result, ensure_ascii=False, indent=2))
"

SCORE=$(python3 -c "import json; print(json.loads('$JSON')['score'])")
PASS_SCORE=70

# 텔레그램 결과 전송
BOT_TOKEN="8738509039:AAGY2sEvuirnO4C0h2rsULLu7TnqgOEgFyw"
CHAT_ID="6664560837"

if [ "$SCORE" -ge "$PASS_SCORE" ]; then
  # 통과 → 다음 주차
  NEXT_WEEK=$((CURRENT_WEEK + 1))
  echo "{\"current_week\": ${NEXT_WEEK}, \"current_day\": 1, \"retry_count\": 0, \"mode\": \"study\"}" > "$PROGRESS_FILE"

  MSG="✅ *Week ${CURRENT_WEEK} 평가 결과: ${SCORE}점 (통과!)*

🎉 축하합니다! 다음 주차로 진행합니다.
다음 월요일부터 Week $((CURRENT_WEEK + 1)) 시작!"

elif [ "$RETRY_COUNT" -ge 1 ]; then
  # 2차 평가도 미통과 → 약점 기록 후 다음 주차
  NEXT_WEEK=$((CURRENT_WEEK + 1))
  echo "{\"current_week\": ${NEXT_WEEK}, \"current_day\": 1, \"retry_count\": 0, \"mode\": \"study\"}" > "$PROGRESS_FILE"

  # 약점 누적 기록
  WEAKNESS_FILE="$REPORT_DIR/weakness-summary.json"
  python3 -c "
import json
result = json.loads('$JSON')
weakness = []
if '$WEAKNESS_FILE' != '' :
    try:
        weakness = json.load(open('$WEAKNESS_FILE'))
    except:
        pass
weakness.append({'week': $CURRENT_WEEK, 'score': result['score'], 'weak_topics': result.get('failed_topics', [])})
with open('$WEAKNESS_FILE', 'w') as f:
    json.dump(weakness, f, ensure_ascii=False, indent=2)
"

  MSG="📊 *Week ${CURRENT_WEEK} 2차 평가 결과: ${SCORE}점*

아쉽지만 다음 주차로 넘어갑니다.
약한 부분은 기록되었으며, 나중에 집중 복습할 예정입니다.
다음 월요일부터 Week $((CURRENT_WEEK + 1)) 시작!"

else
  # 1차 미통과 → 반복 학습
  echo "{\"current_week\": ${CURRENT_WEEK}, \"current_day\": 1, \"retry_count\": 1, \"mode\": \"retry\"}" > "$PROGRESS_FILE"

  FAILED_TOPICS=$(python3 -c "import json; r=json.loads('$JSON'); print(', '.join(r.get('failed_topics', [])))")

  MSG="📊 *Week ${CURRENT_WEEK} 평가 결과: ${SCORE}점 (미통과)*

70점 미만이므로 이번 주를 한 번 더 반복합니다.
약한 부분: ${FAILED_TOPICS}

다음 월요일부터 약점 위주로 다시 학습합니다!"
fi

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${MSG}" \
  -d "parse_mode=Markdown" > /dev/null

# Git 커밋
cd "$STUDY_DIR"
git add -A
git commit -m "Week ${CURRENT_WEEK} 평가 결과: ${SCORE}점" 2>/dev/null || true
git push origin main 2>/dev/null || true
GRADEEOF

  chmod +x "$EXAM_DIR/grade.sh"

  # Git 커밋 & push
  cd "$STUDY_DIR"
  git add -A
  git commit -m "Week ${CURRENT_WEEK} 주간 평가 출제" 2>/dev/null || true
  git push origin main 2>/dev/null || true

  # 텔레그램 알림
  send_telegram "📝 *Week ${CURRENT_WEEK} 주간 평가*

📂 카테고리: ${CATEGORY}
📋 범위: ${WEEK_TOPICS}

총 10문제 (100점 만점, 70점 이상 통과)

📁 \`problems/week$(printf '%02d' $CURRENT_WEEK)/exam/\`
1. \`README.md\` → 문제 확인
2. \`exam-solution.js\` → 풀이 작성
3. \`bash grade.sh\` → 채점 + 리포트 자동 생성

70점 이상이면 다음 주차로!
70점 미만이면 약한 부분 위주로 1주 반복!

화이팅! 💪"

fi

echo "Week ${CURRENT_WEEK} Day ${CURRENT_DAY} 완료: ${TOPIC} (${TYPE})"
