# Week 1 Day 1 - 변수 (let, const)와 변수 명명 규칙

## 1. 개념 설명

### 변수란 무엇인가?

변수는 **데이터를 담아두는 이름표가 붙은 상자**입니다. 일상생활에서 비유하자면, 여러분의 서랍장을 떠올려보세요. 서랍마다 "양말", "속옷", "티셔츠"라는 라벨이 붙어 있고, 그 안에 해당하는 물건을 넣어둡니다. 프로그래밍에서 변수도 마찬가지입니다. `userName`이라는 라벨(변수명)을 붙이고, 그 안에 `"홍길동"`이라는 값을 넣어두는 것이죠.

```
 변수 선언 과정
 ─────────────────────────────────────────

  let userName = "홍길동";

  ┌─ 키워드 ─┐  ┌─ 변수명 ─┐    ┌─ 값 ─┐
      let        userName    =   "홍길동"
  └──────────┘  └──────────┘    └───────┘
   "상자를 만들어"  "이름표 붙여"   "값을 넣어"
```

### let vs const

JavaScript에서 변수를 선언하는 키워드는 **두 가지**입니다.

| 구분 | `let` | `const` |
|------|-------|---------|
| 의미 | **변할 수 있는** 변수 | **변하지 않는** 상수 |
| 재할당 | ✅ 가능 | ❌ 불가능 |
| 재선언 | ❌ 불가능 | ❌ 불가능 |
| 비유 | 화이트보드 (지우고 다시 쓸 수 있음) | 돌에 새긴 글씨 (한번 새기면 끝) |

```
  let (화이트보드)              const (돌에 새긴 글씨)
 ┌──────────────┐             ┌──────────────┐
 │  score = 0   │  ──쓱──▶   │  PI = 3.14   │
 │  score = 10  │  (지우고    │  PI = 99  ✖  │ ← TypeError!
 │  score = 25  │   다시씀)   │              │
 └──────────────┘             └──────────────┘
```

**일상 비유를 더 들어보면:**
- `let`은 **연필로 쓴 메모** — 지우개로 지우고 새로 쓸 수 있습니다. 게임 점수, 장바구니 수량처럼 계속 바뀌는 값에 사용합니다.
- `const`는 **볼펜으로 쓴 계약서** — 한번 쓰면 수정할 수 없습니다. 생년월일, 원주율(π), API 주소처럼 절대 변하지 않는 값에 사용합니다.

### var는 왜 안 쓰나요?

과거에는 `var`라는 키워드도 있었습니다. 하지만 `var`는 같은 이름으로 **재선언이 가능**하고, **함수 스코프**라서 예상치 못한 버그를 일으킵니다. 현대 JavaScript에서는 `let`과 `const`만 사용합니다.

```
  var (옛날 방식 - 사용 금지!)
 ┌─────────────────────────────┐
 │  var name = "철수";          │
 │  var name = "영희";  ← OK?! │  ← 실수로 덮어써도 에러 안 남!
 └─────────────────────────────┘

  let (현대 방식 - 안전!)
 ┌─────────────────────────────┐
 │  let name = "철수";          │
 │  let name = "영희";  ← ❌    │  ← SyntaxError 발생! 실수 방지!
 └─────────────────────────────┘
```

### 변수 명명 규칙

변수 이름을 짓는 것은 **아기 이름을 짓는 것**만큼 중요합니다. 좋은 이름은 코드를 읽기 쉽게 만들고, 나쁜 이름은 코드를 암호문으로 만듭니다.

**필수 규칙 (어기면 에러):**

| 규칙 | 좋은 예 | 나쁜 예 (에러) |
|------|---------|---------------|
| 숫자로 시작 불가 | `item1` | `1item` |
| 특수문자 불가 (`_`, `$` 제외) | `user_name` | `user-name`, `user@name` |
| 예약어 사용 불가 | `myClass` | `class`, `let`, `return` |
| 공백 사용 불가 | `firstName` | `first name` |

**권장 규칙 (어기면 동료가 화남):**

```
  ✅ camelCase (낙타 표기법) — JavaScript 표준!
 ┌──────────────────────────────────────────┐
 │  firstName        (O) 첫 글자 소문자      │
 │  totalPrice       (O) 두번째 단어부터 대문자│
 │  isLoggedIn       (O) boolean은 is/has    │
 │  MAX_RETRY_COUNT  (O) 상수는 SNAKE_CASE   │
 └──────────────────────────────────────────┘

  ❌ 나쁜 이름의 예
 ┌──────────────────────────────────────────┐
 │  a, b, x          → 의미를 알 수 없음     │
 │  data, info       → 너무 모호함           │
 │  FirstName        → PascalCase는 클래스용  │
 └──────────────────────────────────────────┘
```

