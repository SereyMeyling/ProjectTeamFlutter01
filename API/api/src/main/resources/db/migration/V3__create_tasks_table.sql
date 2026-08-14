CREATE TABLE tasks (
                       id BIGSERIAL PRIMARY KEY,
                       title VARCHAR(255) NOT NULL,
                       description TEXT,
                       priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
                       category VARCHAR(100),
                       deadline TIMESTAMP,
                       is_completed BOOLEAN NOT NULL DEFAULT FALSE,
                       status VARCHAR(10) NOT NULL DEFAULT 'ACT',
                       user_id INTEGER NOT NULL REFERENCES users(id),
                       created_at TIMESTAMP,
                       created_by VARCHAR(255),
                       updated_at TIMESTAMP,
                       updated_by VARCHAR(255)
);

CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_status ON tasks(status);