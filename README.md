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
You need to create a project and a key in the google console as explained
[here](https://developers.google.com/maps/documentation/geocoding/intro) 

Copy `.env.example` to `.env` and add the correct keys

```
GOOGLE_API_KEY=PUT_THAT_KEY_HERE
SECRET_KEY=abcd # You can use this key (as part of the exercise)
```

Start the server:

```
rackup config.ru
```

And visit localhost:9292/?query=checkpoint%20charlie&secret_key=abcd


## Decisions

Some cases won't be covered: Bad route, wrong http verb, etc. It's out of the
scope, as this is supposed to be doing 1 single thing, and taking care of that.
Cases as errors in the google side or an address without geocoded address should
be handled though.

### Sinatra and general design

I thought it was a good opportunity to give Sinatra a try, as rails felt like
overkill for such a task

I structured it in a way that the main class is just an entry point with routing,
and we handle the logic of the endpoint in a different class. If we would
multiple endpoints we could reuse the client logic, but there's not need at the moment.

I used restclient instead of the built-in http library as it's simpler, 
and handles timeouts nicely

### VCR and testing

Every case should be tested. I used VCR and webmock for that.

Another option would have been mocking the requests, but as the google api returns quite
some data, I thought it'd be easier to use VCR to cover all the cases without having to
do trial and error for different cases (multiple results, no results, bad credentials..)


### Configuration

This will be handled by the gem `dotenv`. The real values will never be commited to github,
but they can live locally in that file for the developer convenience. The real values
for production will be loaded from the environment.

For testing, we are taking care that `ENV['GOOGLE_API_KEY']` and `ENV['SECRET_KEY']` are
filtered from the VCR cassettes, so we can store the requests withour fear of writing
the keys. The key values changing won't be a problem. The key names changing would imply
touching everything, but there's not a lot to be done there.

If this would be a rails app we could opt for the encrypted credentials feature that is
included.

### Errors

We propagate errors sent from google without failing abruptly, same for timeouts
