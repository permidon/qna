class Search < ApplicationRecord
  MODELS = %w(Everywhere Questions Answers Comments Users).freeze

  def self.search(source, query)
    return [] unless MODELS.include? source
    return [] if query.blank?
    if source == 'Everywhere'
      ThinkingSphinx.search ThinkingSphinx::Query.escape(query)
    else
      source.classify.constantize.search ThinkingSphinx::Query.escape(query)
    end
  end
end