### 흔한 실수 TOP 3

**실수 1: const로 선언한 변수에 재할당**
```javascript
const age = 25;
age = 26;  // ❌ TypeError: Assignment to constant variable.
```

**실수 2: 선언 전에 사용 (TDZ - Temporal Dead Zone)**
```javascript
console.log(name);  // ❌ ReferenceError: Cannot access 'name' before initialization
let name = "철수";
```

**실수 3: let과 const 선택을 반대로 함**
```javascript
let PI = 3.14159;       // ❌ 변하지 않는 값인데 let?
const userInput = "";   // ❌ 사용자 입력은 바뀌는데 const?
```

> **💡 팁:** 기본적으로 `const`를 사용하고, 값이 변해야 할 때만 `let`으로 바꾸세요. 이것이 현대 JavaScript의 베스트 프랙티스입니다.

---

## 2. 실제 활용 사례

### 사례 1: 쇼핑몰 장바구니

온라인 쇼핑몰에서 사용자가 상품을 담고, 수량을 변경하고, 총 금액을 계산하는 상황입니다.

```javascript
// 상품 정보 (변하지 않음 → const)
const PRODUCT_NAME = "무선 키보드";
const PRICE = 45000;
const TAX_RATE = 0.1;

// 수량은 사용자가 변경 가능 → let
let quantity = 1;
quantity = 3;  // 사용자가 수량을 3개로 변경

// 총 금액 계산
const subtotal = PRICE * quantity;       // 135000
const tax = subtotal * TAX_RATE;         // 13500
const total = subtotal + tax;            // 148500

console.log(`${PRODUCT_NAME} x ${quantity}개 = ${total}원`);
```

### 사례 2: 게임 캐릭터 상태 관리

RPG 게임에서 캐릭터의 변하는 상태와 고정된 설정값을 구분하는 상황입니다.

```javascript
// 캐릭터 고정 정보 → const
const CHARACTER_NAME = "전사";
const MAX_HP = 100;
const MAX_MP = 50;

// 게임 중 변하는 상태 → let
let currentHp = MAX_HP;   // 100
let currentMp = MAX_MP;   // 50
let level = 1;

// 몬스터에게 공격 당함!
currentHp = currentHp - 30;  // 70
// 마법 사용!
currentMp = currentMp - 15;  // 35
// 레벨업!
level = level + 1;            // 2

console.log(`${CHARACTER_NAME} Lv.${level} | HP: ${currentHp}/${MAX_HP}`);
```

### 사례 3: 채팅 앱 메시지 표시

채팅 앱에서 사용자 정보와 메시지 상태를 관리하는 상황입니다.

```javascript
// 사용자 고정 정보 → const
const USER_ID = "user_20260322";
const DISPLAY_NAME = "김개발";
const MAX_MESSAGE_LENGTH = 500;

// 메시지 상태 (변경 가능) → let
let messageText = "";
let isTyping = false;
let unreadCount = 5;

// 사용자가 메시지 작성 중
isTyping = true;
messageText = "안녕하세요! 반갑습니다.";

// 메시지 전송 후 상태 초기화
isTyping = false;
messageText = "";
unreadCount = 0;

console.log(`${DISPLAY_NAME}: 읽지 않은 메시지 ${unreadCount}개`);
```

---

## 3. 예제 코드

### 예제 1 (기초): 변수 선언과 출력

```javascript
// === 예제 1: 기본적인 변수 선언과 출력 ===

// const로 변하지 않는 값 선언
const schoolName = "JavaScript 초등학교";  // 학교 이름은 바뀌지 않음

// let으로 변할 수 있는 값 선언
let studentCount = 30;                     // 학생 수는 변할 수 있음

// 값 출력
console.log(schoolName);      // 실행 결과: "JavaScript 초등학교"
console.log(studentCount);    // 실행 결과: 30

// let 변수는 값을 변경할 수 있음
studentCount = 31;             // 전학생이 왔다!
console.log(studentCount);    // 실행 결과: 31

// const 변수는 값을 변경할 수 없음
// schoolName = "다른 학교";   // ❌ TypeError 발생!
```

### 예제 2 (기초): 변수 명명 규칙 실습

