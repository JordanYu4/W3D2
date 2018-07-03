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
  
  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL
    User.new(user.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def authored_replies
    Reply.find_by_user_id(id)
  end
  
end

class Question
  attr_accessor :id, :title, :body
  attr_reader :author_id
  
  def self.find_by_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    question.length == 0 ? nil : Question.new(question.first)
  end
  
  def self.find_by_author_id(author_id)
    author_questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE author_id = ?
    SQL
    author_questions.map{ |author_question| Question.new(author_question) }
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def replies
    Reply.find_by_question_id(id)
  end
  
end

class QuestionFollow
  
  def self.find_by_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT user_id
      FROM questions_follows
      WHERE question_id = ?
    SQL
    question
  end
  
end

class Reply
  attr_accessor :id, :body_text
  attr_reader :user, :subject_question, :parent_reply
  
  def self.find_by_id(reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    reply.length == 0 ? nil : Reply.new(reply.first)
  end
  
  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM replies
      WHERE user = ?
    SQL
    replies.map{|reply| Reply.new(reply)}
  end
  
  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE subject_question = ?
    SQL
    replies.map{|reply| Reply.new(reply)}
  end
  
  def initialize(options)
    @id = options['id']
    @subject_question = options['subject_question']
    @parent_reply = options['parent_reply']
    @user = options['user']
    @body_text = options['body_text']
  end
  
  def child_replies
    replies = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * 
      FROM replies
      WHERE parent_reply = ?
    SQL
    Reply.new(replies.first)
  end
  
end

class QuestionLike
  
  def self.find_by_id(question_id)
    liker_ids = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT user_liking
      FROM question_likes
      WHERE question_liked = ?
    SQL
    users = []
    liker_ids.each do |liker_id|
      users << User.find_by_id(liker_id.values.last)
    end
    users
  end
  
  
  
end



if $PROGRAM_NAME == __FILE__
  # snarky,_user = User.new('fname' => 'Tony', 'lname' => 'Stark')
  
end