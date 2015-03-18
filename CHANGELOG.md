#Changelog Fidor API Schema

A more detailed view of the changes can be found in the [commit messages](https://github.com/fidor/fidor_schema/commits/)

##2015-03

* remove name attribute in favour of title
* remove nested $refs pointing to properties in favour of direct link to the related schema
* validate the schema files against three different ruby validators
* add $schema version to each file
* SepaCreditTransfer requires remote_iban
* Transaction update transaction types

##2015-02

* SepaMandates filter by multiple references and ibans
* move required markup into 'required' array on top-level of an object
* change date field format to 'date-time' since date-only values are also valid in terms of http://tools.ietf.org/html/rfc3339#section-5.6
* change readonly field property to readOnly

##2014-12

* be explicit for number fields, now defined as integers

##2014-11

* Customer/Sepa direct debit add creditor_identifier field
* Lists of any object type are now returned under the generic 'data' key
* Transaction clarify nested transaction_type_details
* Transaction amount can be negative
* add rate_limit endpoint

##2014-10

* initial public release - ALPHA
