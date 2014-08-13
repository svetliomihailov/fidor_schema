# Fidor API Schema

Our API is described with [JSON Schema](http://json-schema.org), which serves
as a public contract about available API resources and object internals.

This gem(besides the schema) provides a single utility method: the path to the
json files.

    gem install fidor_schema
    require 'fidor_schema'

    Fidor::Schema.path

Other languages can take advantage of the raw json files.

## BASICS

All strings must be UTF-8 

http://www.bundesbank.de/Redaktion/DE/Downloads/Aufgaben/Unbarer_Zahlungsverkehr/technische_spezifikation_februar_2014.pdf?__blob=publicationFile

German allowed chars:
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    0 1 2 3 4 5 6 7 8 9
    ' : ? , - ( + . ) / 
    Space
    Ä, ä, Ö, ö, Ü, ü, ß, &, *, $, %


## Test

Install required gems with bundler and go for it:

    bundle install
    rake spec

## JSON Schema version

Link definition
http://json-schema.org/latest/json-schema-hypermedia.html

## Field types & formats

Most of the fields are of type 'string'. Their format(especially date fields)
is casted on our side. We try to go with the [formats](http://tools.ietf.org/html/draft-zyp-json-schema-03#section-5.23) and [types])http://tools.ietf.org/html/draft-zyp-json-schema-03#section-5.1) defined by JSON-Schema

All text MUST be UTF-8 encoded.

*Text-Format* length varies, between ~16,000 to 65.535, with the occurence of non-ASCII Characters [see this post on stackoverflow](http://stackoverflow.com/questions/4420164/how-much-utf-8-text-fits-in-a-mysql-text-field)



Copyright (c)
