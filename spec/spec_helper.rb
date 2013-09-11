require 'bundler'
Bundler.setup(:test)
require 'rspec'

RSpec.configure do |c|
  c.color = true
  c.order = :rand
end
