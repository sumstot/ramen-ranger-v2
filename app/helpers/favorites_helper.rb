module FavoritesHelper
  def favorite_class(favoritable, user)
    'is-favorited' if favoritable.favorited_by?(user)
  end
end
