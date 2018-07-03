require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname
  
  def self.find_by_id(user_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL
    user.length == 0 ? nil : User.new(user.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
end

class Question
  attr_accessor :id, :title, :body
  
  def self.find_by_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    question.length == 0 ? nil : Question.new(question.first)
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
  end
  
end

class QuestionFollow
end

class Reply
  attr_accessor :id, :subject_question, :parent_reply, :user, :body_text
  def self.find_by_id(reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    reply.length == 0 ? nil : Reply.new(reply.first)
  end
  
  def initialize(options)
    @id = options['id']
    @subject_question = options['subject_question']
    @parent_reply = options['parent_reply']
    @user = options['user']
    @body_text = options['body_text']
  end
  
end

class QuestionLike
end
