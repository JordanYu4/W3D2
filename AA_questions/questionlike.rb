

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
