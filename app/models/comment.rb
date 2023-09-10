class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ramen_review
end
