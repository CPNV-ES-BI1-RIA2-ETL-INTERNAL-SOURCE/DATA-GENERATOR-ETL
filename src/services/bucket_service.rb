# frozen_string_literal: true

class BucketService

  # TODO This is a S3 Bucket Service. Interface is missing.
  # TODO rethink the idea of having a private variable for the bucket name. 
  # This is highly restrictive when working with multiple buckets. What about a static class ?
  # TODO You haven't applied what we studied at the beginning of the module.
  attr :client, :default_bucket

  def initialize(client, default_bucket)
    @client = client
    @default_bucket = default_bucket
  end

  def upload(content, filename, bucket_name)
    App.instance[:logger].debug("Uploading file #{filename} to bucket #{bucket_name}")
    r = client.put_object(
      bucket: bucket_name,
      key: filename,
      body: content,
      content_type: 'application/pdf'
    )
    App.instance[:logger].debug("File #{filename} uploaded to bucket #{bucket_name}. File etag: #{r.to_h[:etag]}")
    r
  end


  def get_presigned_url(object_key)
    s3 = Aws::S3::Resource.new(client: @client)
    obj = s3.bucket(@default_bucket).object(object_key)
    App.instance[:logger].debug("Generated presigned URL for object #{object_key}")
    obj.presigned_url(:get, expires_in: App.instance[:config]['storage']['signed_url_expiration_time'])
  end



end
