require 'spec_helper'
require_relative '../../src/formatters/pdf/timetable_formatter'
require 'date'

RSpec.describe 'Formatters' do
  let(:sample_data) do
    File.read('spec/data/sample_data.json')
  end

  describe PDF::TimetableFormatter do
    let(:timetable_formatter) { PDF::TimetableFormatter.new }
    let(:date) { DateTime.new(2023, 1, 1, 12, 0, 0) }

    it 'creates a properly formatted PDF with timetable data' do
      # Parse the JSON content
      parsed_data = JSON.parse(sample_data, symbolize_names: true)

      response = StationBoardResponse.new(parsed_data)
      timetable = timetable_formatter.create_timetable(response, date)
      pdf_content = timetable.render
      pdf = PDF::Inspector::Text.analyze(pdf_content)
      extracted_text = pdf.strings.join(' ')
      
      # Check for expected content in the PDF
      expect(extracted_text).to include('Yverdon-les-Bains')
      expect(extracted_text).to include('01 January 2023') # Assuming DateFormatters would return this
      
      # Check for departure details
      expect(extracted_text).to include('0 04')
      expect(extracted_text).to include('S30')
      expect(extracted_text).to include('Payerne')
      expect(extracted_text).to include('3')
      
      expect(extracted_text).to include('0 15')
      expect(extracted_text).to include('R')
      expect(extracted_text).to include('Grandson')
      expect(extracted_text).to include('1')
      
      # Check for table headers
      expect(extracted_text).to include('Heure de départ')
      expect(extracted_text).to include('Ligne')
      expect(extracted_text).to include('Destination')
      expect(extracted_text).to include('Vias')
      expect(extracted_text).to include('Voie')
    end
  end
end