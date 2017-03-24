class FullAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  has_many :comments, serializer: ShortCommentSerializer
  has_many :attachments, serializer: ShortAttachmentSerializer
end
