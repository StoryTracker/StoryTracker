#!/bin/bash

# StoryTracker Development Data Sync Script
# 이 스크립트는 개발 중에 생성된 데이터를 팀원들과 공유하기 위한 것입니다

set -e

print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# 현재 데이터베이스에서 데이터 추출
extract_data() {
    print_status "현재 데이터베이스에서 데이터를 추출합니다..."
    
    if ! docker-compose ps postgres | grep -q "Up"; then
        print_error "데이터베이스가 실행 중이 아닙니다. 먼저 시작해주세요: ./docker-manager.sh start"
        exit 1
    fi
    
    # 데이터만 추출 (스키마 제외)
    docker-compose exec -T postgres pg_dump -U storyuser storytracker --data-only --column-inserts > DB/init/03_shared_development_data.sql
    
    print_status "데이터 추출 완료: DB/init/03_shared_development_data.sql"
}

# Git에 커밋 및 푸시
commit_and_push() {
    print_status "변경사항을 Git에 커밋하고 푸시합니다..."
    
    # 파일 상태 확인
    git status
    
    # 사용자 확인
    echo ""
    print_warning "위 파일들을 Git에 커밋하시겠습니까? (y/N)"
    read -r response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        # 커밋 메시지 입력
        echo "커밋 메시지를 입력하세요:"
        read -r commit_message
        
        if [ -z "$commit_message" ]; then
            commit_message="Update shared development data"
        fi
        
        # 커밋 및 푸시
        git add DB/init/03_shared_development_data.sql
        git commit -m "$commit_message"
        git push
        
        print_status "성공적으로 커밋 및 푸시되었습니다!"
        print_status "다른 팀원들이 'git pull' 후 './docker-manager.sh restart'로 데이터를 받을 수 있습니다."
    else
        print_status "커밋이 취소되었습니다."
    fi
}

# 다른 팀원의 데이터 받기
pull_data() {
    print_status "다른 팀원의 최신 데이터를 받습니다..."
    
    git pull
    
    if [ -f "DB/init/03_shared_development_data.sql" ]; then
        print_status "새로운 데이터가 있습니다. 데이터베이스를 재시작하여 적용하시겠습니까? (y/N)"
        read -r response
        
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            ./docker-manager.sh restart
            print_status "데이터베이스가 재시작되었습니다. 새로운 데이터가 적용되었습니다."
        else
            print_status "데이터베이스 재시작이 취소되었습니다. 나중에 './docker-manager.sh restart'로 수동 재시작하세요."
        fi
    else
        print_status "새로운 데이터가 없습니다."
    fi
}

# 메인 메뉴
show_menu() {
    echo ""
    echo "StoryTracker Development Data Sync"
    echo "=================================="
    echo "1. 현재 데이터 추출"
    echo "2. 데이터 커밋 및 푸시"
    echo "3. 다른 팀원 데이터 받기"
    echo "4. 전체 동기화 (추출 + 커밋 + 푸시)"
    echo "5. 도움말"
    echo "6. 종료"
    echo ""
    echo "선택하세요 (1-6): "
}

# 도움말
show_help() {
    echo ""
    echo "StoryTracker Development Data Sync 도움말"
    echo "========================================="
    echo ""
    echo "이 스크립트는 팀원들과 개발 데이터를 공유하기 위한 것입니다."
    echo ""
    echo "사용법:"
    echo "1. '현재 데이터 추출': 데이터베이스의 모든 데이터를 SQL 파일로 추출"
    echo "2. '데이터 커밋 및 푸시': 추출된 데이터를 Git에 커밋하고 푸시"
    echo "3. '다른 팀원 데이터 받기': Git에서 최신 데이터를 받고 데이터베이스에 적용"
    echo "4. '전체 동기화': 위 과정을 한 번에 수행"
    echo ""
    echo "워크플로우:"
    echo "1. 개발 중에 데이터를 추가/수정"
    echo "2. 이 스크립트로 데이터 추출 및 공유"
    echo "3. 다른 팀원들이 데이터를 받아서 동기화"
    echo ""
    echo "주의사항:"
    echo "- 중요한 데이터만 공유하세요 (테스트 데이터는 제외)"
    echo "- 데이터베이스가 실행 중이어야 합니다"
    echo "- Git 저장소에 연결되어 있어야 합니다"
}

# 메인 로직
case "${1:-}" in
    "1"|"extract")
        extract_data
        ;;
    "2"|"commit")
        commit_and_push
        ;;
    "3"|"pull")
        pull_data
        ;;
    "4"|"sync")
        extract_data
        commit_and_push
        ;;
    "5"|"help"|"--help"|"-h")
        show_help
        ;;
    "6"|"exit")
        print_status "종료합니다."
        exit 0
        ;;
    "")
        while true; do
            show_menu
            read -r choice
            
            case "$choice" in
                1) extract_data ;;
                2) commit_and_push ;;
                3) pull_data ;;
                4) extract_data; commit_and_push ;;
                5) show_help ;;
                6) print_status "종료합니다."; exit 0 ;;
                *) print_error "잘못된 선택입니다. 1-6 중에서 선택하세요." ;;
            esac
            
            echo ""
            echo "계속하려면 Enter를 누르세요..."
            read -r
        done
        ;;
    *)
        print_error "알 수 없는 명령: $1"
        echo "사용법: $0 [extract|commit|pull|sync|help]"
        exit 1
        ;;
esac
