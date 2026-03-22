

# Day 1 - 변수 (let, const)

## 개념 설명

변수는 **데이터를 담는 상자**라고 생각하면 됩니다.

일상생활에서 물건을 정리할 때 상자에 라벨을 붙이듯이, 프로그래밍에서도 데이터에 이름을 붙여 저장합니다.

### let - 바꿀 수 있는 상자

`let`은 **내용물을 바꿀 수 있는 상자**입니다. 연필통에 연필을 넣었다가 펜으로 바꿀 수 있는 것처럼, `let`으로 만든 변수는 값을 나중에 변경할 수 있습니다.

```javascript
let fruit = "사과";   // 상자에 "사과"를 넣음
fruit = "바나나";      // 상자를 열고 "바나나"로 교체 → 가능!
```

### const - 잠긴 상자

`const`는 **한 번 넣으면 바꿀 수 없는 잠긴 상자**입니다. 타임캡슐처럼 한 번 봉인하면 내용물을 교체할 수 없습니다.

```javascript
const birthday = "1월 1일";  // 상자에 넣고 잠금
birthday = "2월 2일";         // ❌ 오류! 잠긴 상자는 못 바꿈
```

### 언제 뭘 써야 할까?

- **기본적으로 `const`를 사용하세요.** 값이 바뀔 필요가 없다면 `const`가 안전합니다.
- **값이 변해야 할 때만 `let`을 사용하세요.** 점수, 카운터 등 변하는 값에 적합합니다.
- **`var`는 사용하지 마세요.** 오래된 방식이고, 예상치 못한 문제를 일으킬 수 있습니다.

### 변수 이름 규칙

- 문자, `_`, `$`로 시작 (숫자로 시작 불가)
- 대소문자 구분 (`name`과 `Name`은 다른 변수)
- 의미 있는 이름 사용 (`x`보다 `userName`이 좋음)
- 카멜케이스 권장: `myFirstName`, `totalScore`

---

## 예제 코드

### 예제 1: let으로 점수 관리하기

```javascript
// 게임 점수를 관리하는 예제
let score = 0;           // 처음 점수는 0
console.log(score);       // 출력: 0

score = score + 10;       // 10점 획득!
console.log(score);       // 출력: 10

score = score + 20;       // 20점 추가 획득!
console.log(score);       // 출력: 30
```

### 예제 2: const로 변하지 않는 정보 저장하기

```javascript
// 변하지 않는 개인 정보를 저장하는 예제
const name = "김자바";
const birthYear = 2000;

// 현재 연도에서 태어난 연도를 빼서 나이 계산
let currentYear = 2026;
let age = currentYear - birthYear;

console.log(name + "님의 나이: " + age + "세");  // 출력: 김자바님의 나이: 26세

// name = "박자바";  // ❌ const는 재할당 불가! 오류 발생
```

### 예제 3: let과 const를 함께 사용하기

```javascript
// 쇼핑 카트 예제
const productName = "노트북";     // 상품명은 변하지 않음
const price = 1000000;            // 가격도 고정

let quantity = 1;                  // 수량은 변할 수 있음
console.log("수량: " + quantity);  // 출력: 수량: 1

quantity = 3;                      // 수량 변경
let total = price * quantity;      // 총액 계산

console.log(productName + " " + quantity + "개");       // 출력: 노트북 3개
console.log("총액: " + total + "원");                    // 출력: 총액: 3000000원
```

---

## 연습 문제

### 문제 1 (쉬움): 인사말 만들기

`name`과 `greeting`을 조합하여 인사말 문자열을 반환하는 함수를 작성하세요.

```javascript
function makeGreeting(name) {
  // "안녕하세요, {name}님!" 형태의 문자열을 반환하세요
  // const를 사용하여 결과를 저장한 후 반환하세요
}
```

**예상 입출력:**
| 입력 | 출력 |
|------|------|
| `"철수"` | `"안녕하세요, 철수님!"` |
| `"영희"` | `"안녕하세요, 영희님!"` |

---

### 문제 2 (보통): 온도 변환기

섭씨 온도를 화씨로 변환하는 함수를 작성하세요.
공식: **화씨 = 섭씨 × 9 / 5 + 32**

```javascript
function toFahrenheit(celsius) {
  // 섭씨를 화씨로 변환하여 반환하세요
  // const를 사용하여 변환 결과를 저장하세요
}
```

**예상 입출력:**
| 입력 | 출력 |
|------|------|
| `0` | `32` |
| `100` | `212` |
| `37` | `98.6` |

---

### 문제 3 (도전): 동전 교환기

금액(원)을 입력받아 500원, 100원, 50원, 10원 동전으로 최소 개수로 거슬러 주는 함수를 작성하세요. 결과는 문자열로 반환합니다.

```javascript
function makeChange(amount) {
  // let을 사용하여 남은 금액을 추적하세요
  // const를 사용하여 각 동전의 개수를 저장하세요
  // "500원: X개, 100원: X개, 50원: X개, 10원: X개" 형태로 반환
}
```

**예상 입출력:**
| 입력 | 출력 |
|------|------|
| `1260` | `"500원: 2개, 100원: 2개, 50원: 1개, 10원: 1개"` |
| `500` | `"500원: 1개, 100원: 0개, 50원: 0개, 10원: 0개"` |
| `170` | `"500원: 0개, 100원: 1개, 50원: 1개, 10원: 2개"` |

---

## test.js

```javascript
const { makeGreeting, toFahrenheit, makeChange } = require("./solution");

let passed = 0;
let failed = 0;

function test(name, actual, expected) {
  if (actual === expected) {
    console.log(`✅ PASS: ${name}`);
    passed++;
  } else {
    console.log(`❌ FAIL: ${name}`);
    console.log(`   기대값: ${expected}`);
    console.log(`   실제값: ${actual}`);
    failed++;
  }
}

console.log("=== 문제 1: 인사말 만들기 ===");
test("makeGreeting('철수')", makeGreeting("철수"), "안녕하세요, 철수님!");
test("makeGreeting('영희')", makeGreeting("영희"), "안녕하세요, 영희님!");
test("makeGreeting('JavaScript')", makeGreeting("JavaScript"), "안녕하세요, JavaScript님!");

console.log("\n=== 문제 2: 온도 변환기 ===");
test("toFahrenheit(0)", toFahrenheit(0), 32);
test("toFahrenheit(100)", toFahrenheit(100), 212);
test("toFahrenheit(37)", toFahrenheit(37), 98.6);

console.log("\n=== 문제 3: 동전 교환기 ===");
test("makeChange(1260)", makeChange(1260), "500원: 2개, 100원: 2개, 50원: 1개, 10원: 1개");
test("makeChange(500)", makeChange(500), "500원: 1개, 100원: 0개, 50원: 0개, 10원: 0개");
test("makeChange(170)", makeChange(170), "500원: 0개, 100원: 1개, 50원: 1개, 10원: 2개");

console.log(`\n총 ${passed + failed}개 테스트 중 ${passed}개 통과, ${failed}개 실패`);
```
