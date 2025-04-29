class ReviewImage < ApplicationRecord
  attr_accessor :blob_signed_id
  belongs_to :ramen_review
  has_one_attached :image
  acts_as_list scope: :ramen_review

  before_save :attach_blob, if: -> { blob_signed_id.present? }

  private

  def attach_blob
    self.image = ActiveStorage::Blob.find_signed(blob_signed_id)
  end
end
