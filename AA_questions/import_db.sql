DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question INTEGER NOT NULL,
  parent_reply INTEGER,
  user INTEGER NOT NULL,
  body_text NOT NULL,

  FOREIGN KEY (subject_question) REFERENCES questions(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id),
  FOREIGN KEY (user) REFERENCES users(id)

);

CREATE TABLE question_likes (
  question_liked INTEGER NOT NULL,
  user_liking INTEGER NOT NULL,

  FOREIGN KEY (question_liked) REFERENCES questions(id),
  FOREIGN KEY (user_liking) REFERENCES users(id)

);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jordan', 'Yu'),
  ('Eric', 'Tran'),
  ('Bob', 'Builder'),
  ('Mom', 'Tran'),
  ('Amanda', 'Yu'),
  ('Ryan', 'Gosling'),
  ('Hugh', 'Jackman'),
  ('Rachel', 'McAdams');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Help', 'I''ve fallen and I can''t get up', 2),
  ('Baby', 'Whose baby is this?', 1),
  ('Job', 'I need employment?', 4);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (
    (SELECT id FROM users WHERE fname = 'Bob'),
    (SELECT id FROM questions WHERE title = 'Baby')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Jordan'),
    (SELECT id FROM questions WHERE title = 'Help')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Eric'),
    (SELECT id FROM questions WHERE title = 'Job')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Ryan'),
    (SELECT id FROM questions WHERE title = 'Job')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Rachel'),
    (SELECT id FROM questions WHERE title = 'Help')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Hugh'),
    (SELECT id FROM questions WHERE title = 'Job')
  );

INSERT INTO
  replies (subject_question, parent_reply, user, body_text)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'Help'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Bob'),
    'Sorry, I''m busy.'
  );

INSERT INTO
  question_likes (question_liked, user_liking)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'Help'),
    (SELECT id FROM users WHERE fname = 'Jordan')
  ),
  (
    (SELECT id FROM questions WHERE title = 'Help'),
    (SELECT id FROM users WHERE fname = 'Amanda')
  );
