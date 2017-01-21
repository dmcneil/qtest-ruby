require 'pry'
require 'pry-byebug'
require_relative 'lib/qtest'

client = QTest::Client.new
client.configure do |c|
  c.base_uri = 'http://10.20.13.1'
end
client.auth username: 'dmcneil@pindropsecurity.com', password: '58R4paOy3CaMeCA'

p = QTest::Project.find_by(id: 3)
release = p.releases.select { |r| r.id == 46 }.first
test_cycle = release.test_cycles.select { |tc| tc.id == 117 }.first
test_suite = test_cycle.test_suites.select { |ts| ts.id = 298 }.first
test_run = test_suite.test_runs.select { |tr| tr.id = 5677 }.first

# test_cycle.create_test_suite(name: 'Automation Test')

puts 'Done'
