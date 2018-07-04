

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
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def authored_replies
    Reply.find_by_user_id(id)
  end
  
end
