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
