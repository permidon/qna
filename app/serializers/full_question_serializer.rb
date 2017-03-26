class FullQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :comments, serializer: ShortCommentSerializer
  has_many :attachments, serializer: ShortAttachmentSerializer
end
