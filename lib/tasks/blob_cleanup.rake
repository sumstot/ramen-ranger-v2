namespace :blobs do
  desc "Clean up orphaned blobs that were uploaded but never attached"
  task cleanup: :environment do
    PurgeOrphanedBlobsJob.perform_now(time_threshold: 24.hours)
  end
end
