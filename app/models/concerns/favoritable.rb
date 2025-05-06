module Favoritable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, as: :favoritable
  end

  def favorited_by?(user)
    favorites.where(user: user).any?
  end

  def favorite(user)
    favorites.where(user: user).first_or_create
  end

  def unfavorite(user)
    favorites.where(user: user).destroy_all
  end
end