```javascript
// === 예제 2: 올바른 변수 이름 vs 잘못된 변수 이름 ===

// ✅ 올바른 camelCase 변수명
const firstName = "길동";           // 이름
const lastName = "홍";              // 성
const fullName = lastName + firstName; // 문자열 연결(+)로 전체 이름 생성

console.log(fullName);             // 실행 결과: "홍길동"

// ✅ boolean 변수는 is/has/can으로 시작
let isAdult = true;                // 성인 여부
let hasLicense = false;            // 면허 보유 여부
const canDrive = isAdult && hasLicense;  // 운전 가능 여부 (둘 다 true여야 함)

console.log(canDrive);             // 실행 결과: false

// ✅ 상수는 UPPER_SNAKE_CASE
const MAX_LOGIN_ATTEMPTS = 5;      // 최대 로그인 시도 횟수
const API_BASE_URL = "https://api.example.com";  // API 주소

console.log(MAX_LOGIN_ATTEMPTS);   // 실행 결과: 5
```

### 예제 3 (응용): 온도 변환기

```javascript
// === 예제 3: 섭씨 ↔ 화씨 온도 변환 ===

// 변환 공식은 절대 변하지 않으므로 const
const CONVERSION_FACTOR = 9 / 5;   // 섭씨→화씨 변환 계수 (1.8)
const OFFSET = 32;                  // 화씨 보정값

// 입력 온도는 상황에 따라 변하므로 let
let celsiusTemp = 25;              // 섭씨 25도

// 섭씨 → 화씨 변환: (C × 9/5) + 32
let fahrenheitTemp = (celsiusTemp * CONVERSION_FACTOR) + OFFSET;
console.log(`${celsiusTemp}°C = ${fahrenheitTemp}°F`);
// 실행 결과: "25°C = 77°F"

// 다른 온도로 변환 (let이므로 재할당 가능)
celsiusTemp = 0;                   // 물이 어는 온도
fahrenheitTemp = (celsiusTemp * CONVERSION_FACTOR) + OFFSET;
console.log(`${celsiusTemp}°C = ${fahrenheitTemp}°F`);
// 실행 결과: "0°C = 32°F"

celsiusTemp = 100;                 // 물이 끓는 온도
fahrenheitTemp = (celsiusTemp * CONVERSION_FACTOR) + OFFSET;
console.log(`${celsiusTemp}°C = ${fahrenheitTemp}°F`);
// 실행 결과: "100°C = 212°F"
```

### 예제 4 (응용): 할인 가격 계산기

```javascript
// === 예제 4: 쿠폰 할인 적용 계산기 ===

// 상품 고정 가격 → const
const ORIGINAL_PRICE = 50000;       // 원래 가격: 5만원
const MEMBERSHIP_DISCOUNT = 0.05;   // 회원 할인: 5%
const COUPON_DISCOUNT = 0.10;       // 쿠폰 할인: 10%

// 사용자 선택에 따라 달라지는 값 → let
let appliedDiscount = 0;            // 적용할 할인율 (초기값: 0%)
let finalPrice = ORIGINAL_PRICE;    // 최종 가격 (초기값: 원래 가격)

// 회원 할인 적용
appliedDiscount = MEMBERSHIP_DISCOUNT;                    // 5% 할인 적용
finalPrice = ORIGINAL_PRICE * (1 - appliedDiscount);      // 50000 × 0.95
console.log(`회원 할인: ${finalPrice}원`);
// 실행 결과: "회원 할인: 47500원"

// 쿠폰 추가 적용 (회원 할인 + 쿠폰 할인)
appliedDiscount = MEMBERSHIP_DISCOUNT + COUPON_DISCOUNT;  // 15% 할인
finalPrice = ORIGINAL_PRICE * (1 - appliedDiscount);      // 50000 × 0.85
console.log(`회원+쿠폰 할인: ${finalPrice}원`);
// 실행 결과: "회원+쿠폰 할인: 42500원"

// 절약한 금액 계산
const savedAmount = ORIGINAL_PRICE - finalPrice;          // 7500원 절약
console.log(`절약 금액: ${savedAmount}원`);
// 실행 결과: "절약 금액: 7500원"
```

### 예제 5 (심화): 변수 스코프와 블록

