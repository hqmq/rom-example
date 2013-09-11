require 'bundler'
Bundler.setup(:test)
require 'rspec'
require 'rom'
require_relative '../lib/user'

RSpec.configure do |c|
  c.color = true
  c.order = :rand
end
