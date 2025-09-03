-- StoryTracker Database Schema
-- Generated from DBML schema

-- Create tables
CREATE TABLE IF NOT EXISTS chunk (
    id VARCHAR(255) PRIMARY KEY,
    detail TEXT NOT NULL,
    order_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS character (
    id VARCHAR(255) PRIMARY KEY,
    chunk_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    gender VARCHAR(50),
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chunk_id) REFERENCES chunk(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS place (
    id VARCHAR(255) PRIMARY KEY,
    chunk_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chunk_id) REFERENCES chunk(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS relationship (
    id VARCHAR(255) PRIMARY KEY,
    chunk_id VARCHAR(255) NOT NULL,
    first_character_id VARCHAR(255) NOT NULL,
    second_character_id VARCHAR(255) NOT NULL,
    relation_name VARCHAR(255) NOT NULL,
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chunk_id) REFERENCES chunk(id) ON DELETE CASCADE,
    FOREIGN KEY (first_character_id) REFERENCES character(id) ON DELETE CASCADE,
    FOREIGN KEY (second_character_id) REFERENCES character(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS character_location (
    id VARCHAR(255) PRIMARY KEY,
    chunk_id VARCHAR(255) NOT NULL,
    character_id VARCHAR(255) NOT NULL,
    place_id VARCHAR(255) NOT NULL,
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chunk_id) REFERENCES chunk(id) ON DELETE CASCADE,
    FOREIGN KEY (character_id) REFERENCES character(id) ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES place(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_chunk_order ON chunk(order_number);
CREATE INDEX IF NOT EXISTS idx_character_chunk ON character(chunk_id);
CREATE INDEX IF NOT EXISTS idx_place_chunk ON place(chunk_id);
CREATE INDEX IF NOT EXISTS idx_relationship_chunk ON relationship(chunk_id);
CREATE INDEX IF NOT EXISTS idx_character_location_chunk ON character_location(chunk_id);

-- Insert sample data for testing
INSERT INTO chunk (id, detail, order_number) VALUES 
('chunk_001', '빨간 모자가 할머니를 찾아 숲으로 향했다.', 1),
('chunk_002', '숲에서 늑대를 만났다.', 2)
ON CONFLICT (id) DO NOTHING;
