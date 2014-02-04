# has_attributes

has_attributes is a ruby gem which provides a module for extending your classes with simple methods for creating elegant plain-ruby models.

## API

has_attributes delivers the following class and instance methods:

#### .model_attributes() → Set

An attribute accessor on the class that contains a set of attributes specified with `has_attributes`

#### .has_attributes(*args) → nil

Takes any number of symbols or strings and defines attribute accessors for those attributes. It also defines a `model_attributes` method on the class which will return the set of attributes. `has_attributes` will attempt to copy any existing attributes from the parent class unless the last argument is a `Hash` and contains an `inherit` key set to `false`.

#### #attributes() → Hash

Returns a hash whose keys are all the attributes declared `has_attributes` and the values are their corresponding values. If the values have not been set, the key will still be present in the hash but with a value of `nil`.

#### #attributes=(attrs) → Hash

Takes a hash `attrs` and sets all the attributes declared with `has_attributes` to either a corresponding value in `attrs` or `nil`.

## Examples

```ruby
require 'has_attributes'

class Person
  include HasAttributes
  has_attributes :first_name, :last_name
end

class President < Person
  # invoked multiple times
  has_attributes :party
  has_attributes :term
end

class Student < Person
  has_attributes :id, :major, inherit: false
end

Person.model_attributes # #<Set: {:first_name, :last_name}>
President.model_attributes # #<Set: {:first_name, :last_name, :party, :term}>
Student.model_attributes # #<Set: {:id, :major}>

person = Person.new
person.first_name = "John"
person.last_name = "Smith"

person.first_name # "John"
person.last_name  # "Smith"

person.attributes # {:first_name=>"John", :last_name=>"Smith"}

president = President.new
president.first_name = "Barack"
president.last_name = "Obama"
president.party = "democratic"
president.term = "8 years"

president.attributes # {:first_name=>"Barack", :last_name=>"Obama", :party=>"democratic", :term=>"8 years"}

president.attributes = {}
president.attributes # {}

president.attributes = {:first_name=>"Barack", :last_name=>"Obama", :party=>"democratic", :term=>"8 years"}
president.attributes # {:first_name=>"Barack", :last_name=>"Obama", :party=>"democratic", :term=>"8 years"}

student = Student.new
# Student did not inherit attributes from Person
student.first_name = "lilly" # Exception: undefined method "first_name=" ...
student.id = 123
student.major = "CS"

student.id    # 123
student.major # "CS"

student.attributes # {:id=>123, :major=>"CS"}
```

## License

[MIT](https://github.com/benjreinhart/has_attributes/blob/master/LICENSE.txt)
