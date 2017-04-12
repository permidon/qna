class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :user_id, :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: { in: [-1, 1] }
  validates :votable_type, inclusion: { in: ['Question', 'Answer']  }

  after_create :rating_increment
  after_destroy :rating_decrement

  after_commit :publish_rating

  private

  def rating_increment
    votable.increment!(:rating, value)
  end

  def rating_decrement
    votable.decrement!(:rating, value)
  end

  def publish_rating
    return unless defined?(self)
    return if self.errors.any?
    ActionCable.server.broadcast(
        'votes',
        { vote: self, rating: self.votable.rating }
    )
  end
end
