-- StoryTracker Seed Data
-- This file ensures all team members have the same initial data structure

-- Sample characters
INSERT INTO character (id, chunk_id, name, age, gender, summary) VALUES 
('char_001', 'chunk_001', '빨간 모자', 8, '여성', '할머니를 찾아 숲으로 향하는 소녀'),
('char_002', 'chunk_001', '할머니', 70, '여성', '빨간 모자의 할머니'),
('char_003', 'chunk_002', '늑대', 5, '수컷', '숲에서 빨간 모자를 만난 늑대')
ON CONFLICT (id) DO NOTHING;

-- Sample places
INSERT INTO place (id, chunk_id, name, summary) VALUES 
('place_001', 'chunk_001', '마을', '빨간 모자가 사는 마을'),
('place_002', 'chunk_001', '숲', '할머니 집으로 가는 숲길'),
('place_003', 'chunk_002', '숲속', '늑대가 사는 숲속')
ON CONFLICT (id) DO NOTHING;

-- Sample relationships
INSERT INTO relationship (id, chunk_id, first_character_id, second_character_id, relation_name, summary) VALUES 
('rel_001', 'chunk_001', 'char_001', 'char_002', '손녀', '빨간 모자는 할머니의 손녀'),
('rel_002', 'chunk_002', 'char_001', 'char_003', '만남', '숲에서 늑대와 처음 만남')
ON CONFLICT (id) DO NOTHING;

-- Sample character locations
INSERT INTO character_location (id, chunk_id, character_id, place_id, summary) VALUES 
('loc_001', 'chunk_001', 'char_001', 'place_001', '마을에서 출발'),
('loc_002', 'chunk_001', 'char_001', 'place_002', '숲길을 걷는 중'),
('loc_003', 'chunk_002', 'char_001', 'place_003', '숲속에서 늑대와 조우'),
('loc_004', 'chunk_002', 'char_003', 'place_003', '숲속에서 빨간 모자와 조우')
ON CONFLICT (id) DO NOTHING;
