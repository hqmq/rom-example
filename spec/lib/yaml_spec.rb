require 'spec_helper'

describe 'YAML Adapter' do
  before(:each) do
    @env = ROM::Environment.setup(memory: 'yaml://spec/fixtures/users.yml')

    @env.schema do
      base_relation :users do
        repository :memory

        attribute :id,   Integer
        attribute :name, String

        key :id
      end
    end

    @env.mapping do
      users do
        map :id, :name
        model User
      end
    end
  end

  it "finds users" do
    @env.session do |s|
      s[:users].count.should == 2
      john = s[:users].restrict(id: 1).one
      john.name.should == 'John'
      john.id.should == 1
    end
  end
end
