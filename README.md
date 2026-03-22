# JavaScript 기초 학습

매일 아침 9시, 자동으로 학습 자료가 생성되는 JavaScript 기초 스터디입니다.

## 학습 방식

```
매일 아침 9시 (자동)
  → Claude가 오늘의 학습 자료 생성
  → GitHub에 자동 push
  → 텔레그램 알림 전송
```

### 주간 스케줄

| 요일 | 내용 |
|------|------|
| 월~금 | 학습 (1일 1주제, 개념 + 문제) |
| 토 | 주간 평가 (10문제, 100점 만점) |
| 일 | 휴식 |

### 평가 & 반복 규칙

- **70점 이상** → 다음 주차로 진행
- **70점 미만** → 틀린 부분 위주로 1주 반복
- **2차 평가도 미통과** → 약점 기록 후 다음 주차로 진행 (무한 반복 방지)

## 커리큘럼 (6주)

| 주차 | 카테고리 | 주제 |
|------|----------|------|
| 1주 | 변수와 자료형 | let/const, 숫자, 문자열, 불리언, 자료형 변환 |
| 2주 | 조건문 | 비교 연산자, if/else, 논리 연산자, switch |
| 3주 | 반복문 | for, while, break/continue, 중첩 반복문 |
| 4주 | 함수 | 선언/호출, 매개변수, return, 화살표 함수, 스코프 |
| 5주 | 배열 | 생성/접근, push/pop, 순회, map/filter/reduce |
| 6주 | 문자열과 객체 | 문자열 메서드, 템플릿 리터럴, 객체, Object 메서드 |

## 매일 학습 내용

각 학습일에는 아래 내용이 포함됩니다:

- **개념 설명** — 비유 + ASCII 다이어그램 + 표
- **실제 활용 사례** — 쇼핑몰, 게임, 채팅앱 등 실무 예시 3가지
- **예제 코드** — 5개 (기초 2 + 응용 2 + 심화 1)
- **연습 문제** — 5문제 (쉬움 2 + 보통 2 + 도전 1) + 힌트
- **테스트 코드** — `node test.js`로 정답 확인

## 폴더 구조

```
js-study/
├── README.md
├── problems/
│   ├── week01/
│   │   ├── day1/
│   │   │   ├── README.md        ← 개념 설명 + 문제
│   │   │   ├── solution.js      ← 여기에 풀이 작성
│   │   │   └── test.js          ← 정답 확인
│   │   ├── day2/
│   │   ├── ...
│   │   └── exam/
│   │       ├── README.md        ← 평가 문제
│   │       ├── exam-solution.js ← 평가 풀이 작성
│   │       └── grade.sh         ← 채점 실행
│   ├── week02/
│   └── ...
├── reports/
│   ├── week01-report.json       ← 주간 평가 결과
│   └── weakness-summary.json    ← 약점 누적 기록
└── scripts/
    ├── curriculum.json           ← 커리큘럼 데이터
    ├── daily-study.sh            ← 자동화 스크립트
    └── progress.json             ← 현재 진행 상황
```

## 학습 방법

### 평일 (월~금)

```bash
# 1. 텔레그램 알림 확인
# 2. 개념 학습
cat problems/week01/day1/README.md

# 3. 풀이 작성
vi problems/week01/day1/solution.js

# 4. 정답 확인
node problems/week01/day1/test.js
```

### 토요일 (주간 평가)

```bash
# 1. 평가 문제 확인
cat problems/week01/exam/README.md

# 2. 풀이 작성
vi problems/week01/exam/exam-solution.js

# 3. 채점 실행 (자동으로 리포트 생성 + 텔레그램 결과 전송)
bash problems/week01/exam/grade.sh
```

## 기술 스택

- **문제 생성**: Claude Code (Max 구독, `claude -p`)
- **알림**: Telegram Bot API
- **자동화**: macOS crontab (매일 오전 9시)
- **버전 관리**: Git + GitHub
