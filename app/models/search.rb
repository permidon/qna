class Search < ApplicationRecord
  SOURCES = %w(Everywhere Questions Answers Comments Users).freeze

  def self.search(source, query)
    return [] unless SOURCES.include? source
    return [] if query.blank?
    request = ThinkingSphinx::Query.escape(query)
    if source == 'Everywhere'
      ThinkingSphinx.search request
    else
      source.classify.constantize.search request
    end
  end
end