# Week 1 Day 2 - 숫자형과 산술 연산자

## 1. 개념 설명

### 숫자형(Number)이란?

JavaScript에서 숫자형은 **계산기**와 같습니다. 여러분이 일상에서 사용하는 계산기에 정수(1, 2, 3)도 입력하고, 소수(3.14, 0.5)도 입력하죠? JavaScript의 숫자형도 마찬가지로 **정수와 소수를 구분하지 않고 하나의 타입**으로 처리합니다. 다른 언어(Java, C 등)에서는 `int`, `float`, `double` 등으로 나누지만, JavaScript는 모두 `number` 하나입니다.

```
┌─────────────────────────────────────────────┐
│              JavaScript Number               │
│                                              │
│   정수: 1, 42, -7, 0                        │
│   소수: 3.14, 0.5, -2.7                     │
│   특수값: Infinity, -Infinity, NaN           │
│                                              │
│   → 전부 typeof === "number"                 │
└─────────────────────────────────────────────┘
```

### 산술 연산자

산술 연산자는 **요리 레시피**와 비슷합니다. 재료(숫자)를 가지고 다양한 조리법(연산자)을 적용해서 결과(새로운 숫자)를 만들어내는 것이죠.

```
┌──────────┬────────┬─────────────┬────────────┐
│  연산자  │  이름  │    예시     │   결과     │
├──────────┼────────┼─────────────┼────────────┤
│    +     │  덧셈  │   5 + 3     │     8      │
│    -     │  뺄셈  │   10 - 4    │     6      │
│    *     │  곱셈  │   3 * 7     │     21     │
│    /     │ 나눗셈 │   15 / 4    │    3.75    │
│    %     │ 나머지 │   17 % 5    │     2      │
│    **    │  거듭  │   2 ** 3    │     8      │
└──────────┴────────┴─────────────┴────────────┘
```

### 나머지 연산자(%)를 쉽게 이해하기

나머지 연산자는 **피자 나누기**로 생각하세요. 피자 17조각을 5명이 똑같이 나눠 먹으면 1인당 3조각씩 먹고 **2조각이 남습니다**. 이 "남는 조각"이 바로 나머지입니다.

```
17 ÷ 5 = 3 ... 나머지 2

  🍕🍕🍕🍕🍕 | 🍕🍕🍕🍕🍕 | 🍕🍕🍕🍕🍕 | 🍕🍕
  ---- 5개 ----  ---- 5개 ----  ---- 5개 ----  나머지!

  17 % 5 === 2
```

### 연산자 우선순위

수학 시간에 배운 것과 동일합니다. **곱셈/나눗셈이 덧셈/뺄셈보다 먼저** 계산됩니다.

```
우선순위 (높음 → 낮음):
┌───────────────────────────────┐
│  1순위:  ()      괄호         │
│  2순위:  **      거듭제곱     │
│  3순위:  * / %   곱셈/나눗셈  │
│  4순위:  + -     덧셈/뺄셈    │
└───────────────────────────────┘

예: 2 + 3 * 4  →  2 + 12  →  14  (3*4 먼저!)
   (2 + 3) * 4 →  5 * 4   →  20  (괄호 먼저!)
```

### 특수한 숫자값 3가지

```
┌──────────────┬──────────────────────────────────────┐
│    값        │         설명                          │
├──────────────┼──────────────────────────────────────┤
│  Infinity    │ 무한대. 1/0 의 결과                   │
│  -Infinity   │ 음의 무한대. -1/0 의 결과             │
│  NaN         │ "Not a Number". 숫자가 아님.          │
│              │ "hello" * 2 의 결과                   │
└──────────────┴──────────────────────────────────────┘
```

### 주의할 점과 흔한 실수

**실수 1: 소수점 계산의 함정**
```
0.1 + 0.2 === 0.3   // false!! (결과: 0.30000000000000004)
```
이것은 JavaScript의 버그가 아닙니다. 컴퓨터가 소수를 2진수로 저장하는 방식 때문에 발생하는 현상입니다. 마치 1/3을 소수로 쓰면 0.3333...으로 끝없이 이어지듯, 컴퓨터도 특정 소수를 정확히 표현할 수 없습니다.

