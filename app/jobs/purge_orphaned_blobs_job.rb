class PurgeOrphanedBlobsJob < ApplicationJob
  queue_as :default

  def perform(time_threshold: 24.hours)
    orphan_blobs = ActiveStorage::Blob.unattached.where('active_storage_blobs.created_at < ?', time_threshold.ago)
    Rails.logger.info "Found #{orphan_blobs.count} orphaned blobs for cleanup"
    orphan_blobs.find_each do |blob|
      blob.purge
    end
  end
end
