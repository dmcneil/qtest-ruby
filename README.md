# QTest::Ruby

A REST client for the QTest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qtest-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qtest-ruby

## Configure/Authenticate

Require the gem in your code.

```ruby
require 'qtest'
```

Create a `QTest::Client` and configure it with the base host/address of your
QTest instance and call the `auth` method passing in a Hash with your QTest
credentials.

```ruby
QTest::Client.new.configure do |c|
  c.base_uri = 'http://qtest.yourcompany.com'
  c.auth username: 'foo', password: 'bar'
end
```

The client is set on all `QTest::` objects and will be used for requests.

## Usage

The typical entry point for the API begins with a `QTest::Project`.

```ruby
@project = QTest::Project.find_by(id: 1)
```

With a `QTest::Project` you can begin to dive down into child objects such as
releases, test cycles, and test suites by chaining relationships.

```ruby
# Get a Release with an ID of 3 under the current Project
@release = @project.release(id: 3)

# Get a Test Cycle with an id of 4 under the Release
@test_cycle = @release.test_cycle(id: 4)

# Get all Test Suites under the Test Cycle
@test_suites = @test_cycle.test_suites

# Get all Test Runs under the first Test Suite
@test_runs = @test_suites.first.test_runs
```

Of course, you can skip having to chain parent to children to find what you need by using the `find_by` method.

```ruby
# Find a specific Test Suite under the current Project
@test_suite = QTest::TestSuite.find_by(project: @project, id: 5)
```

You don't have to pass in an object for the parent, you can simply use an ID.

```ruby
# Find a specific Test Suite under a Project
@test_suite = QTest::TestSuite.find_by(project: 3, id: 5)
```

Query parameters can also be passed:

```ruby
# Get all Test Cases after page 5 with properties expanded under a Project Module
@test_cases = QTest::TestCase.find_by(project: 3, module: 2, page: 5, expand_properties: true)
```

Some APIs are curently missing (TODO: list of NYI).

The complete QTest API documentation can be found [here](https://support.qasymphony.com/hc/en-us/sections/200394159-APIs-SDKs).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