**실수 2: 문자열 + 숫자**
```
"5" + 3    // "53"  (문자열 연결! 숫자 8이 아님!)
"5" - 3    // 2     (뺄셈은 숫자로 자동 변환)
```
`+` 연산자는 문자열 연결에도 사용되므로, 한쪽이 문자열이면 나머지도 문자열로 변환됩니다.

**실수 3: NaN의 특이한 성질**
```
NaN === NaN   // false!! NaN은 자기 자신과도 같지 않음
```
NaN인지 확인하려면 반드시 `isNaN()` 또는 `Number.isNaN()`을 사용해야 합니다.

---

## 2. 실제 활용 사례

### 사례 1: 쇼핑몰 - 할인 가격 계산

```javascript
const originalPrice = 50000;        // 원래 가격
const discountRate = 20;             // 할인율 20%
const discountAmount = originalPrice * (discountRate / 100);
const finalPrice = originalPrice - discountAmount;
console.log(`할인가: ${finalPrice}원`); // 할인가: 40000원
```

### 사례 2: 게임 - 경험치와 레벨 계산

```javascript
const totalExp = 2750;               // 총 경험치
const expPerLevel = 500;             // 레벨당 필요 경험치
const currentLevel = Math.floor(totalExp / expPerLevel); // 5레벨
const remainingExp = totalExp % expPerLevel;              // 250 남음
console.log(`Lv.${currentLevel} (다음 레벨까지 ${expPerLevel - remainingExp})`);
// Lv.5 (다음 레벨까지 250)
```

### 사례 3: 배달앱 - 배달비 거리 계산

```javascript
const baseFee = 3000;                // 기본 배달비
const distanceKm = 4.5;             // 거리 (km)
const freeDistance = 2;              // 무료 거리
const extraFeePerKm = 500;          // km당 추가 요금
const extraDistance = distanceKm - freeDistance;
const totalFee = baseFee + (extraDistance * extraFeePerKm);
console.log(`배달비: ${totalFee}원`); // 배달비: 4250원
```

---

## 3. 예제 코드

### 예제 1 (기초) - 기본 산술 연산

```javascript
// 두 숫자를 변수에 저장
const a = 15;
const b = 4;

// 기본 산술 연산 수행
console.log(a + b);   // 19  (덧셈)
console.log(a - b);   // 11  (뺄셈)
console.log(a * b);   // 60  (곱셈)
console.log(a / b);   // 3.75 (나눗셈 - 소수점까지 나옴!)
console.log(a % b);   // 3   (나머지: 15를 4로 나눈 나머지)
console.log(a ** b);  // 50625 (15의 4제곱: 15*15*15*15)
```

### 예제 2 (기초) - 숫자 타입 확인과 변환

```javascript
// typeof로 타입 확인
console.log(typeof 42);       // "number" (정수도 number)
console.log(typeof 3.14);     // "number" (소수도 number)
console.log(typeof NaN);      // "number" (NaN도 number 타입!)

// 문자열을 숫자로 변환하는 3가지 방법
const str = "123";
console.log(Number(str));     // 123 (Number 함수 사용)
console.log(parseInt(str));   // 123 (정수로 변환)
console.log(parseFloat("3.14")); // 3.14 (소수로 변환)

// 숫자로 변환할 수 없는 경우
console.log(Number("hello")); // NaN (변환 실패)
console.log(parseInt("50px")); // 50 (앞의 숫자만 추출)
```

### 예제 3 (응용) - 온도 변환기

```javascript
// 섭씨를 화씨로 변환하는 공식: F = C * 9/5 + 32
const celsius = 36.5;                         // 체온 36.5도
const fahrenheit = celsius * 9 / 5 + 32;     // 공식 적용
console.log(`${celsius}°C = ${fahrenheit}°F`);
// "36.5°C = 97.7°F"

// 화씨를 섭씨로 역변환: C = (F - 32) * 5/9
const fTemp = 100;                            // 화씨 100도
const cTemp = (fTemp - 32) * 5 / 9;          // 괄호로 뺄셈 먼저!
console.log(`${fTemp}°F = ${cTemp.toFixed(1)}°C`);
// "100°F = 37.8°C"
// toFixed(1)은 소수점 첫째자리까지 반올림해서 보여줌
```

