

class QuestionFollow
  
  def self.find_by_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT user_id
      FROM questions_follows
      WHERE question_id = ?
    SQL
    question
  end
  
  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname
      FROM question_follows
        JOIN users 
          ON question_follows.user_id = users.id
      WHERE question_follows.question_id = ?
    SQL
    followers.map { |follower| User.new(follower) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    followed_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.title, questions.body, questions.author_id
      FROM questions
        JOIN question_follows
        ON questions.id = question_follows.question_id
      WHERE question_follows.user_id = ?
    SQL
    followed_questions.map { |question| Question.new(question) }
  end
  
  def self.most_followed_questions(n)
    followed_questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.title, questions.body, questions.author_id
      FROM questions
        JOIN question_follows
          ON questions.id = question_follows.question_id
      GROUP BY questions.id
      ORDER BY COUNT(*) DESC
      LIMIT ?
    SQL
    followed_questions.map { |question| Question.new(question) }
  end
  
end
