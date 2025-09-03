-- StoryTracker Shared Development Data
-- 이 파일은 팀원들이 개발 중에 생성한 데이터를 공유하기 위한 것입니다
-- 새로운 데이터를 추가할 때마다 이 파일을 업데이트하고 커밋하세요

-- 개발 중에 추가된 스토리 청크들
INSERT INTO chunk (id, detail, order_number) VALUES 
('chunk_003', '늑대가 할머니 집으로 먼저 갔다.', 3),
('chunk_004', '빨간 모자가 할머니 집에 도착했다.', 4),
('chunk_005', '늑대가 할머니를 삼켰다.', 5)
ON CONFLICT (id) DO NOTHING;

-- 추가된 캐릭터들
INSERT INTO character (id, chunk_id, name, age, gender, summary) VALUES 
('char_004', 'chunk_003', '사냥꾼', 35, '남성', '늑대를 잡는 사냥꾼'),
('char_005', 'chunk_004', '할머니', 70, '여성', '늑대에게 잡힌 할머니')
ON CONFLICT (id) DO NOTHING;

-- 추가된 장소들
INSERT INTO place (id, chunk_id, name, summary) VALUES 
('place_004', 'chunk_003', '할머니 집', '숲 속에 있는 할머니의 집'),
('place_005', 'chunk_004', '할머니 집 안', '할머니 집 내부')
ON CONFLICT (id) DO NOTHING;

-- 추가된 관계들
INSERT INTO relationship (id, chunk_id, first_character_id, second_character_id, relation_name, summary) VALUES 
('rel_003', 'chunk_003', 'char_003', 'char_002', '위협', '늑대가 할머니를 위협'),
('rel_004', 'chunk_005', 'char_004', 'char_003', '대적', '사냥꾼이 늑대와 대적')
ON CONFLICT (id) DO NOTHING;

-- 추가된 위치 정보들
INSERT INTO character_location (id, chunk_id, character_id, place_id, summary) VALUES 
('loc_005', 'chunk_003', 'char_003', 'place_004', '늑대가 할머니 집에 도착'),
('loc_006', 'chunk_004', 'char_001', 'place_004', '빨간 모자가 할머니 집에 도착'),
('loc_007', 'chunk_005', 'char_004', 'place_004', '사냥꾼이 할머니 집에 도착')
ON CONFLICT (id) DO NOTHING;
