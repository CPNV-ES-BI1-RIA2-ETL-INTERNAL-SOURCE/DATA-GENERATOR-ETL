# DataGenerator
Part of BI project - 2024 - SBB.
## Description
A Data Fetcher / Data Generator for a Bussiness Inteligence project.
## Dependencies / run
- Language: Ruby
- API: Sinatra
- HTTP Client: HTTParty
## API
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
// TODO Depending on the changes to the conception
## Source API
Search.ch : https://search.ch/timetable/api/help
