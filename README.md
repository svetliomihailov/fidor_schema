# Fidor API Schema

The Fidor API is described with [JSON Schema](http://json-schema.org), which serves
as a public contract about available API resources and object internals.

This gem(besides the schema) provides a single utility method: the path to the
json files.

    gem install fidor_schema
    require 'fidor_schema'

    Fidor::Schema.path

Other languages can take advantage of the raw json files.

## Test

Install required gems with bundler and go for it:

    bundle install
    rake spec

## Field types & formats

All strings MUST be UTF-8 encoded. Date & date-time values are ISO8601

Copyright (c) 2014 Fidor AG