### 예제 4 (응용) - 시간 변환기

```javascript
// 총 초를 시:분:초로 변환
const totalSeconds = 3725;                   // 3725초

// Math.floor()는 소수점을 버림 (내림)
const hours = Math.floor(totalSeconds / 3600);  // 3600초 = 1시간
// 3725 / 3600 = 1.034... → 1시간

const minutes = Math.floor((totalSeconds % 3600) / 60);
// 3725 % 3600 = 125 (1시간 빼고 남은 초)
// 125 / 60 = 2.08... → 2분

const seconds = totalSeconds % 60;
// 3725 % 60 = 5 (분 단위로 나누고 남은 초)

console.log(`${hours}시간 ${minutes}분 ${seconds}초`);
// "1시간 2분 5초"
```

### 예제 5 (심화) - 소수점 문제 해결과 Math 활용

```javascript
// 소수점 부동소수점 문제
console.log(0.1 + 0.2);              // 0.30000000000000004 (문제!)

// 해결법 1: toFixed()로 반올림 후 다시 숫자로 변환
const result1 = Number((0.1 + 0.2).toFixed(2));
console.log(result1);                 // 0.3

// 해결법 2: 정수로 변환해서 계산 후 다시 나누기
const result2 = (0.1 * 10 + 0.2 * 10) / 10;
console.log(result2);                 // 0.3

// 유용한 Math 메서드들
console.log(Math.round(4.5));         // 5   (반올림)
console.log(Math.round(4.4));         // 4   (반올림)
console.log(Math.ceil(4.1));          // 5   (올림 - ceiling: 천장)
console.log(Math.floor(4.9));         // 4   (내림 - floor: 바닥)
console.log(Math.abs(-7));            // 7   (절대값)
console.log(Math.max(3, 7, 2, 9));    // 9   (최대값)
console.log(Math.min(3, 7, 2, 9));    // 2   (최소값)

// 1~10 사이 랜덤 정수 생성
const random = Math.floor(Math.random() * 10) + 1;
// Math.random()은 0 이상 1 미만의 소수 (예: 0.7234...)
// * 10 하면 0 이상 10 미만 (예: 7.234...)
// Math.floor()로 내림하면 0~9 정수
// + 1 하면 1~10 정수
console.log(`랜덤 숫자: ${random}`);
```

---

## 4. 연습 문제

### 문제 1 (쉬움) - 원의 넓이 계산

반지름을 받아 원의 넓이를 반환하세요. (공식: π × r²)

```javascript
function circleArea(radius) {
  // 여기에 코드를 작성하세요
  // Math.PI를 사용하세요
}
```

**예상 입출력:**
- `circleArea(5)` → `78.54` (소수점 둘째자리까지 반올림)
- `circleArea(10)` → `314.16`
- `circleArea(1)` → `3.14`

**힌트:** `Math.PI`는 3.14159...를 제공합니다. `toFixed(2)`와 `Number()`를 조합하세요.

---

### 문제 2 (쉬움) - 짝수/홀수 판별

숫자를 받아 짝수면 `"짝수"`, 홀수면 `"홀수"`를 반환하세요.

```javascript
function evenOrOdd(num) {
  // 여기에 코드를 작성하세요
}
```

**예상 입출력:**
- `evenOrOdd(4)` → `"짝수"`
- `evenOrOdd(7)` → `"홀수"`
- `evenOrOdd(0)` → `"짝수"`

**힌트:** 나머지 연산자 `%`를 사용하세요. 어떤 숫자를 2로 나눈 나머지가 0이면?

---

### 문제 3 (보통) - 초를 시:분:초로 변환

총 초를 받아 `"H시간 M분 S초"` 형태의 문자열을 반환하세요.

```javascript
function formatTime(totalSeconds) {
  // 여기에 코드를 작성하세요
}
```

