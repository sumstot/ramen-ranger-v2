module RamenReviewsHelper
  def review_card_score_stars(score)
    stars = []
    rounded_score = score.round

    rounded_score.times do |i|
      if i != rounded_score - 1
        stars << { name: 'star', type: 'solid' }
      else
        if (rounded_score - score).positive?
          stars << { name: 'star-half', type: 'solid' }
        else
          stars << { name: 'star', type: 'solid' }
        end
      end
    end

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
