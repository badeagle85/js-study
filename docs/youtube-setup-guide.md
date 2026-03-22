# JavaScript 학습 YouTube 자동화 셋팅 가이드

## 개요

매일 아침 자동으로 JavaScript 학습 영상을 만들어 YouTube에 업로드하는 시스템.

```
매일 아침 9시 (cron)
  ① Claude → 학습 내용 + 영상 대본 생성
  ② Edge TTS → 대본을 한국어 음성으로 변환
  ③ FFmpeg → 코드 화면 + 음성 합성하여 영상 생성
  ④ YouTube API → 자동 업로드
  ⑤ 텔레그램 → 업로드 완료 알림
```

---

## Step 1: 필요한 도구 설치

### 1-1. Edge TTS (무료 음성 합성)

Microsoft Edge의 TTS 엔진. 한국어 음성 품질이 좋음.

```bash
pip3 install edge-tts
```

테스트:
```bash
edge-tts --voice "ko-KR-SunHiNeural" --text "안녕하세요, JavaScript 학습을 시작합니다." --write-media test.mp3
```

사용 가능한 한국어 음성:
| 음성 | 특징 |
|------|------|
| ko-KR-SunHiNeural | 여성, 밝고 친근한 톤 (추천) |
| ko-KR-InJoonNeural | 남성, 차분한 톤 |

### 1-2. FFmpeg (영상 합성)

```bash
brew install ffmpeg
```

### 1-3. 코드 하이라이팅 도구

코드를 이미지로 변환하기 위해 `carbon-now-cli` 또는 `silicon` 사용.

```bash
# 방법 A: silicon (Rust 기반, 빠름)
brew install silicon

# 방법 B: puppeteer + carbon (Node.js 기반)
npm install -g carbon-now-cli
```

### 1-4. YouTube 업로드 도구

```bash
pip3 install google-api-python-client google-auth-oauthlib
```

---

## Step 2: YouTube API 설정

### 2-1. Google Cloud Console 프로젝트 생성

1. https://console.cloud.google.com/ 접속
2. 새 프로젝트 생성 → 이름: `js-study-youtube`
3. API 및 서비스 → 라이브러리 → "YouTube Data API v3" 검색 → 사용 설정

### 2-2. OAuth 인증 정보 생성

1. API 및 서비스 → 사용자 인증 정보
2. "사용자 인증 정보 만들기" → "OAuth 클라이언트 ID"
3. 애플리케이션 유형: "데스크톱 앱"
4. 생성 후 JSON 파일 다운로드
5. 파일 저장 위치:

```bash
mkdir -p /Users/macmini/Documents/GitHub/js-study/scripts/credentials
# 다운로드한 JSON을 아래 이름으로 저장
# /Users/macmini/Documents/GitHub/js-study/scripts/credentials/client_secret.json
```

### 2-3. 최초 인증 (1회만)

아래 스크립트를 실행하면 브라우저가 열리고 Google 로그인을 요청합니다.
로그인 후 토큰이 저장되어 이후에는 자동으로 인증됩니다.

```python
# scripts/youtube_auth.py
from google_auth_oauthlib.flow import InstalledAppFlow
import pickle
import os

SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]
CRED_DIR = os.path.dirname(os.path.abspath(__file__)) + "/credentials"

flow = InstalledAppFlow.from_client_secrets_file(
    f"{CRED_DIR}/client_secret.json", SCOPES
)
credentials = flow.run_local_server(port=0)

with open(f"{CRED_DIR}/token.pickle", "wb") as f:
    pickle.dump(credentials, f)

print("인증 완료! token.pickle이 저장되었습니다.")
```

실행:
```bash
python3 scripts/youtube_auth.py
```

---

## Step 3: 영상 생성 스크립트

### 3-1. 대본 생성 (Claude)

`daily-study.sh`에서 학습 내용 생성 시 영상 대본도 함께 생성하도록 수정.

대본 프롬프트 예시:
```
아래 JavaScript 학습 내용을 5~7분 분량의 유튜브 강의 대본으로 변환해주세요.

규칙:
- 친근한 말투 (~해요, ~합니다)
- [코드: 파일명] 태그로 코드 전환 시점 표시
- [화면: 설명] 태그로 다이어그램 표시 시점 표시
- 도입 인사 + 오늘의 주제 소개로 시작
- 핵심 요약 + 다음 시간 예고로 마무리
```

### 3-2. 음성 생성 (Edge TTS)

```bash
# scripts/generate_audio.sh
edge-tts \
  --voice "ko-KR-SunHiNeural" \
  --rate "+5%" \
  --file "$SCRIPT_FILE" \
  --write-media "$OUTPUT_DIR/narration.mp3" \
  --write-subtitles "$OUTPUT_DIR/subtitles.vtt"
```

포인트:
- `--rate "+5%"` : 약간 빠르게 (지루하지 않게)
- `--write-subtitles` : 자막 파일도 자동 생성

### 3-3. 코드 이미지 생성

```bash
# scripts/generate_code_images.sh
# 대본에서 [코드: ...] 태그를 파싱하여 코드 이미지 생성

silicon "$CODE_FILE" \
  --output "$OUTPUT_DIR/code_01.png" \
  --language javascript \
  --theme Dracula \
  --font "JetBrains Mono" \
  --pad-horiz 40 \
  --pad-vert 40
```

### 3-4. 영상 합성 (FFmpeg)

