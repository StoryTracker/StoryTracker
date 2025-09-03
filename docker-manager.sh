#!/bin/bash

# StoryTracker PostgreSQL Docker Manager
set -e

print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    print_status "Docker is running"
}

start_db() {
    print_status "Starting PostgreSQL database..."
    docker-compose up -d postgres
    print_status "PostgreSQL database is ready!"
    echo "  Host: localhost, Port: 5432"
    echo "  Database: storytracker, User: storyuser"
}

stop_db() {
    print_status "Stopping PostgreSQL database..."
    docker-compose down
}

restart_db() {
    stop_db
    start_db
}

status_db() {
    if docker-compose ps postgres | grep -q "Up"; then
        print_status "Database is running"
        docker-compose ps postgres
    else
        echo "Database is not running"
    fi
}

connect_db() {
    if docker-compose ps postgres | grep -q "Up"; then
        docker-compose exec postgres psql -U storyuser -d storytracker
    else
        print_error "Database is not running. Start it first with: $0 start"
        exit 1
    fi
}

case "${1:-help}" in
    start)
        check_docker
        start_db
        ;;
    stop)
        check_docker
        stop_db
        ;;
    restart)
        check_docker
        restart_db
        ;;
    status)
        check_docker
        status_db
        ;;
    connect)
        check_docker
        connect_db
        ;;
    help|--help|-h)
        echo "Usage: $0 [start|stop|restart|status|connect]"
        ;;
    *)
        print_error "Unknown command: $1"
        exit 1
        ;;
esac