```javascript
// === 예제 5: let/const의 블록 스코프 이해하기 ===

// 전역 스코프에 선언된 변수
const APP_NAME = "My App";         // 어디서든 접근 가능
let userScore = 0;                 // 어디서든 접근 가능

console.log(`[시작] ${APP_NAME} - 점수: ${userScore}`);
// 실행 결과: "[시작] My App - 점수: 0"

// if 블록 안은 별도의 스코프
if (true) {
    const BONUS_POINTS = 50;       // 이 블록 안에서만 존재
    let bonusMessage = "보너스!";   // 이 블록 안에서만 존재
    userScore = userScore + BONUS_POINTS;  // 바깥의 userScore 수정 가능
    console.log(`[블록 안] ${bonusMessage} +${BONUS_POINTS}점`);
    // 실행 결과: "[블록 안] 보너스! +50점"
}

// 블록 밖에서는 블록 안의 변수에 접근 불가
// console.log(BONUS_POINTS);   // ❌ ReferenceError!
// console.log(bonusMessage);   // ❌ ReferenceError!

// 하지만 바깥 변수 userScore는 블록 안에서 수정된 값이 유지됨
console.log(`[결과] 최종 점수: ${userScore}`);
// 실행 결과: "[결과] 최종 점수: 50"

// for 루프에서의 스코프
for (let i = 0; i < 3; i++) {      // i는 for 블록 안에서만 존재
    const message = `${i + 1}번째 반복`;  // 매 반복마다 새로운 const
    console.log(message);
    // 실행 결과: "1번째 반복", "2번째 반복", "3번째 반복"
}
// console.log(i);              // ❌ ReferenceError! i는 for 블록 밖에서 접근 불가
```

---

## 4. 연습 문제

### 문제 1 (쉬움): 자기소개 변수 만들기

주어진 정보로 변수를 선언하고, 자기소개 문자열을 반환하세요.
`let`과 `const`를 적절히 구분해서 사용해야 합니다.

```javascript
function createIntroduction(name, age, hobby) {
    // name: 이름 (변하지 않음)
    // age: 나이 (변하지 않음)
    // hobby: 취미 (변하지 않음)
    //
    // 반환값: "안녕하세요! 저는 {name}이고, {age}살이며, 취미는 {hobby}입니다."
    //
    // 예시:
    //   createIntroduction("철수", 20, "코딩")
    //   → "안녕하세요! 저는 철수이고, 20살이며, 취미는 코딩입니다."
    //
    // 힌트: 템플릿 리터럴(백틱 ``)을 사용하면 편리합니다.
}
```

### 문제 2 (쉬움): 두 변수의 값 교환하기

두 값을 받아서 순서를 바꿔 배열로 반환하세요. `let`을 활용해야 합니다.

```javascript
function swapValues(a, b) {
    // a: 첫 번째 값
    // b: 두 번째 값
    //
    // 반환값: [b, a] (순서가 바뀐 배열)
    //
    // 예시:
    //   swapValues(1, 2)       → [2, 1]
    //   swapValues("안녕", "하세요") → ["하세요", "안녕"]
    //
    // 힌트: 임시 변수(temp)를 let으로 만들어 값을 잠시 보관하세요.
}
```

### 문제 3 (보통): 변수 이름 검증기

변수 이름이 camelCase 규칙을 따르는지 검증하세요.

```javascript
function isValidCamelCase(varName) {
    // varName: 검사할 변수 이름 (문자열)
    //
    // camelCase 규칙:
    //   1. 첫 글자는 소문자 영문 (a-z)
    //   2. 나머지는 영문(a-z, A-Z) 또는 숫자(0-9)만 허용
    //   3. 빈 문자열은 false
    //
    // 반환값: true 또는 false
    //
    // 예시:
    //   isValidCamelCase("userName")   → true
    //   isValidCamelCase("user_name")  → false  (언더스코어 불가)
    //   isValidCamelCase("UserName")   → false  (첫 글자 대문자)
    //   isValidCamelCase("a")          → true
    //   isValidCamelCase("myVar2")     → true
    //   isValidCamelCase("")           → false
    //   isValidCamelCase("2name")      → false  (숫자로 시작)
    //
    // 힌트: 정규표현식 /^[a-z][a-zA-Z0-9]*$/ 을 사용해보세요.
}
```

### 문제 4 (보통): 쇼핑 총액 계산기

상품 목록(가격 배열)과 세율을 받아 세금 포함 총액을 계산하세요.

```javascript
function calculateTotal(prices, taxRate) {
    // prices: 가격 배열 (예: [10000, 20000, 5000])
    // taxRate: 세율 (예: 0.1은 10%)
    //
    // 반환값: 세금 포함 총액 (정수, 소수점 이하 버림)
    //
    // 예시:
    //   calculateTotal([10000, 20000, 5000], 0.1)
    //   → 소계: 35000, 세금: 3500, 총액: 38500
    //
    //   calculateTotal([15000], 0.05)
    //   → 소계: 15000, 세금: 750, 총액: 15750
    //
    //   calculateTotal([], 0.1)
    //   → 0
    //
    // 힌트: for 루프에서 let으로 합계 변수를 만들고 누적하세요.
    //       Math.floor()로 소수점을 버릴 수 있습니다.
}
```

