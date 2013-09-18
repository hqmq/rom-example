require 'spec_helper'
require 'fileutils'

describe 'JSON Adapter' do
  let(:fixture_file){ 'spec/fixtures/users.json' }
  let(:env) do
    env = ROM::Environment.setup(users: "json://#{fixture_file}")

    env.schema do
      base_relation :users do
        repository :users

        attribute :id,   Integer
        attribute :name, String

        key :id
      end
    end

    env.mapping do
      users do
        model User
        map :id, :name
      end
    end
    env
  end

  it "finds users" do
    env.session do |s|
      s[:users].count.should == 2
      john = s[:users].restrict(id: 1).one
      john.name.should == 'John'
      john.id.should == 1
    end
  end

  context "persisting data" do
    before(:each) do
      original_path = fixture_file.clone
      fixture_file['.json'] = '.tmp.json'
      FileUtils.copy(original_path, fixture_file)
    end

    after(:each) do
      FileUtils.rm(fixture_file)
    end

    it "can insert new user" do
      env.session do |s|
        johnny = User.new(name: "Johnny Appleseed", id: 3)
        s[:users].insert(johnny)
        s.flush
      end

      File.read(fixture_file).should include("Johnny Appleseed")
    end

    it "can update a user" do
      env.session do |s|
        john = s[:users].restrict(id: 1).one
        john.name = "Buddy"
        s[:users].save(john)
        s.flush
      end

      File.read(fixture_file).should include("Buddy")
    end
  end
end
