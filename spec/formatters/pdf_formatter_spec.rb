# frozen_string_literal: true

require_relative '../spec_helper'
require 'pdf/inspector'
require_relative '../../src/formatters/pdf_formatter'
require_relative '../../src/externalAPIs/search_ch'
require_relative '../externalAPIs/mock_search_api'

RSpec.describe PDFFormatter do
  let(:api_client) { MockSearchAPI.new }
  let(:pdf_formatter) { PDFFormatter.new }
  let(:data) { api_client.get_stationboard({:stop => "Yverdon-les-Bains", :date => "12/12/2024"}) }
  let(:pdf) { pdf_formatter.format(data) }

  it 'generates a PDF with the correct headers' do
    text_analysis = PDF::Inspector::Text.analyze(pdf)
    headers = ['Heure de départ', 'Ligne', 'Destination', 'Vias', 'Voie']
    headers.each do |header|
      expect(text_analysis.strings).to include(header)
    end
  end

  it 'generates a PDF with the correct connection details' do
    text_analysis = PDF::Inspector::Text.analyze(pdf)
    expect(text_analysis.strings).to include('0 31')
    expect(text_analysis.strings).to include('R')
    expect(text_analysis.strings).to include('Grandson')
    expect(text_analysis.strings).to include('1')
  end
end