# DataGenerator
Part of BI project - 2024 - SBB.
## Description
A Data Fetcher / Data Generator for a Bussiness Inteligence project.
## Dependencies / run
- Language: Ruby
- API: Sinatra
- HTTP Client: HTTParty

### Run
```shell
bundle install
ruby .\src\index.rb -p 8080
```
```Shell
curl -X GET "http://localhost:8080/api/stationboard/switzerland/zurich?date=12/12/2024" \
     -H "Accept: application/pdf" \
     -o "stationboard.pdf"
```
## API
[OpenAPI](docs/api.yaml)
### Routes
// TODO define what and how the "clients" will want the data. (Clients are the Extract team)
#### JSON
```JSON
{
  "stop": {
    "id": "8503283",
    "name": "Einsiedeln",
    "type": "train,strain",
    "x": "699076",
    "y": "220557",
    "lon": 8.744481,
    "lat": 47.128578
  },
  "connections": [
    {
      "time": "2024-12-06 14:45:00",
      "*G": "S",
      "*L": "40",
      "*Z": "016955",
      "type": "strain",
      "line": "S40",
      "operator": "SOB-sob",
      "color": "039~fff~",
      "type_name": "S-Train",
      "terminal": {
        "id": "8503110",
        "name": "Rapperswil SG",
        "x": 704370,
        "y": 231356,
        "lon": 8.816743,
        "lat": 47.224885
      }
    }
  ]
}
```
#### PDF

The PDF will be generated with the data from the Search.ch API.

Using the Prawn Library, the PDF will be generated with the following structure:

- Header
  - Station name (Gare de `{{station}}`)
  - Date (État au `{{date}}`)
  - Logo (SBB)
- Body
  - Table
    - Columns
      - Time
      - Line
      - Destination
      - Vias
      - Platform

Example: [Timetable for Yverdon-les-Bains](docs/examples/yverdon-les-bains_24-12-12.pdf)

Usage Example:
```Ruby
api = SearchAPI.new
response = api.get_stationboard({:stop => "Yverdon-les-Bains", :date => "12/12/2024"})

pdf = PDFFormatter.new
pdf.format(response[:formatted_response])
```

Return:
```
%PDF-1.4
%\xFF\xFF\xFF\xFF
1 0 obj
<< /Creator <feff0050007200610077006e>
/Producer <feff0050007200610077006e>
...
```


## Source API

### Search.ch

[Search.ch](https://search.ch/) is a Swiss online service that provides various information and services, including a timetable API for public transportation. This API allows users to retrieve information about train schedules, connections, and stations. The API can be used to get details such as departure times, train lines, operators, and subsequent stops for a given station.

#### API Documentation

An OpenAPI specification for the Search.ch timetable API can be found [here](docs/externals_apis/search.ch.yaml). The documentation provides details about the available endpoints, request parameters, and response formats. The API supports various query parameters to filter and customize the results, such as specifying the station ID, date, time, and number of results.

[Official documentation](https://search.ch/timetable/api/help) 

## Testing
RSpec

```Ruby
RSpec.describe "An example" do
  it "adds two numbers" do
    expect(1 + 1).to eq(2)
  end

  it "raises an error when dividing by zero" do
    expect { 1 / 0 }.to raise_error(ZeroDivisionError)
  end
end
```