**예상 입출력:**
- `formatTime(3661)` → `"1시간 1분 1초"`
- `formatTime(7200)` → `"2시간 0분 0초"`
- `formatTime(45)` → `"0시간 0분 45초"`

**힌트:** 예제 4의 시간 변환기를 참고하세요. `Math.floor()`와 `%`를 활용합니다.

---

### 문제 4 (보통) - 할인 가격 계산기

가격과 할인율을 받아 최종 가격을 반환하세요. 10원 단위에서 내림 처리합니다.

```javascript
function discountPrice(price, discountPercent) {
  // 여기에 코드를 작성하세요
}
```

**예상 입출력:**
- `discountPrice(15000, 20)` → `12000`
- `discountPrice(32000, 15)` → `27200`
- `discountPrice(9900, 10)` → `8910`

**힌트:** 할인 금액을 구한 뒤 원래 가격에서 빼세요. 10원 단위 내림은 `Math.floor(값 / 10) * 10`으로 처리합니다.

---

### 문제 5 (도전) - 자릿수 합 계산

양의 정수를 받아 각 자릿수의 합을 반환하세요. **문자열 변환 없이** 산술 연산자만 사용하세요.

```javascript
function digitSum(num) {
  // 여기에 코드를 작성하세요
  // 문자열 변환(String, toString 등) 사용 금지!
  // % 와 Math.floor() 만 사용하세요
}
```

**예상 입출력:**
- `digitSum(123)` → `6` (1 + 2 + 3)
- `digitSum(9999)` → `36` (9 + 9 + 9 + 9)
- `digitSum(507)` → `12` (5 + 0 + 7)

**힌트:** `num % 10`은 마지막 자릿수를 꺼냅니다. `Math.floor(num / 10)`은 마지막 자릿수를 제거합니다. 이것을 숫자가 0이 될 때까지 반복하세요 (`while` 루프).

---

## 5. test.js

```javascript
// test.js
// 실행 방법: node test.js
// solution.js에서 함수들을 불러옵니다
const {
  circleArea,
  evenOrOdd,
  formatTime,
  discountPrice,
  digitSum,
} = require("./solution");

let passed = 0;
let failed = 0;

function test(name, actual, expected) {
  if (actual === expected) {
    console.log(`  ✅ PASS: ${name}`);
    passed++;
  } else {
    console.log(`  ❌ FAIL: ${name}`);
    console.log(`     기대값: ${expected}`);
    console.log(`     실제값: ${actual}`);
    failed++;
  }
}

console.log("=== 문제 1: 원의 넓이 ===");
test("circleArea(5)", circleArea(5), 78.54);
test("circleArea(10)", circleArea(10), 314.16);
test("circleArea(1)", circleArea(1), 3.14);

console.log("\n=== 문제 2: 짝수/홀수 ===");
test('evenOrOdd(4)', evenOrOdd(4), "짝수");
test('evenOrOdd(7)', evenOrOdd(7), "홀수");
test('evenOrOdd(0)', evenOrOdd(0), "짝수");

console.log("\n=== 문제 3: 시간 변환 ===");
test("formatTime(3661)", formatTime(3661), "1시간 1분 1초");
test("formatTime(7200)", formatTime(7200), "2시간 0분 0초");
test("formatTime(45)", formatTime(45), "0시간 0분 45초");

console.log("\n=== 문제 4: 할인 가격 ===");
test("discountPrice(15000, 20)", discountPrice(15000, 20), 12000);
test("discountPrice(32000, 15)", discountPrice(32000, 15), 27200);
test("discountPrice(9900, 10)", discountPrice(9900, 10), 8910);

console.log("\n=== 문제 5: 자릿수 합 ===");
test("digitSum(123)", digitSum(123), 6);
test("digitSum(9999)", digitSum(9999), 36);
test("digitSum(507)", digitSum(507), 12);

console.log("\n=============================");
console.log(`총 ${passed + failed}개 중 ${passed}개 통과, ${failed}개 실패`);
if (failed === 0) {
  console.log("🎉 모든 테스트를 통과했습니다!");
} else {
  console.log("💪 실패한 문제를 다시 풀어보세요!");
}
```
