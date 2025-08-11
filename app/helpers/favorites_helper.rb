module FavoritesHelper
  def favorite_icon_hash(favoritable, user)
    if favoritable.favorited_by?(user)
      { name: 'bookmark', type: 'solid', color: '#fe9601' }
    else
      { name: 'bookmark', type: 'outline' }
    end
  end

  def favorite_button(favoritable, user, css_class: 'favorite__button')
    turbo_frame_tag favoritable, :favorite do
      button_to polymorphic_path([favoritable, :favorite]),
                form_class: css_class,
                method: :patch do
        box_icon(favorite_icon_hash(favoritable, user))
      end
    end
  end
end
