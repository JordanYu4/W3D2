

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
  
  def followers
    QuestionFollow.followers_for_question_id(id)
  end
  
end
