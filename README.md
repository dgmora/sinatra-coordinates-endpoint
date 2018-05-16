# Sinatra coordinates endpoint

The goal of this exercise is to implement a simple web server
application in Ruby that receives an address as a string, and
outputs the longitude and latitude of the aforementioned address
via HTTP.
The application should include one API endpoint that accepts a
GET request, which expects a query parameter to hold the address
query string. The endpoint will have a JSON-formatted response
that contains the longitude and latitude of the given address. For
example, if the address query string is “checkpoint charlie”, the API
should respond with the longitude and latitude in JSON format. 

## Installation

```
gem install bundler
bundle install
```

## Usage

Start the server:

```
ruby coordinates-enpoint.rb
```

And visit localhost:4567


## Decisions

### Sinatra

I thought it was a good opportunity to give Sinatra a try, as rails felt like
overkill for such a task
