PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL
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
  ('Bob', 'Builder');
  
INSERT INTO
  questions (title, body)
VALUES
  ('Help', 'I''ve fallen and I can''t get up'),
  ('Baby', 'Whose baby is this?');
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (
    (SELECT id FROM users WHERE fname = 'Jordan'),
    (SELECT id FROM questions WHERE title = 'Help')
  ),
  (
    (SELECT id FROM users WHERE fname = 'Eric'),
    (SELECT id FROM questions WHERE title = 'Baby')
  );
  
INSERT INTO
  replies (subject_question, parent_reply, user, body_text)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'Help'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Eric'),
    'Sorry, I''m busy.'
  );
  
INSERT INTO
  question_likes (question_liked, user_liking)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'Help'),
    (SELECT id FROM users WHERE fname = 'Bob')
  );