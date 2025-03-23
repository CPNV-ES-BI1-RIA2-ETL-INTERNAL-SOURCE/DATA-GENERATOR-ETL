# frozen_string_literal: true

module PDF
  # Responsible for file management operations
  class FileManager
    def generate_filename(date, request)
      "#{date.strftime('%Y-%m-%d')}/#{request[:stop]}.pdf"
    end
  end
end 