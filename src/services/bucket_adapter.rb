# frozen_string_literal: true

# Use Bundler to properly load the gem
require 'bundler/setup'
require 'bucket_sdk'
require_relative '../container'

module Services
  # BucketAdapter provides a bridge between our app and the bucket-sdk gem
  # following Ruby conventions and good practices
  class BucketAdapter
    include Import[:logger]

    # Initializes a new BucketAdapter
    #
    # @param base_url [String] The default bucket name to use for operations
    def initialize(base_url, **deps)
      @client = BucketSdk.new base_url: base_url
      @logger = deps[:logger]
    end

    # Uploads content to the specified bucket
    #
    # @param content [String] The content to upload
    # @param filename [String] The destination filename
    # @return [Hash] Response from the bucket SDK
    def upload(content, filename)
      @logger.debug("Uploading file #{filename}")

      temp_file = Tempfile.new(filename)
      begin
        temp_file.write(content)
        temp_file.rewind

        response = @client.upload_object(
          file: temp_file,
          destination: filename
        )
      ensure
        temp_file.close
        temp_file.unlink
      end

      @logger.debug("File #{filename} uploaded. Response: #{response.inspect}")
      response
    end
  end
end