```bash
# scripts/generate_video.sh

# 기본 구조: 배경 이미지 + 코드 이미지들을 시간순 전환 + 음성 합성

# 1. 배경 생성 (1920x1080, 어두운 배경)
ffmpeg -f lavfi -i color=c=0x1a1a2e:s=1920x1080:d=1 -frames:v 1 bg.png

# 2. 코드 이미지를 슬라이드쇼로 만들기
ffmpeg -framerate 1/10 -i "$OUTPUT_DIR/code_%02d.png" \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=0x1a1a2e" \
  -c:v libx264 -pix_fmt yuv420p \
  "$OUTPUT_DIR/slides.mp4"

# 3. 음성 + 슬라이드 합성
ffmpeg -i "$OUTPUT_DIR/slides.mp4" \
  -i "$OUTPUT_DIR/narration.mp3" \
  -c:v copy -c:a aac \
  -shortest \
  "$OUTPUT_DIR/final.mp4"

# 4. 자막 하드코딩 (선택)
ffmpeg -i "$OUTPUT_DIR/final.mp4" \
  -vf "subtitles=$OUTPUT_DIR/subtitles.vtt:force_style='FontSize=22,PrimaryColour=&Hffffff&'" \
  "$OUTPUT_DIR/output.mp4"
```

### 3-5. YouTube 업로드

```python
# scripts/youtube_upload.py
import pickle
import os
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

CRED_DIR = os.path.dirname(os.path.abspath(__file__)) + "/credentials"

def upload_video(video_path, title, description, tags):
    with open(f"{CRED_DIR}/token.pickle", "rb") as f:
        credentials = pickle.load(f)

    youtube = build("youtube", "v3", credentials=credentials)

    body = {
        "snippet": {
            "title": title,
            "description": description,
            "tags": tags,
            "categoryId": "27",  # 교육
            "defaultLanguage": "ko",
        },
        "status": {
            "privacyStatus": "public",
            "selfDeclaredMadeForKids": False,
        },
    }

    media = MediaFileUpload(video_path, mimetype="video/mp4", resumable=True)

    request = youtube.videos().insert(
        part="snippet,status",
        body=body,
        media_body=media,
    )

    response = request.execute()
    video_id = response["id"]
    print(f"업로드 완료: https://youtu.be/{video_id}")
    return video_id
```

---

## Step 4: 전체 자동화 통합

### 4-1. daily-study.sh에 영상 파이프라인 추가

학습 내용 생성 후 아래 단계가 자동으로 실행되도록 수정:

```bash
# daily-study.sh 에 추가할 부분

# === 영상 생성 파이프라인 ===
VIDEO_DIR="$DAY_DIR/video"
mkdir -p "$VIDEO_DIR"

# 1. 대본 생성
echo "$SCRIPT_PROMPT" | $CLAUDE -p --output-format text --max-turns 1 > "$VIDEO_DIR/script.txt"

# 2. 음성 생성
edge-tts --voice "ko-KR-SunHiNeural" --rate "+5%" \
  --file "$VIDEO_DIR/script.txt" \
  --write-media "$VIDEO_DIR/narration.mp3" \
  --write-subtitles "$VIDEO_DIR/subtitles.vtt"

# 3. 코드 이미지 생성
bash "$SCRIPTS_DIR/generate_code_images.sh" "$VIDEO_DIR"

# 4. 영상 합성
bash "$SCRIPTS_DIR/generate_video.sh" "$VIDEO_DIR"

# 5. YouTube 업로드
python3 "$SCRIPTS_DIR/youtube_upload.py" \
  --video "$VIDEO_DIR/output.mp4" \
  --title "JavaScript 기초 Week${CURRENT_WEEK} Day${CURRENT_DAY} - ${TOPIC}" \
  --description "JavaScript 초급 학습 시리즈"
```

### 4-2. cron은 기존과 동일

```
0 9 * * 1-6  daily-study.sh  (학습 + 영상 + 업로드 모두 포함)
```

---

## Step 5: 셋팅 체크리스트

순서대로 진행하세요:

- [ ] `pip3 install edge-tts` 설치
- [ ] `brew install ffmpeg` 설치
- [ ] `brew install silicon` 설치
- [ ] Edge TTS 음성 테스트 (`edge-tts --voice ...`)
- [ ] Google Cloud Console 프로젝트 생성
- [ ] YouTube Data API v3 활성화
- [ ] OAuth 클라이언트 ID 생성 + JSON 다운로드
- [ ] `client_secret.json` 저장
- [ ] `python3 scripts/youtube_auth.py` 최초 인증
- [ ] 테스트 영상 1개 수동 생성 + 업로드 확인
- [ ] `daily-study.sh`에 영상 파이프라인 통합
- [ ] 전체 자동화 테스트

---

## 예상 결과물

### YouTube 채널
- 채널명: (원하는 이름)
- 영상 예시: "JavaScript 기초 Week1 Day1 - 변수 (let, const)"
- 영상 길이: 5~10분
- 업로드 빈도: 매일 (자동)
- 자막: 자동 포함

### 영상 구성
```
[0:00] 인트로 + 오늘의 주제
[0:30] 개념 설명 (다이어그램 화면)
[2:00] 실제 활용 사례
[3:30] 예제 코드 (코드 화면 + 음성 설명)
[5:00] 연습 문제 소개
[6:00] 마무리 + 다음 시간 예고
```

### 비용
| 항목 | 비용 |
|------|------|
| Claude (Max 구독) | 이미 결제 중 |
| Edge TTS | 무료 |
| FFmpeg | 무료 |
| Silicon | 무료 |
| YouTube API | 무료 |
| **합계** | **추가 비용 0원** |
