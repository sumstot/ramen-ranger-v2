module FavoritesHelper
  def favorite_icon_hash(favoritable, user)
    if favoritable.favorited_by?(user)
      { name: 'bookmark', type: 'solid', color: '#fe9601' }
    else
      { name: 'bookmark', type: 'outline' }
    end
  end
end
