require 'bundler'
Bundler.setup(:test)
require 'rspec'
require 'rom'
require 'axiom-memory-adapter'
require_relative '../lib/adapter/yaml'
require_relative '../lib/user'


RSpec.configure do |c|
  c.color = true
  c.order = :rand
end
