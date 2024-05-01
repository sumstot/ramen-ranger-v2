module RamenReviewsHelper
  def review_card_score_stars(score)
    stars = []
    rounded_score = score.round

    rounded_score.times do |i|
      if i != rounded_score - 1
        stars << { name: 'star', type: 'solid', color: star_color(score) }
      else
        if (rounded_score - score).positive?
          stars << { name: 'star-half', type: 'solid', color: star_color(score) }
        else
          stars << { name: 'star', type: 'solid', color: star_color(score) }
        end
      end
    end

    (5 - stars.length).times { stars << { name: 'star', type: 'solid', color: '#e0e1e0' } }
    stars
  end

  def star_color(score)
    case score
    when 4.5..5
      '#e74d30'
    when 3.5...4.5
      '#fe6a01'
    else
      '#feaa01'
    end
  end
end

#  E0E1E0
