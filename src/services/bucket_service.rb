# frozen_string_literal: true

require_relative '../container'
require_relative '../app'

# BucketService class for managing storage bucket operations
class BucketService
  # TODO: This is a S3 Bucket Service. Interface is missing.
  # TODO rethink the idea of having a private variable for the bucket name.
  # This is highly restrictive when working with multiple buckets. What about a static class ?
  # TODO You haven't applied what we studied at the beginning of the module.
  # ANSWER DRZ - In this no fix is needed in facts this component is going to be removed to be replaced by a sparated
  # service that will handle the bucket operations.
  attr_reader :client, :default_bucket

  # Auto-inject dependencies from the container
  include Import[:logger, :config]

  def initialize(client, default_bucket, **deps)
    @client = client
    @default_bucket = default_bucket

    # Logger is auto-injected through Import
    @logger = deps[:logger]
    @config = deps[:config]
  end

  def upload(content, filename, bucket_name)
    @logger.debug("Uploading file #{filename} to bucket #{bucket_name}")
    r = client.put_object(
      bucket: bucket_name,
      key: filename,
      body: content,
      content_type: 'application/pdf'
    )
    @logger.debug("File #{filename} uploaded to bucket #{bucket_name}. File etag: #{r.to_h[:etag]}")
    r
  end

  def get_presigned_url(object_key)
    s3 = Aws::S3::Resource.new(client: @client)
    obj = s3.bucket(@default_bucket).object(object_key)
    @logger.debug("Generated presigned URL for object #{object_key}")
    obj.presigned_url(:get, expires_in: @config['storage']['signed_url_expiration_time'])
  end
end
