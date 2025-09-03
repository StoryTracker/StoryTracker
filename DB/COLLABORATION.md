# 🚀 StoryTracker 데이터베이스 협업 가이드

## 📋 팀원들이 동일한 데이터베이스를 보는 방법

### 1. **새로운 팀원 온보딩**
```bash
# 1. 프로젝트 클론
git clone <repository>
cd StoryTracker

# 2. Docker 시작 (자동으로 동일한 스키마 생성)
./docker-manager.sh start

# 3. 확인
./docker-manager.sh status
```

### 2. **스키마 변경 시**
```bash
# 1. 마이그레이션 파일 생성
DB/migrations/002_add_new_feature.sql

# 2. 커밋 및 푸시
git add DB/migrations/002_add_new_feature.sql
git commit -m "Add new feature to database schema"
git push

# 3. 다른 팀원들이 pull 후 재시작
git pull
./docker-manager.sh restart
```

### 3. **데이터 동기화**
```bash
# 1. 시드 데이터 업데이트
DB/init/02_seed_data.sql

# 2. 커밋 및 푸시
git add DB/init/02_seed_data.sql
git commit -m "Update seed data"
git push

# 3. 다른 팀원들이 pull 후 재시작
git pull
./docker-manager.sh restart
```

## 🔄 데이터베이스 상태 동기화

### **항상 동일하게 유지되는 것:**
- ✅ 테이블 구조 (스키마)
- ✅ 인덱스와 제약조건
- ✅ 초기 시드 데이터
- ✅ 마이그레이션 히스토리

### **각자 다른 것 (로컬 데이터):**
- ❌ 실제 스토리 데이터 (개발 중인 내용)
- ❌ 테스트 데이터
- ❌ 개인 설정

## 🚨 주의사항

1. **절대 직접 테이블 구조를 수정하지 마세요**
   - ALTER TABLE, DROP TABLE 등 금지
   - 항상 마이그레이션 파일 사용

2. **데이터 변경은 Git으로 공유**
   - 중요한 시드 데이터는 커밋
   - 개인 테스트 데이터는 커밋하지 않음

3. **Docker 볼륨은 로컬 전용**
   - `postgres_data`는 각자 컴퓨터에만 저장
   - 스키마와 시드 데이터만 Git으로 공유

## 🎯 협업 워크플로우

### **스키마 변경 시:**
```
팀원 A: 스키마 변경 → 마이그레이션 파일 생성 → 커밋/푸시
팀원 B: git pull → docker restart → 동일한 스키마 적용
팀원 C: git pull → docker restart → 동일한 스키마 적용
```

### **개발 데이터 공유 시:**
```
팀원 A: 데이터 추가 → ./sync-development-data.sh sync → 자동 커밋/푸시
팀원 B: git pull → ./docker-manager.sh restart → 동일한 데이터 적용
팀원 C: git pull → ./docker-manager.sh restart → 동일한 데이터 적용
```

## 🚀 개발 데이터 동기화 스크립트

### **사용법:**
```bash
# 대화형 메뉴
./sync-development-data.sh

# 직접 명령어
./sync-development-data.sh extract    # 데이터 추출
./sync-development-data.sh commit     # 커밋 및 푸시
./sync-development-data.sh pull       # 다른 팀원 데이터 받기
./sync-development-data.sh sync       # 전체 동기화
```

### **워크플로우:**
1. **개발 중에 데이터 추가/수정**
2. **`./sync-development-data.sh sync` 실행**
   - 현재 데이터베이스에서 모든 데이터 추출
   - 자동으로 Git에 커밋 및 푸시
3. **다른 팀원들이 `git pull` 후 `./docker-manager.sh restart`**

이렇게 하면 **모든 팀원이 100% 동일한 데이터베이스 구조와 데이터**를 가질 수 있습니다! 🎉