### 문제 5 (도전): 변수 선언 분석기

코드 문자열을 분석하여 `let`과 `const` 선언 개수를 세고, 올바른 사용인지 판단하세요.

```javascript
function analyzeDeclarations(codeLines) {
    // codeLines: 코드 줄 배열
    //   예: ["const PI = 3.14", "let count = 0", "let name = 'Kim'"]
    //
    // 각 줄은 "let 변수명 = 값" 또는 "const 변수명 = 값" 형태입니다.
    // (공백 하나로 구분, 항상 유효한 형식이라고 가정)
    //
    // 반환값: { letCount: 숫자, constCount: 숫자, summary: 문자열 }
    //   - letCount: let 선언 개수
    //   - constCount: const 선언 개수
    //   - summary: "let: {N}개, const: {M}개, total: {N+M}개"
    //
    // 예시:
    //   analyzeDeclarations(["const PI = 3.14", "let count = 0", "let name = 'Kim'"])
    //   → { letCount: 2, constCount: 1, summary: "let: 2개, const: 1개, total: 3개" }
    //
    //   analyzeDeclarations([])
    //   → { letCount: 0, constCount: 0, summary: "let: 0개, const: 0개, total: 0개" }
    //
    // 힌트: 각 줄의 첫 단어(split(' ')[0])를 확인하세요.
}
```

---

## 5. test.js

```javascript
// test.js — Node.js에서 실행: node test.js

const {
    createIntroduction,
    swapValues,
    isValidCamelCase,
    calculateTotal,
    analyzeDeclarations,
} = require("./solution");

let passed = 0;
let failed = 0;

function test(name, actual, expected) {
    const actualStr = JSON.stringify(actual);
    const expectedStr = JSON.stringify(expected);
    if (actualStr === expectedStr) {
        console.log(`  ✅ PASS: ${name}`);
        passed++;
    } else {
        console.log(`  ❌ FAIL: ${name}`);
        console.log(`     기대값: ${expectedStr}`);
        console.log(`     실제값: ${actualStr}`);
        failed++;
    }
}

console.log("\n📝 문제 1: 자기소개 변수 만들기");
test(
    "기본 테스트",
    createIntroduction("철수", 20, "코딩"),
    "안녕하세요! 저는 철수이고, 20살이며, 취미는 코딩입니다."
);
test(
    "다른 입력",
    createIntroduction("영희", 25, "독서"),
    "안녕하세요! 저는 영희이고, 25살이며, 취미는 독서입니다."
);

console.log("\n📝 문제 2: 두 변수의 값 교환하기");
test("숫자 교환", swapValues(1, 2), [2, 1]);
test("문자열 교환", swapValues("안녕", "하세요"), ["하세요", "안녕"]);
test("혼합 타입", swapValues(42, "hello"), ["hello", 42]);

console.log("\n📝 문제 3: 변수 이름 검증기");
test("유효한 camelCase", isValidCamelCase("userName"), true);
test("언더스코어 포함", isValidCamelCase("user_name"), false);
test("대문자 시작", isValidCamelCase("UserName"), false);
test("한 글자", isValidCamelCase("a"), true);
test("숫자 포함", isValidCamelCase("myVar2"), true);
test("빈 문자열", isValidCamelCase(""), false);
test("숫자 시작", isValidCamelCase("2name"), false);

console.log("\n📝 문제 4: 쇼핑 총액 계산기");
test("여러 상품", calculateTotal([10000, 20000, 5000], 0.1), 38500);
test("상품 하나", calculateTotal([15000], 0.05), 15750);
test("빈 배열", calculateTotal([], 0.1), 0);
test("세금 0%", calculateTotal([10000, 20000], 0), 30000);

console.log("\n📝 문제 5: 변수 선언 분석기");
test(
    "혼합 선언",
    analyzeDeclarations(["const PI = 3.14", "let count = 0", "let name = 'Kim'"]),
    { letCount: 2, constCount: 1, summary: "let: 2개, const: 1개, total: 3개" }
);
test(
    "빈 배열",
    analyzeDeclarations([]),
    { letCount: 0, constCount: 0, summary: "let: 0개, const: 0개, total: 0개" }
);
test(
    "const만",
    analyzeDeclarations(["const A = 1", "const B = 2"]),
    { letCount: 0, constCount: 2, summary: "let: 0개, const: 2개, total: 2개" }
);

console.log("\n" + "=".repeat(40));
console.log(`총 결과: ${passed}개 통과, ${failed}개 실패 (전체 ${passed + failed}개)`);
console.log("=".repeat(40) + "\n");
```
